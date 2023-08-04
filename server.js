//import modules
const express = require('express');
const session = require('express-session');
const bodyParser = require('body-parser');
const redis = require('redis');
const redisStore = require('connect-redis')(session);
const mysql = require('mysql');
const { ExpressPeerServer } = require('peer');
const nodemailer = require('nodemailer');
const https = require('https');
const http = require('http');
const multer = require('multer');
const path = require('path');
const fs = require('fs');
const { v4: uuidv4 } = require('uuid');
const sharp = require('sharp')
const crypto = require('crypto');
//const sizeOf = require('image-size');
const port = process.env.PORT || "443";

//constructors
const client  = redis.createClient();
const router = express.Router();
const app = express();
var privateKey = fs.readFileSync( 'private.key' );
var certificate = fs.readFileSync( 'certificate.crt' );
const server = https.createServer({
  key: privateKey,
  cert: certificate
},app);

const httpApp = express();
httpApp.set('port', process.env.PORT || 80);
httpApp.get("*", function (req, res, next) {
  res.redirect('https://' + req.headers.host + req.originalUrl);
});

http.createServer(httpApp).listen(httpApp.get('port'), function()
{
  console.log('Express HTTP server listening on port ' + httpApp.get('port'));
});

const transporter = nodemailer.createTransport(
  {
    host: "smtp.mail.yahoo.com",
    secure: true,
    auth:
    {
      user: 'mbertolini99@yahoo.com',
      pass: 'bgprlsykjuoxgcmf'
    },
    port: 465
  });

  //directory upload
  const storage = multer.diskStorage(
    {
      destination: (req, file, cb) =>
      {
        cb(null, "public/adminZone/immagini/bike/")
      },
      filename: (req, file, cb) =>
      {
        cb(null, Date.now() + "-" + file.originalname)
      },
    });

    //ServerPeer
    const peerServer = ExpressPeerServer(server,
      {
        proxied: true,
        debug: true,
        path: '/public',
        ssl:{}
      });

      //MySQLConnection
      const connection = mysql.createConnection(
        {
          host : 'localhost',
          user : 'root',
          password : 'Matisse2023!',
          database : 'bikerent'
        });

        // uploads file
        const upload = multer({limits:{fileSize:4000000}}).single('avatar');
        const fixLongitude = 10.3441534;
        const fixLatitude = 44.8361505;
        var connected = [];

        //appSessionInizialize
        app.use(session(
          {
            secret: 'MySecretBertiv2022!!',
            store: new redisStore({host: 'localhost', port: 6379, client: client, ttl: 260}),
            saveUninitialized: false,
            resave: false
          }));

          app.use("/",express.static(__dirname+"/public"));
          app.use(bodyParser.json());
          app.use(bodyParser.urlencoded({ extended: false }));
          app.use(peerServer);

          //MySQL connection
          connection.connect();

          function genOTP()
          {
            var cod="";
            for (var i=0; i<5; i++)
            {
              var num = Math.round(Math.random() * 9);
              cod = cod + String(num);
            }
            return cod;
          }

          class SpecBike
          {
            constructor(dateS, dateF, idBike, rentCost,specBike) {
              this.dateS = dateS;
              this.dateF = dateF;
              this.idBike = idBike;
              this.rentCost = rentCost;
              this.specBike = specBike;
            }

            getDateS()
            {
              return this.dateS;
            }

            getDateF()
            {
              return this.dateF;
            }

            getID()
            {
              return this.idBike;
            }

            getRentCost()
            {
              return this.rentCost;
            }

            getSpecBike()
            {
              return this.specBike;
            }
          }

          function checkmultiple(lista)
          {
            var num = lista.length;
            while (num%3!=0)
            {
              num+=1;
            }
            return num;
          }

          function arrayRemoveElement(arr,item)
          {
            var pos = arr.indexOf(item);
            if (pos>=0)
            {
              arr.splice(pos,1);
            }
            return arr;
          }

          function takePeerId()
          {
            let myuuid = uuidv4();
            return myuuid;
          }

          function plusCheck(lista,ad,dd,req)
          {
            if (req.session.items.length == 0)
            {
              return lista;
            }

            var n=0;
            while (n<lista.length)
            {
              var removed=false;
              var k=0;
              var currid=lista[n].IDbike;

              while (k<req.session.items.length && removed==false)
              {
                var item = req.session.items[k];
                if (item.idBike==currid && !((item.dateF < ad) || (dd < item.dateS)))
                {
                  removed=true;
                  lista.splice(n,1);
                }
                k+=1;
              }

              if (removed==false)
              {
                n+=1;
              }
            }
            return lista;
          }

          function writeHtml(items)
          {
            if (items.length<=0)
            {
              return "<p><b>No bikes avaiable for this period or you already added bikes in your cart.</b></p>";
            }

            var html="";
            var totitems=checkmultiple(items);
            for(var i=0; i<(totitems/3); i++)
            {
              html+="<div class='row'>";
              for(var j=0; j<3; j++)
              {
                html+="<div class='col'><figure class='figure'>";

                if(((i*3)+j)>=items.length)
                {
                  html+="<div class='mb-3'><figcaption class='figure-caption'  style='color: white'></figcaption></div><div class='mb-3'></div>";
                }
                else
                {
                  html+="<img src='adminZone/immagini/bike/"+items[(i*3)+j].IDbike+".jpg' class='figure-img img-fluid rounded' alt='...'><div class='mb-3'><figcaption class='figure-caption'  style='color: white'>";
                  html+=items[(i*3)+j].brand+" "+items[(i*3)+j].model+" <br>TAGLIA "+items[(i*3)+j].bSize+", RENT PRICE "+items[(i*3)+j].rentCost+"€/day</figcaption></div>";
                  html+="<div class='mb-3'><button type='button' id='"+items[(i*3)+j].IDbike+"' name='"+items[(i*3)+j].IDbike+"' class='btn btn-secondary addtocart'>Select</button></div>";
                }
                html+="</figure></div>";
              }
              html+="</div>";
            }
            return html;
          }

          function writeHtmlOrder(mail,IDbook)
          {
            var html="<h2><b>DETTAGLIO PRENOTAZIONE</b><br>";
            html+="Gentile cliente, grazie di esserti prenotato.<br>";
            html+="Il codice della tua prenotazione &egrave;: <b>"+IDbook+"</b>.<br>";
            html+="Ricorda questo codice, &egrave; IMPORTANTE!<br>";
            html+="Ti sar&agrave; inviata una mail all&rsquo; indirizzo "+mail+".<br>";
            html+="<b>Appennino Adventures</b> ti aspetta!</h2>";
            return html;
          }

          function writeHtmlPayment(items)
          {
            if (items.length<=0)
            {
              return "<p><b>Your cart is empty!</b></p>";
            }

            var html="";
            for(i=0; i<items.length; i++)
            {
              var item=items[i];
              html+="<figure class='figure' style='background:#c0c0c0; height:30vh; border-radius: 10px 10px 10px 10px; margin-right:1vw'>";
              html+="<button type='button' id='"+i+"' name='"+i+"' style='margin-left:1vw; margin-bottom:10vh;margin-top:0vh;' onclick='showDetailsBike()' class='btn btn-outline-light'><i class='fas fa-trash-alt'></i></button>";
              html+="<img src='adminZone/immagini/bike/"+item.idBike+".jpg' class='figure-img img-fluid rounded' style='margin-left:2vw;margin-right:2vw;margin-top:2vh;height:20vh; weight:20vh;' alt='...'><div class=' mb-3'>";
              html+="<p  style='color:#000;margin-left:2vw;'>Dal "+item.dateS+" Al "+item.dateF+"</p>";
              html+="</div></figure>"
            }
            return html;
          }

          function writeHtmlByObj(items)
          {
            if (items.length<=0)
            {
              return "No bikes avaiable for this period or you already added bikes in your cart.";
            }

            var html="";
            var n=0;
            items.forEach(function(row)
            {
              var objBike=row.specBike;
              html+="<tr><td id='idBike"+row.idBike+"'>"+row.idBike+"</td><td>"+objBike.brand+"</td><td >"+objBike.model+"</td><td>"+objBike.rentCost+"</td><td>"+objBike.type+"</td><td>"+objBike.bSize+"</td>";
              html+="<td>"+row.dateS+"</td><td>"+row.dateF+"</td>";
              html+="<td><button type='button' id='"+n+"' name='"+n+"' class='btn btn-outline-light'><i class='fas fa-trash-alt'></i></button></td></tr>";
              n+=1;
            });
            return html;
          }

          function writeHtmlLogin(items)
          {
            if (items.length<=0)
            {
              return "No bikes avaiable for this period or you already added bikes in your cart.";
            }

            var html="";
            items.forEach(function(row)
            {
              var id=row.IDbike;
              var brand=row.brand;
              var model=row.model;
              html+="<tr><td id='idBike"+id+"'>"+id+"</td><td>"+brand+"</td><td >"+model+"</td><td>"+row.rentCost+"</td><td>"+row.type+"</td><td>"+row.bSize+"</td>";
              html+="<td><button type='button' id='"+id+"' name='"+id+"' class='btn btn-outline-light'><i class='far fa-hand-pointer'></i></button></td></tr>";
            });
            return html;
          }

          function writeToday(items)
          {
            if (items.length<=0)
            {
              return "No bikes exit or return today.";
            }

            var html="";
            items.forEach(function(row)
            {
              var idbook=row.idbook;
              var name=row.name;
              var surname=row.surname;
              var mail=row.mail;
              var idbike=row.idbike;
              html+="<tr><td>"+idbook+"</td><td>"+name+"</td><td >"+surname+"</td><td>"+mail+"</td><td>"+idbike+"</td></tr>";
            });
            return html;
          }

          function newTotal(rentCost,diff,req)
          {
            var effTot=0;
            var arrDetails=req.session.coupInfo;
            if (arrDetails.percent!=0)
            {
              perc=arrDetails.percent;
              effTot=req.session.totAmount*100/(100-perc);
              effTot-=(rentCost)*(diff+1);
              effTot=effTot-(perc*effTot/100);
            }
            else
            {
              var amount=arrDetails.amount;
              effTot=req.session.totAmount+amount;
              effTot-=(rentCost)*(diff+1);
              effTot=effTot-amount;
            }
            return effTot;
          }

          function checkDimension(path)
          {
            const dimensions = sizeOf(path);
            if(dimensions.width==600 && dimensions.height==450)
            {
              return true;
            }
            else
            {
              return false;
            }
          }

          function sendEmail(code, email)
          {
            var emails = [];
            if (email=="*")
            {
              connection.query("SELECT mail FROM client",function(err, rows, fields)
              {
                if(rows.length>0)
                {
                  rows.forEach (function(row)
                  {
                    emails.push(row.mail);
                  });
                }
                var message = "<html><head></head><body><h1>YOUR COUPON CODE</h1><h3>Dear user, this is a coupon for you!</h3><p><b>"+code+"</b></p></body></html>";
                emails.forEach(function(email)
                {
                  var mailOptions =
                  {
                    from: '"RENTBIKE" <sender@rentbikeappennino.info>',
                    to: email,
                    subject: 'COUPON',
                    html: message
                  };
                  transporter.sendMail(mailOptions, function(error, info){if (error){console.log(error);}});
                });
              });
            }
            else
            {
              emails.push(email);
              var message = "<html><head></head><body><h1>YOUR COUPON CODE</h1><h3>Dear user, this is a coupon for you!</h3><p><b>"+code+"</b></p></body></html>";
              emails.forEach(function(email)
              {
                var mailOptions =
                {
                  from: '"RENTBIKE" <sender@rentbikeappennino.info>',
                  to: email,
                  subject: 'COUPON',
                  html: message
                };
                transporter.sendMail(mailOptions, function(error, info){if (error) {console.log(error);}});
              });
            }
          }

          function getDistanceKm(lat1,lon1,lat2,lon2)
          {
            var R = 6371; // Radius of the earth in km
            var dLat = deg2rad(lat2-lat1);  // deg2rad below
            var dLon = deg2rad(lon2-lon1);
            var a = Math.sin(dLat/2) * Math.sin(dLat/2) + Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) * Math.sin(dLon/2) * Math.sin(dLon/2);
            var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
            var d = R * c; // Distance in km
            return d.toFixed(4);
          }

          function deg2rad(deg)
          {
            return deg * (Math.PI/180)
          }

          function toHash(data)
          {
            return crypto.createHash('md5').update(data).digest("hex");
          }

          router.get('/',(req,res) =>
          {
            res.sendFile(__dirname+'/public/index.html');
          });

          //Login requests manager
          router.post("/login", (req, res) =>
          {
            if(req.body.goToLoginPage)
            {
              res.send('/login.html');
            }

            if(req.body.loginCl)
            {
              connection.query("SELECT * FROM client WHERE mail=? AND password=?",[req.body.mail,toHash(req.body.psw)],function(err, rows, fields)
              {
                if (rows.length>0)
                {
                  delete req.session.role;
                  req.session.mail=req.body.mail;
                  req.session.cf=rows[0].cf;
                  req.session.name=rows[0].name;
                  req.session.totAmount=0.00;
                  req.session.forgotpsw=rows[0].forgotpsw;
                  req.session.items=[];
                  req.session.goToOrder=false;

                  if (rows[0].forgotpsw != null)
                  {
                    res.send([0,'/public/password.html']);
                  }
                  else
                  {
                    res.send([0,'/']);
                  }
                }
                else
                {
                  res.send([1,""]);
                }
              });
            }

            if (req.body.register)
            {
              var cf = req.body.cf.toUpperCase();
              var email = req.body.email;
              connection.query("SELECT * FROM client WHERE mail=? OR cf=?",[email,cf],function(err, rows, fields)
              {
                if (rows.length<=0)
                {
                  var name = req.body.name;
                  var surname = req.body.surname;
                  var addr = req.body.addr;
                  var birth = req.body.birth;
                  var tel = req.body.tel;
                  var passw = toHash(req.body.passw);
                  connection.query("INSERT INTO client(cf, name, surname, mail, phone, password, birthday, address) VALUES(?,?,?,?,?,?,?,?)",[cf,name,surname,email,tel,passw,birth,addr],function(err, rows, fields)
                  {
                    if (err==null)
                    {
                      var message = "<html><head></head><body><h1>CONGRATULATIONS FOR YOUR REGISTRATION</h1><h3>Dear user, thank you to join with us!</h3><p>To log-in click <a href='www.rentbikeappennino.info/public/login.html'>here</a> and first insert your email then your password!</p><p>Your password is <b>"+req.body.passw+"</b>. You can change the password <a href='80.211.229.225/public/forgot.html'>here</a> following the recover password procedure.</p><p>ENJOY YOURSELF!</p></body></html>";
                      var mailOptions =
                      {
                        from: '"RENTBIKE" <sender@rentbikeappennino.info>',
                        to: email,
                        subject: 'WELCOME',
                        html: message
                      };
                      transporter.sendMail(mailOptions, function(error, info){if (error) {console.log(error);}});
                      res.send("0");
                    }
                    else
                    {
                      res.send("2");
                    }
                  });
                }
                else
                {
                  res.send("1");
                }
              });
            }
          });

          router.post('/session',(req,res) =>
          {
            if(req.body.checkSessionEmail)
            {
              if (req.session.mail)
              {
                res.send(req.session.mail);
              }
              else
              {
                res.send('');
              }
            }

            if(req.body.checkPageOrder)
            {
              if (req.session.goToOrder)
              {
                res.send("ok");
              }
              else
              {
                res.send("");
              }
            }

            if(req.body.setPageOrder)
            {
              req.session.goToOrder=true;
              res.send("ok");
            }

            if(req.body.checkSessionName)
            {
              if (req.session.mail)
              {
                res.send(req.session.name);
              }
              else
              {
                res.send('');
              }
            }

            if(req.body.checkSessionClient)
            {
              if (req.session.mail)
              {
                res.send(true);
              }
              else
              {
                res.send(false);
              }
            }

            if(req.body.checkSessionRole)
            {
              if (req.session.role)
              {
                res.send(true);
              }
              else
              {
                res.send(false);
              }
            }

            if(req.body.destroySession)
            {
              req.session.destroy((err) =>
              {
                if(err)
                {
                  return console.log(err);
                }
                res.send('/');
              });
            };
          });

          router.post('/forgot',(req,res) =>
          {
            if(req.body.setOtp)
            {
              connection.query("SELECT * FROM client WHERE mail=?",[req.body.mail],function(err, rows, fields)
              {
                if (rows.length>0)
                {
                  var email=req.body.mail;
                  var codetosend = genOTP();
                  connection.query("UPDATE client SET forgotpsw="+codetosend+" WHERE mail = ?",[email]);
                  var message = "<html><head></head><body><h1>RECOVER YOUR PASSWORD</h1><h3>Dear user, here is your code to recover your password.</h3><p><b>"+codetosend+"</b></p></body></html>";
                  var mailOptions =
                  {
                    from: '"RENTBIKE" <sender@rentbikeappennino.info>',
                    to: email,
                    subject: 'Your OTP code',
                    html: message
                  };
                  transporter.sendMail(mailOptions, function(error, info){if (error) {console.log(error);}});
                  res.send("1");
                }
                else
                {
                  var val_error = "ERRORE! Dati errati o utente non registrato. Non possiamo inviare OTP!";
                  res.send(val_error);
                }
              });
            }

            if(req.body.Psw)
            {
              var val_error =  "ERRORE! Dati errati o utente non registrato.";
              if(req.body.code.length<=0)
              {
                res.send([1,val_error]);
              }
              else
              {
                connection.query("SELECT * FROM client WHERE mail=? AND forgotpsw=?",[req.body.mail,req.body.code],function(err, rows, fields)
                {
                  if (rows.length>0)
                  {
                    var newPsw = genOTP();
                    connection.query("UPDATE client SET password=? WHERE mail = ?",[toHash(newPsw),req.body.mail]);
                    var message = "<html><head></head><body><h1>YOUR NEW PASSWORD</h1><h3>Dear user, here is your new password.</h3><p><b>" + newPsw + "</b></p></body></html>";
                    var mailOptions = {
                      from: '"RENTBIKE" <sender@rentbikeappennino.info>',
                      to: req.body.mail,
                      subject: 'Your new password',
                      html: message
                    };
                    transporter.sendMail(mailOptions, function(error, info){if (error) {console.log(error);}});
                    res.send([0,"Password changed successfully!"]);
                  }
                  else
                  {
                    res.send([2,val_error]);
                  }
                });
              }
            }
          });

          router.post('/booking',(req,res) =>
          {
            if(req.body.btcheck)
            {
              var ad = req.body.var1;
              var dd = req.body.var2;
              connection.query("SELECT * FROM bike b WHERE b.IDBike NOT IN (SELECT newtable.nbike FROM (SELECT s.bikeBooked AS nbike, COUNT(*) AS conta FROM specsbook s WHERE NOT((s.dateFinish < ?) OR (? < s.dateBegin)) GROUP BY nbike HAVING conta>0) AS newtable) AND b.available='Y'",[ad,dd],function(err, rows, fields)
              {
                if(rows.length>0)
                {
                  res.send(writeHtml(plusCheck(rows,ad,dd,req)));
                }
                else
                {
                  res.send("<p>No bikes avaiable for this period.</p>");
                }
              });
            }

            if(req.body.idclick)
            {
              var ad = req.body.ad;
              var dd = req.body.dd;
              var bid = req.body.idclk;
              connection.query("SELECT rentCost FROM bike WHERE IDbike=?",[bid],function(err, rows, fields)
              {
                if(rows.length>0)
                {
                  var dt1 = new Date(ad);
                  var dt2 = new Date(dd);
                  var diffdate = Math.floor((Date.UTC(dt2.getFullYear(), dt2.getMonth(), dt2.getDate()) - Date.UTC(dt1.getFullYear(), dt1.getMonth(), dt1.getDate()) ) /(1000 * 60 * 60 * 24));
                  req.session.totAmount+=(rows[0].rentCost)*(diffdate+1);
                  req.session.items.push(new SpecBike(ad,dd,bid,rows[0].rentCost));
                  res.send(true);
                }
                else
                {
                  res.send(false);
                }
              });

            }

            if(!req.session.items)
            {
              req.session.totAmount = 0.00;
              req.session.items = [];
            }

            if(req.body.cleanCart)
            {
              req.session.totAmount = 0.00;
              req.session.items = [];
              res.send(true);
            }

            if(req.body.totItems)
            {
              var num = req.session.items.length;
              var tot = req.session.totAmount;
              res.send([num,tot]);
            }
          });

          router.post('/password',(req,res) =>
          {
            if(req.body.setPsw)
            {
              var mail=req.session.mail;
              var psw=toHash(req.body.password);
              connection.query("UPDATE client SET password=?, forgotpsw=NULL WHERE mail LIKE ?",[psw,mail]);
              res.send("Password changed successfully!");
            }
          });

          router.post('/payment',(req,res) =>
          {
            var cart = req.session.items;
            if(req.body.rm)
            {
              key=req.body.remove;
              var dt1 = new Date(cart[key].dateS);
              var dt2 = new Date(cart[key].dateF);
              var diffdate = Math.floor((Date.UTC(dt2.getFullYear(), dt2.getMonth(), dt2.getDate()) - Date.UTC(dt1.getFullYear(), dt1.getMonth(), dt1.getDate()) ) /(1000 * 60 * 60 * 24));
              if (req.session.coupInfo)
              {
                var newTot=newTotal(cart[key].rentCost,diffdate,req);
                req.session.totAmount=newTot;
              }
              else
              {
                req.session.totAmount-=(cart[key].rentCost)*(diffdate+1);
              }
              cart.splice(key,1);
              req.session.items = cart;
              html=writeHtmlPayment(cart);
              res.send(html+'///'+req.session.totAmount);
            }

            if (req.body.view)
            {
              var html=writeHtmlPayment(cart);
              res.send(html);
            }

            if (req.body.cost)
            {
              req.session.totConfirm=req.session.totAmount;
              res.send(req.session.totAmount);
            }

            if (req.body.cc)
            {
              var couponName = req.body.confirmCoupon;
              if (req.session.setCouponID)
              {
                res.send('yetUsed:'+req.session.setCouponNAME.length);
              }

              connection.query("SELECT * FROM coupon WHERE IDcoupon NOT IN (SELECT coup.IDcoupon FROM coupon coup, booking book WHERE coup.IDcoupon=book.idCoupon AND book.cfUser=? AND coup.name=?) AND name=? AND (expire>=date(CURRENT_TIMESTAMP) OR expire IS NULL) AND (idUser IS NULL OR idUser=?)",[req.session.cf,couponName,couponName,req.session.mail],function(err, rows, fields)
              {
                var response = "no";
                if (rows.length>0)
                {
                  req.session.setCouponNAME=couponName;
                  var idCoupon = rows[0].IDcoupon;
                  req.session.coupInfo=rows[0];
                  var attTotal = req.session.totAmount;
                  if (rows[0].percent!=0)
                  {
                    var perc=rows[0].percent;
                    attTotal=attTotal-(perc*attTotal/100);
                  }
                  else
                  {
                    var am=rows[0].amount;
                    attTotal=attTotal-am;
                  }

                  if(attTotal>0.00)
                  {
                    req.session.totAmount=attTotal;
                    response="ok";
                    req.session.setCouponID=idCoupon;
                  }
                  else
                  {
                    response="disc";
                    req.session.totAmount=0.00;
                    req.session.setCouponID=idCoupon;
                    req.session.goToOrder=true;
                  }
                }
                else
                {
                  response="nook";
                }
                res.send( response+':'+req.session.totAmount);
              });
            }

            if (req.body.couponSet)
            {
              if (req.session.setCouponID)
              {
                res.send(req.session.setCouponNAME);
              }
              else
              {
                res.send('not');
              }
            }

            if (req.body.setPageAfterCoupon)
            {
              if (req.session.setCouponID && !req.session.count)
              {
                req.session.count = 1;
                res.send(req.session.setCouponNAME);
              }
              else
              {
                res.send('no');
              }
            }
          });

          router.post('/order',(req,res) =>
          {
            var tot=req.session.totAmount;
            var mail=req.session.mail;
            var cf=req.session.cf;
            var insert="";
            var idBook=0;
            var cart=req.session.items;
            var check=true;

            if (req.session.setCouponID)
            {
              var idC = req.session.setCouponID;
              insert="INSERT INTO booking(cfUser, costTotal, idCoupon) VALUES('"+cf+"','"+tot+"','"+idC+"')";
            }
            else
            {
              insert="INSERT INTO booking(cfUser, costTotal) VALUES('"+cf+"','"+tot+"')";
            }

            connection.query(insert,function(err, rows, fields)
            {
              idBook = rows.insertId;
              cart.forEach(function(item, index)
              {
                var dateStart=item.dateS;
                var dateStop=item.dateF;
                var bikeB=item.idBike;

                connection.query('SELECT * FROM specsbook WHERE dateBegin=? AND dateFinish=? AND bikeBooked=?', [dateStart,dateStop,bikeB], function (err, rows, fields)
                {
                  if (rows.length>0)
                  {
                    connection.query("DELETE FROM booking WHERE IDbooking=?",[idBook]);
                    connection.query("DELETE FROM specsbook WHERE idBook=?",[idBook]);
                    var code = "CREDIT"+idBook;
                    connection.query("INSERT INTO coupon(name,amount,percent,idUser,expire) VALUES(?,?,0,?,NULL)",[code,tot,req.session.mail]);
                    sendEmail(code,req.session.mail);
                    check=false;
                  }
                  else
                  {
                    insert="INSERT INTO specsbook(dateBegin, dateFinish, bikeBooked, idBook) VALUES(?,?,?,?)";
                    connection.query(insert,[dateStart,dateStop,bikeB,idBook]);
                  }

                  if (index==(cart.length-1) && check)
                  {
                    var emailpeers="";
                    connection.query('SELECT * FROM specsbook WHERE idBook=?', [idBook], function (err, result, fields)
                    {
                      if (result.length>0)
                      {
                        for (var i=0; i<result.length; i++)
                        {
                          var newIdPeer=takePeerId();
                          emailpeers+="Bike n° "+result[i].bikeBooked+" from "+result[i].dateBegin.toLocaleDateString()+" to "+ result[i].dateFinish.toLocaleDateString()+" &#9658 <a href='https://80.211.229.225/public/AreaNavigator/navigatorLogin.html?idPeer=" +newIdPeer+ "'>"+newIdPeer+"</a><br>";
                          connection.query('INSERT INTO clientPeer(idSpecBook,idPeer) VALUES(?,?)', [result[i].IDspecBook, newIdPeer]);
                        }
                        insert="INSERT INTO payment(idclient, idbook, paid) VALUES('"+cf+"',"+idBook+",1)";
                        connection.query(insert);
                        var message = "<html><head></head><body><h1>DETTAGLIO PRENOTAZIONE</h1><h3>Gentile cliente, grazie di esserti prenotato.</h3><p>Il codice della tua prenotazione &egrave;: <b>"+idBook+" </b>.</p><p>I codici per i tuoi tour sono:<br>"+emailpeers+"</p><p>Ricorda questi codici, sono IMPORTANTI! <b>Appennino Adventures</b> ti aspetta!</p></body></html>";
                        var mailOptions =
                        {
                          from: '"RENTBIKE" <sender@rentbikeappennino.info>',
                          to: mail,
                          subject: 'LA TUA PRENOTAZIONE',
                          html: message
                        };
                        transporter.sendMail(mailOptions, function(error, info){if (error) {console.log(error);}});
                        var html = writeHtmlOrder(mail,idBook);
                        req.session.totAmount=0.00;
                        req.session.items=[];
                        req.session.goToOrder=false;
                        delete req.session.setCouponID;
                        delete req.session.count;
                        delete req.session.setCouponNAME;
                        delete req.session.coupInfo;
                        delete req.session.totConfirm;
                        res.end(html);
                      }
                    });
                  }
                  else if (index==(cart.length-1) && !check)
                  {
                    req.session.totAmount=0.00;
                    req.session.items=[];
                    delete req.session.setCouponID;
                    delete req.session.count;
                    delete req.session.setCouponNAME;
                    delete req.session.coupInfo;
                    delete req.session.totConfirm;
                    res.end("");
                  }
                });
              });
            });
          });

          router.post('/reservedArea',(req,res) =>
          {
            if (req.body.Client)
            {
              email=req.session.mail;
              cf=req.session.cf;
              html="";
              connection.query("SELECT * FROM client WHERE mail=? OR cf=?",[email,cf],function(err, rows, fields)
              {
                if(rows.length>0)
                {
                  html+="<div class='row'><div class='p-3 border bg-dark mb-3' style='border-radius: 10px;color:white'><b>NAME: <b>"+rows[0].name+"</div></div>";
                  html+="<div class='row'><div class='p-3 border bg-dark mb-3' style='border-radius: 10px;color:white'><b>SURNAME: <b>"+rows[0].surname+"</div></div>";
                  html+="<div class='row'><div class='p-3 border bg-dark mb-3' style='border-radius: 10px;color:white'><b>FISCAL CODE: <b>"+rows[0].cf+"</div></div>";
                  html+="<div class='row'><div class='p-3 border bg-dark mb-3' style='border-radius: 10px;color:white'><b>EMAIL: <b>"+rows[0].mail+"</div></div>";
                  html+="<div class='row'><div class='p-3 border bg-dark mb-3' style='border-radius: 10px;color:white'><b>ADDRESS: <b>"+rows[0].address+"</div></div>";
                  html+="<div class='row'><div class='p-3 border bg-dark mb-3' style='border-radius: 10px;color:white'><b>PHONE: <b>"+rows[0].phone+"</div></div>";
                  html+="<div class='row'><div class='p-3 border bg-dark mb-3' style='border-radius: 10px;color:white'><b>BIRTHDAY: <b>"+rows[0].birthday.toLocaleDateString()+"</div></div></div>";
                }
                else
                {
                  html="<p style='color:white'><b>SERVER ERROR!<b></p>";
                }
                res.send(html);
              });
            }

            if (req.body.Order)
            {
              cf=req.session.cf;
              html="";
              connection.query("SELECT booking.IDbooking AS IDbooking, booking.dateBook AS dateBook, booking.costTotal AS costTotal, coupon.name AS cname FROM client, booking LEFT JOIN coupon ON coupon.IDcoupon=booking.idCoupon WHERE booking.cfUser=client.cf AND client.cf=? ORDER BY booking.IDbooking DESC",[cf],function(err, rows, fields)
              {
                if(rows.length>0)
                {
                  rows.forEach(function(row)
                  {
                    if(row.cname==null)
                    {
                      row.cname="-";
                    }
                    html+="<tr><td>"+row.IDbooking+"</td><td>"+row.dateBook.toLocaleDateString()+"</td><td>"+row.costTotal+"</td><td>"+row.cname+"</td><td><button class='btn-primary' type='button' id='"+row.IDbooking+"' name='button'><i class='fas fa-info'></i></button></td></tr>";
                  });
                }
                else
                {
                  html="<tr style='color:white'><b>NO ORDER!<b></tr>";
                }
                res.send(html);
              });
            }

            if (req.body.Coupon)
            {
              mail=req.session.mail;
              html="";
              connection.query("select * from coupon where (idUser=? OR idUser IS NULL) AND (coupon.expire>=date(CURRENT_TIMESTAMP) OR coupon.expire IS NULL) AND coupon.IDcoupon NOT IN (SELECT booking.idCoupon FROM booking where booking.idCoupon IS NOT NULL)",[mail],function(err, rows, fields)
              {
                if(rows.length>0)
                {
                  rows.forEach(function(row)
                  {
                    if(row.expire==null)
                    {
                      row.expire="Without limits";
                    }
                    else
                    {
                      row.expire=row.expire.toLocaleDateString();
                    }

                    if(row.percent == 0)
                    {
                      row.percent="-";
                      row.amount=row.amount+" €";
                    }
                    else if (row.amount == 0)
                    {
                      row.amount="-";
                      row.percent=row.percent+" %";
                    }
                    html+="<tr><td>"+row.name+"</td><td>"+row.amount+"</td><td>"+row.percent+"</td><td>"+row.expire+"</td></tr>";
                  });
                }
                else
                {
                  html="<tr style='color:white'><b>NO COUPON!<b></tr>";
                }
                res.send(html);
              });
            }

            if(req.body.OrderDetails)
            {
              var id=req.body.idclicked;
              var html="";
              connection.query("SELECT * FROM specsbook WHERE idBook=?",[id],function(err, rows, fields)
              {
                if(rows.length>0)
                {
                  rows.forEach(function(row)
                  {
                    html+="<tr><td>"+row.dateBegin.toLocaleDateString()+"</td><td>"+row.dateFinish.toLocaleDateString()+"</td><td>"+row.bikeBooked+"</td></tr>";
                  });
                }
                else
                {
                  html="<p>No BOOK ID found in Database.</p>";
                }
                res.send(html);
              });
            }
          });

          //adminZone

          router.post('/Alogin',(req,res) =>
          {
            if(req.body.register)
            {
              var cf = req.body.cf.toUpperCase();
              var email = req.body.email;
              connection.query("SELECT * FROM client WHERE mail=? OR cf=?",[email,cf],function(err, rows, fields)
              {
                if(rows.length<=0)
                {
                  var name = req.body.name;
                  var surname = req.body.surname;
                  var birth = req.body.birth;
                  var phone = req.body.tel;
                  var address = req.body.addr;
                  var psw = req.body.psw;
                  var insert="INSERT INTO client(cf, name, surname, mail, phone, password, birthday, address) VALUES(?,?,?,?,?,?,?,?)";
                  connection.query(insert,[cf,name,surname,email,phone,toHash(psw),birth,address]);
                  var message = "<html><head></head><body><h1>CONGRATULATIONS FOR YOUR REGISTRATION</h1><h3>Dear user, thank you to join with us!</h3><p>To log-in click <a href='www.rentbikeappennino.info'>here</a> and first insert your email then your password!</p><p>Your password is <b>"+psw+"</b>. You can change the password <a href='80.211.229.225/public/forgot.html'>here</a> following the recover password procedure.</p><p>ENJOY YOURSELF!</p></body></html>";
                  var mailOptions =
                  {
                    from: '"RENTBIKE" <sender@rentbikeappennino.info>',
                    to: email,
                    subject: 'WELCOME',
                    html: message
                  };
                  transporter.sendMail(mailOptions, function(error, info){if (error) {console.log(error);}});
                  res.send("You have registered the client!");
                }
                else
                {
                  res.send("Fiscal code and/or email already exist! Please,login yourself.");
                }
              });
            }

            if (req.body.writeCart)
            {
              var html="";
              if ((req.session.items) && (req.session.items.length)>0)
              {
                html=writeHtmlByObj(req.session.items);
                res.send([html,req.session.totAmount.toString()]);
              }
              else
              {
                res.send([html,""]);
              }
            }

            if (req.body.checkConfirm)
            {
              var ret="";
              if ((req.session.items.length)>0 && req.session.bookMail && req.session.bookCf)
              {
                ret="ok";
              }
              res.send(ret);
            }

            if (req.body.cleancart)
            {
              req.session.totAmount=0;
              req.session.items=[];
              res.send('ok');
            }

            if (req.body.btck)
            {
              var ad = req.body.var1;
              var dd = req.body.var2;

              if (!req.session.items)
              {
                req.session.items=[];
                req.session.totAmount=0.00;
              }

              if (ad.length>0 && dd.length>0 && ad<=dd)
              {
                connection.query("SELECT * FROM bike b WHERE b.IDBike NOT IN (SELECT newtable.nbike FROM (SELECT s.bikeBooked AS nbike, COUNT(*) AS conta FROM specsbook s WHERE NOT((s.dateFinish < ?) OR (? < s.dateBegin)) GROUP BY nbike HAVING conta>0) AS newtable) AND b.available='Y'",[ad,dd],function(err, rows, fields)
                {
                  if(rows.length>0)
                  {
                    res.send(writeHtmlLogin(plusCheck(rows,ad,dd,req)));
                  }
                  else
                  {
                    res.send("<p>No bikes avaiable for this period.</p>");
                  }
                });
              }
              else
              {
                res.send("<p>Insert correct fields.</p>");
              }
            }

            if (req.body.btex)
            {
              var ret="";
              var date=req.body.btExit;
              connection.query("SELECT b.IDbooking AS idbook, c.name AS name, c.surname AS surname, c.mail AS mail, s.bikeBooked AS idbike  from specsbook s, booking b, client c where s.idBook=b.IDbooking and b.cfUser=c.cf and s.dateBegin=?",[date],function(err, rows, fields)
              {
                if(rows.length>0)
                {
                  ret = writeToday(rows);
                }
                else
                {
                  ret="no";
                }
                res.send(ret);
              });
            }

            if (req.body.btrt)
            {
              var ret="";
              var date=req.body.btReturn;
              connection.query("SELECT b.IDbooking AS idbook, c.name AS name, c.surname AS surname, c.mail AS mail, s.bikeBooked AS idbike  from specsbook s, booking b, client c where s.idBook=b.IDbooking and b.cfUser=c.cf and s.dateFinish=?",[date],function(err, rows, fields)
              {
                if(rows.length>0)
                {
                  ret = writeToday(rows);
                }
                else
                {
                  ret="no";
                }
                res.send(ret);
              });
            }

            if (req.body.verifyEmail)
            {
              var ret = "";
              var mail = req.body.verifyEmail;
              connection.query("SELECT * FROM client WHERE mail=?",[mail],function(err, rows, fields)
              {
                if (rows.length>0)
                {
                  ret=rows[0].name+' '+rows[0].surname+' ('+rows[0].cf+')';
                  req.session.bookCf=rows[0].cf;
                  req.session.bookMail=mail;
                }
                res.send(ret);
              });
            }

            if (req.body.idC)
            {
              result=[];
              var dt1 = new Date(req.body.ad);
              var dt2 = new Date(req.body.dd);
              var bid=req.body.idclk;
              connection.query("SELECT * FROM bike WHERE IDbike=?",[bid],function(err, rows, fields)
              {
                if(rows.length!=0)
                {
                  var diffdate=Math.floor((Date.UTC(dt2.getFullYear(), dt2.getMonth(), dt2.getDate()) - Date.UTC(dt1.getFullYear(), dt1.getMonth(), dt1.getDate()) ) /(1000 * 60 * 60 * 24));
                  req.session.totAmount+=(rows[0].rentCost)*(diffdate+1);
                  req.session.items.push(new SpecBike(req.body.ad,req.body.dd,bid,rows[0].rentCost,rows[0]));
                  result.push(writeHtmlByObj(req.session.items));
                  connection.query("SELECT * FROM bike b WHERE b.IDBike NOT IN (SELECT newtable.nbike FROM (SELECT s.bikeBooked AS nbike, COUNT(*) AS conta FROM specsbook s WHERE NOT((s.dateFinish < ?) OR (? < s.dateBegin)) GROUP BY nbike HAVING conta>0) AS newtable) AND b.available='Y'",[dt1,dt2],function(err, rows, fields)
                  {
                    if(rows.length>0)
                    {
                      result.push(writeHtml(plusCheck(rows,dt1,dt2,req)));
                    }
                    else
                    {
                      result.push("<p>No bikes avaiable for this period.</p>");
                    }
                  });
                }
                result.push(req.session.totAmount.toString());
                res.send(result);
              });
            }

            if (req.body.rm)
            {
              var cart=req.session.items;
              var key=req.body.remove;
              var dt1= new Date(cart[key].dateS);
              var dt2= new Date(cart[key].dateF);
              var diffdate = Math.floor((Date.UTC(dt2.getFullYear(), dt2.getMonth(), dt2.getDate()) - Date.UTC(dt1.getFullYear(), dt1.getMonth(), dt1.getDate()) ) /(1000 * 60 * 60 * 24));
              req.session.totAmount-=(cart[key].rentCost)*(diffdate+1);
              cart.splice(key,1);
              req.session.items=cart;
              var html=writeHtmlByObj(cart);

              if (cart.length>0)
              {
                res.send([html,'Do a search.',req.session.totAmount.toString()]);
              }
              else
              {
                res.send(['Empty cart!','Do a search.','0.00']);
              }
            }
          });

          router.post('/Aindex',(req,res) =>
          {
            if(req.body.login)
            {
              var mail = req.body.mail;
              var psw = toHash(req.body.psw);
              connection.query("SELECT c.cf AS cf, c.name AS name FROM client c, employee e WHERE c.cf=e.cfemployee AND c.mail=? AND e.password=?",[mail,psw],function(err, rows, fields)
              {
                if (rows.length>0)
                {
                  var cf=rows[0].cf;
                  var name=rows[0].name;
                  connection.query("SELECT * FROM clientPeer WHERE notes=? AND role='F'",[mail],function(err, result, fields)
                  {
                    if (result.length>0)
                    {
                      req.session.mail=mail;
                      req.session.cf=cf;
                      req.session.name=name;
                      req.session.role='F';
                      req.session.items=[];
                      req.session.totAmount=0.00;
                      req.session.peerInfo=result[0];
                      res.send("ok");
                    }
                    else
                    {
                      res.send("ERROR! No peer's ID for this admin.");
                    }
                  });
                }
                else
                {
                  res.send("ERROR! Incorrect data or unregistered employee.");
                }
              });
            }
          });

          router.post('/Aconfirm',(req,res) =>
          {
            if(req.body.Conf)
            {
              var tot=req.session.totAmount;
              var cf=req.session.bookCf;
              var mail=req.session.bookMail;
              var idBook = 0;
              connection.query("INSERT INTO booking(cfUser, costTotal) VALUES(?,?)",[cf,tot],function(err, rows, fields)
              {
                idBook = rows.insertId;
                var mail = req.session.bookMail;
                var html="";
                req.session.items.forEach(function(item)
                {
                  var dateStart=item.dateS;
                  var dateStop=item.dateF;
                  var bikeB=item.idBike;
                  html+="<label style=padding:10px'><br><br> BIKE: <b> "+bikeB+"</b></label>";
                  html+="<label style='position:center;padding:10px'>DATE START: <b>"+dateStart+"</b></label>";
                  html+="<label style='position:center;padding:10px'>DATE FINISH: <b>"+dateStop+"</b></label>";
                  html+="<br>";
                  connection.query("INSERT INTO specsbook(dateBegin, dateFinish, bikeBooked, idBook) VALUES(?,?,?,?)",[dateStart,dateStop,bikeB,idBook])
                });

                connection.query('SELECT * FROM specsbook WHERE idBook=?', [idBook], function (err, result, fields)
                {
                  if (result.length>0)
                  {
                    var emailpeers="";
                    for (var i=0; i<result.length; i++)
                    {
                      var newIdPeer=takePeerId();
                      emailpeers+="Bike n° "+result[i].bikeBooked+" from "+result[i].dateBegin.toLocaleDateString()+" to "+ result[i].dateFinish.toLocaleDateString()+"  &#9658 <a href='https://80.211.229.225/public/AreaNavigator/navigatorLogin.html?idPeer=" +newIdPeer+ "'>"+newIdPeer+"</a><br>";
                      connection.query('INSERT INTO clientPeer(idSpecBook,idPeer) VALUES(?,?)', [result[i].IDspecBook, newIdPeer]);
                    }
                    connection.query("INSERT INTO payment(idclient, idbook, paid) VALUES(?,?,1)",[cf,idBook]);
                    var message = "<html><head></head><body><h1>DETTAGLIO PRENOTAZIONE</h1><h3>Gentile cliente, grazie di esserti prenotato.</h3><p>Il codice della tua prenotazione &egrave;: <b>"+idBook+" </b>.</p><p>I codici per i tuoi tour sono:<br>"+emailpeers+"</p><p>Ricorda questi codici, sono IMPORTANTI! <b>Appennino Adventures</b> ti aspetta!</p></body></html>";
                    var mailOptions =
                    {
                      from: '"RENTBIKE" <sender@rentbikeappennino.info>',
                      to: mail,
                      subject: 'LA TUA PRENOTAZIONE',
                      html: message
                    };
                    transporter.sendMail(mailOptions, function(error, info){if (error) {console.log(error);}});
                  }
                });

                req.session.totAmount = 0.00;
                req.session.bookCf = "";
                req.session.bookMail = "";
                req.session.items = [];
                res.send([html,tot,idBook,mail]);
              });
            }
          });

          router.post('/upload', (req, res)=>
          {
            upload(req, res, async function(err)
            {
              if( err|| req.file === undefined)
              {
                console.log(err);
                res.send("error occured");
              }
              else
              {
                var frame = req.body.frame;
                var brand = req.body.brand;
                var model = req.body.model;
                var size = req.body.size;
                var cost = req.body.sellcost;
                var rcost = req.body.rentprice;
                var type = req.body.type;
                connection.query("SELECT * FROM bike WHERE nTelaio=?",[frame],function(err, rows, fields)
                {
                  if (rows.length<=0)
                  {
                    connection.query("INSERT INTO bike(nTelaio, brand, model, bSize, cost, type, rentCost) VALUES(?,?,?,?,?,?,?)",[frame,brand,model,size,cost,type,rcost],function(err, rows, fields)
                    {
                      var idb = rows.insertId;
                      let fileName = idb +".jpg";
                      var image = sharp(req.file.buffer).resize({ width: 600, height:450 }).jpeg({quality: 40}).toFile('./public/adminZone/immagini/bike/'+fileName).catch(err =>
                        {
                          console.log('error: ', err)
                        });
                        res.send("1"+idb);
                      });
                    }
                    else
                    {
                      res.send("0");
                    }
                  });
                }
              });
            });

            router.post('/Abike',(req,res) =>
            {
              if(req.body.list)
              {
                var html="";
                connection.query("SELECT * FROM bike",function(err, rows, fields)
                {
                  if(rows.length>0)
                  {
                    rows.forEach(function(row)
                    {
                      var id=row.IDbike;
                      var brand=row.brand;
                      var model=row.model;
                      html+="<tr><td>"+id+"</td><td id='brand"+row.IDbike+"'>"+brand+"</td><td id='model"+row.IDbike+"'>"+model+"</td><td id='km"+row.IDbike+"'>"+row.km+"</td>";
                      html+="<td><button type='button' id='"+id+"' name='"+id+"' class='btn btn-outline-light'><i class='fas fa-info'></i></button></td></tr>";
                    });
                  }
                  else
                  {
                    html="<p>No bikes in Database.</p>";
                  }
                  res.send(html);
                });
              }

              if(req.body.dt)
              {
                var id=req.body.details;
                var html="";
                var qrcodehtml="";
                connection.query("SELECT * FROM bike WHERE IDbike=?",[id],function(err, rows, fields)
                {
                  if(rows.length>0)
                  {
                    var qrlink='https://chart.apis.google.com/chart?cht=qr&chs=150x150&chl='+id;
                    qrcodehtml+="<img src='"+qrlink+"' class='figure-img img-fluid rounded' style='width:200px;height:200px'>";
                    rows.forEach(function(row)
                    {
                      html+="<tr><th scope='row'>"+row.IDbike+"</th><td>"+row.nTelaio+"</td><td>"+row.rentCost+"</td><td>"+row.cost+"</td><td>"+row.type+"</td><td>"+row.bSize+"</td>";
                      html+="<td><img src='/public/adminZone/immagini/bike/"+row.IDbike+".jpg' class='figure-img img-fluid rounded' style='width:10vw;height:10vh'></td></tr>";
                    });
                  }
                  else
                  {
                    html="<p>No ID found in Database.</p>";
                  }
                  res.send([html,qrcodehtml]);
                });
              }
            });

            router.post('/Auser',(req,res) =>
            {
              if(req.body.listUsers)
              {
                var html="";
                var n=1;
                connection.query("SELECT * FROM client",function(err, rows, fields)
                {
                  if(rows.length>0)
                  {
                    rows.forEach(function(row)
                    {
                      html+="<tr><th scope='row'>"+n+"</th><td>"+row.name+"</td><td>"+row.surname+"</td><td>"+row.cf+"</td><td>"+row.mail+"</td>";
                      html+="<td>"+row.address+"</td><td>"+row.birthday.toLocaleDateString()+"</td><td>"+row.phone+"</td><td>"+row.dateRegistration.toLocaleDateString()+"</td></tr>";
                      n+=1;
                    });
                  }
                  else
                  {
                    html="<p>No users found in Database.</p>";
                  }
                  res.send(html);
                });
              }
            });

            router.post('/Aorder',(req,res) =>
            {
              if(req.body.dt)
              {
                var id=req.body.detailsOrd;
                var html="";
                connection.query("SELECT * FROM specsbook WHERE idBook=?",[id],function(err, rows, fields)
                {
                  if(rows.length>0)
                  {
                    n=1;
                    rows.forEach(function(row)
                    {
                      html+="<tr><th scope='row'>"+n+"</th><td>"+row.bikeBooked+"</td>";
                      html+="<td>"+row.dateBegin.toLocaleDateString()+"</td><td>"+row.dateFinish.toLocaleDateString()+"</td></tr>";
                      n+=1;
                    });
                  }
                  else
                  {
                    html="<p>No BOOK ID found in Database.</p>";
                  }
                  res.send(html);
                });
              }

              if(req.body.listOrder)
              {
                var html="";
                var n=1;
                connection.query("SELECT * FROM booking",function(err, rows, fields)
                {
                  if(rows.length>0)
                  {
                    rows.forEach(function(row)
                    {
                      html+="<tr><th scope='row'>"+n+"</th><td>"+row.IDbooking+"</td><td>"+row.dateBook.toLocaleDateString()+"</td><td>"+row.cfUser+"</td><td>"+row.costTotal+"</td>";
                      html+="<td><button type='button' id='"+row.IDbooking+"' name='"+row.IDbooking+"' class='btn btn-outline-light'><i class='fa fa-info'></i></button></td></tr>";
                      n+=1;
                    });
                  }
                  else
                  {
                    html="<p>No reservations found in Database.</p>";
                  }
                  res.send(html);
                });
              }
            });

            router.post('/Aemployee',(req,res) =>
            {
              if(req.body.confirm)
              {
                var name = req.body.name;
                var surname = req.body.surname;
                var mail = req.body.mail;
                var cf=req.body.cf.toUpperCase();
                var phone = req.body.phone;
                var birthday = req.body.birthday;
                var address = req.body.address;
                var salary = req.body.salary;
                var password1 = toHash(req.body.password1);
                var password2 = toHash(req.body.password2);
                connection.query("SELECT * FROM employee WHERE cfemployee=?",[cf],function(err, rows, fields)
                {
                  if (rows.length<=0)
                  {
                    connection.query("SELECT * FROM client WHERE cf=?",[cf],function(err, rows, fields)
                    {
                      if (rows.length<=0)
                      {
                        connection.query("INSERT INTO client(name,surname,cf,mail,phone,password,birthday,address) VALUES(?,?,?,?,?,?,?,?)",[name,surname,cf,mail,phone,password1,birthday,address]);
                      }
                      connection.query("INSERT INTO employee(cfemployee,salary,password) VALUES(?,?,?)",[cf,salary,password2]);
                      var peerId=takePeerId();
                      connection.query("INSERT INTO clientPeer(idPeer, unlockId, notes, role) VALUES(?,b'1',?,'F')", [peerId,mail]);
                      res.send("Employee added successfully in Database with peer ID "+peerId);
                    });
                  }
                  else
                  {
                    res.send("This Employee already exist in this Database!");
                  }
                });
              }

              if(req.body.list)
              {
                var html="";
                connection.query("SELECT * FROM employee e, client c WHERE c.cf=e.cfemployee",function(err, rows, fields)
                {
                  if(rows.length>0)
                  {
                    rows.forEach(function(row)
                    {
                      var id=row.idemployee;
                      var name=row.name;
                      var surname=row.surname;
                      var mail=row.mail;
                      var phone=row.phone;
                      var birth=row.birthday.toLocaleDateString();
                      var address=row.address;
                      var cfemployee=row.cfemployee;
                      var hiring=row.hiring.toLocaleDateString();
                      var salary=row.salary;
                      var password=row.password;
                      html+="<tr><td>"+id+"</td><td id='name"+row.idemployee+"'>"+name+"</td><td id='surname"+row.idemployee+"'>"+surname+"</td><td id='cfemployee"+row.idemployee+"'>"+cfemployee+"</td>";
                      html+="<td id='mail"+row.idemployee+"'>"+mail+"</td><td id='phone"+row.idemployee+"'>"+phone+"</td><td id='birth"+row.idemployee+"'>"+birth+"</td><td id='address"+row.idemployee+"'>"+address+"</td>";
                      html+="<td id='hiring"+row.idemployee+"'>"+hiring+"</td><td id='salary"+row.idemployee+"'>"+salary+"</td></tr>";
                    });
                  }
                  else
                  {
                    html="<p>No Employee in Database.</p>";
                  }
                  res.send(html);
                });
              }
            });

            router.post('/Acoupon',(req,res) =>
            {
              if(req.body.list)
              {
                var n=1;
                var html="";
                connection.query("SELECT * FROM coupon",function(err, rows, fields)
                {
                  if(rows.length>0)
                  {
                    rows.forEach(function(row)
                    {
                      var id=row.IDcoupon;
                      var name=row.name;
                      var amount=row.amount;
                      var percent=row.percent;
                      var idUser=row.idUser;
                      if (idUser==null)
                      {
                        idUser="ALL";
                      }
                      var expire=row.expire;
                      if (expire== null)
                      {
                        expire="NOT EXPIRE";
                      }
                      else
                      {
                        expire=row.expire.toLocaleDateString();
                      }
                      html+="<tr><th scope='row'>"+n+"</th>";
                      html+="<td>"+id+"</td><td id='name"+row.IDcoupon+"'>"+name+"</td><td id='amount"+row.IDcoupon+"'>"+amount+"</td><td id='percent"+row.IDcoupon+"'>"+percent+"</td>";
                      html+="<td id='idUser"+row.IDcoupon+"'>"+idUser+"</td><td id='expire"+row.IDcoupon+"'>"+expire+"</td></tr>";
                      n+=1;
                    });
                  }
                  else
                  {
                    html="<p>No Coupon in Database.</p>";
                  }
                  res.send(html);
                });
              }

              if(req.body.confirm)
              {
                var users = [];
                var details = [];
                var ispresent = false;

                if (req.body.radioOne=="true")
                {
                  users.push(req.body.idUser);
                }
                connection.query("SELECT name FROM coupon",function(err, rows, fields)
                {
                  details = rows;
                  details.forEach(function(item)
                  {
                    if (item.name==req.body.name)
                    {
                      ispresent=true;
                    }
                  });

                  if (!ispresent)
                  {
                    var code = req.body.name.toUpperCase();
                    var ex = "";
                    var am=0.00;
                    var perc=0;

                    if (req.body.amount.length>0)
                    {
                      am =req.body.amount;
                    }
                    else
                    {
                      perc =req.body.percent;
                    }

                    if (req.body.exdate)
                    {
                      ex=req.body.exdate;
                      if (users.length==0)
                      {
                        connection.query("INSERT INTO coupon(name,amount,percent,expire) VALUES(?,?,?,?)",[code,am,perc,ex]);
                        sendEmail(code,"*");
                      }
                      else
                      {
                        usr = req.body.idUser;
                        connection.query("INSERT INTO coupon(name,amount,percent,idUser,expire) VALUES(?,?,?,?,?)",[code,am,perc,usr,ex]);
                        sendEmail(code,usr);
                      }
                    }
                    else
                    {
                      if (users.length==0)
                      {
                        connection.query("INSERT INTO coupon(name,amount,percent,expire) VALUES(?,?,?,NULL)",[code,am,perc]);
                        sendEmail(code,"*");
                      }
                      else
                      {
                        usr = req.body.idUser;
                        connection.query("INSERT INTO coupon(name,amount,percent,idUser,expire) VALUES(?,?,?,?,NULL)",[code,am,perc,usr]);
                        sendEmail(code,usr);
                      }
                    }
                    res.send("Successfully operation!");
                  }
                  else
                  {
                    res.send("Coupon already exist!");
                  }
                });
              }
            });

            router.post('/Amaintenance',(req,res) =>
            {
              if(req.body.addMan)
              {
                var idb = req.body.idBike;
                var notes = req.body.notes;
                var labor = req.body.labor;
                var dateb = req.body.dateBegin;
                connection.query("SELECT * FROM bike WHERE IDbike=?",[idb],function(err, rows, fields)
                {
                  if (rows.length>0)
                  {
                    if (rows[0].available!='M')
                    {
                      connection.query("UPDATE bike SET available='M' WHERE IDbike = ?",[idb]);
                      connection.query("INSERT INTO maintenance(idBike, notes, manodop, startRepair) VALUES(?,?,?,?)",[idb,notes,labor,dateb]);
                      res.send("Successful operation!");
                    }
                    else
                    {
                      res.send("This bike is already in maintenance!");
                    }
                  }
                  else
                  {
                    res.send("The bike ID is incorrect!");
                  }
                });
              }

              if(req.body.addSpare)
              {
                var nameP = req.body.namePart;
                var priceP = req.body.pricePart;
                var quantP = req.body.quantPart;
                var noteP = req.body.notePart;
                var isbnP = req.body.isbnPart;
                connection.query("SELECT * FROM sparepart WHERE isbn=?",[isbnP],function(err, rows, fields)
                {
                  if (rows.length>0)
                  {
                    var totq=rows[0].quantity + quantP;
                    connection.query("UPDATE sparepart SET quantity=? WHERE isbn = ?",[totq,isbnP]);
                  }
                  else
                  {
                    connection.query("INSERT INTO sparepart(namePart, costPart, quantity, note, isbn) VALUES(?,?,?,?,?)",[nameP,priceP,quantP,noteP,isbnP]);
                  }
                  res.send("Successful operation!");
                });
              }

              if(req.body.addSpareMan)
              {
                var isbn = req.body.isbnAddSpare;
                var quantity = req.body.quantityAddSpare;
                var idMain = req.body.idMain;
                connection.query("SELECT IDpart,quantity FROM sparepart WHERE isbn=?",[isbn],function(err, rows, fields)
                {
                  if (rows.length>0)
                  {
                    var idPart=rows[0].IDpart;
                    if (rows[0].quantity>=quantity)
                    {
                      var totq = rows[0].quantity - quantity;
                      connection.query("UPDATE sparepart SET quantity=? WHERE isbn = ?",[totq,isbn]);
                      connection.query("INSERT INTO usedpart(idPart, idMaint, qUsed) VALUES(?,?,?)",[idPart,idMain,quantity]);
                      res.send("Successful operation!");
                    }
                    else
                    {
                      res.send("No enought quantity for this piece! Only "+rows[0].quantity+" available.");
                    }
                  }
                  else
                  {
                    res.send("Server error!");
                  }
                });
              }

              if(req.body.listMan)
              {
                var html="";
                var n=1;
                connection.query("SELECT * FROM maintenance",function(err, rows, fields)
                {
                  if(rows.length>0)
                  {
                    rows.forEach(function(row)
                    {
                      if(row.stopRepair==null)
                      {
                        row.stopRepair= "";
                      }
                      else
                      {
                        row.stopRepair= row.stopRepair.toLocaleDateString();
                      }
                      html+="<tr><th scope='row'>"+n+"</th><td>"+row.IDrepair+"</td><td>"+row.idBike+"</td><td>"+row.notes+"</td><td>"+row.manodop+"</td><td>";
                      if (parseInt(row.repaired[0])==1)
                      {
                        html+="<i class='fas fa-check'></i>";
                      }
                      else
                      {
                        html+="<i class='fas fa-times'></i>";
                      }
                      html+="</td><td>"+row.startRepair.toLocaleDateString()+"</td><td>"+row.stopRepair+"</td><td><button type='button' id='details:"+row.IDrepair+"' class='btn btn-outline-light'><i class='fas fa-info'></i></button></td>";

                      if (parseInt(row.repaired[0])==0)
                      {
                        html+="<td><button type='button' id='confirmRep:"+row.IDrepair+"' class='btn btn-outline-light'>CONFIRM REPAIRED</button></td>";
                      }
                      else
                      {
                        html+="<td></td>";
                      }
                      html+="</tr>";
                      n+=1;
                    });
                  }
                  else
                  {
                    html="<p>No maintenance found in Database.</p>";
                  }
                  res.send(html);
                });
              }

              if (req.body.cfr)
              {
                id=req.body.confirmRep;
                connection.query("UPDATE maintenance SET repaired=1, stopRepair=now() WHERE IDrepair = ?",[id]);
                connection.query("SELECT idBike FROM maintenance WHERE IDrepair=?",[id],function(err, rows, fields)
                {
                  var idBike=rows[0].idBike;
                  connection.query("UPDATE bike SET available='Y' WHERE IDbike = ?",[idBike]);
                  res.send("ok");
                });
              }

              if(req.body.dtr)
              {
                var idrep=req.body.detailsRep;
                var html="";
                var n=1;
                connection.query("SELECT * FROM sparepart sp, usedpart up WHERE sp.IDpart=up.idPart AND up.idMaint=?",[idrep],function(err, rows, fields)
                {
                  if(rows.length>0)
                  {
                    rows.forEach(function(row)
                    {
                      html+="<tr><th scope='row'>"+n+"</th><td>"+row.idPart+"</td><td>"+row.namePart+"</td><td>"+row.qUsed+"</td></tr>";
                      n+=1;
                    });
                  }
                  else
                  {
                    html="<p>No maintenance specs found for this ID in Database.</p>";
                  }
                  res.send(html);
                });
              }

              if(req.body.listSpare)
              {
                var html="";
                var n=1;
                connection.query("SELECT * FROM sparepart",function(err, rows, fields)
                {
                  if(rows.length>0)
                  {
                    rows.forEach(function(row)
                    {
                      html+="<tr><th scope='row'>"+n+"</th><td>"+row.IDpart+"</td><td>"+row.namePart+"</td><td>"+row.costPart+"</td><td>"+row.quantity+"</td><td>"+row.note+"</td><td>"+row.isbn+"</td></tr>";
                      n+=1;
                    });
                  }
                  else
                  {
                    html+="<p>No spare parts found in Database.</p>";
                  }
                  res.send(html);
                });
              }
            });

            router.post('/Aaccounting',(req,res) =>
            {
              if(req.body.confirm)
              {
                var date1=req.body.dateStart;
                var date2=req.body.dateFinish;
                var arr=[];
                connection.query("SELECT date(b.dateBook) AS dateok, SUM(b.costTotal) AS totale FROM booking b WHERE  date(b.dateBook)>=? AND date(b.dateBook)<=? GROUP BY dateok ORDER BY dateok",[date1,date2],function(err, rows, fields)
                {
                  rows.forEach(function(row)
                  {
                    row.dateok = row.dateok.toLocaleDateString();
                  });
                  res.send(rows);
                });
              }
            });

            router.post('/ArequestBike',(req,res) =>
            {
              if(req.body.request)
              {
                var date=req.body.date;
                var html="";
                connection.query("SELECT * FROM bike b WHERE b.IDBike NOT IN (SELECT newtable.nbike FROM (SELECT s.bikeBooked AS nbike, COUNT(*) AS conta FROM specsbook s WHERE NOT((s.dateFinish < ?) OR (? < s.dateBegin)) GROUP BY nbike HAVING conta>0) AS newtable) AND b.available='Y'",[date,date],function(err1, rows1, fields1)
                {
                  if(err1==null)
                  {
                    connection.query("SELECT * FROM bike b WHERE b.IDBike IN (SELECT bikeBooked FROM specsbook WHERE dateBegin=? AND dateFinish=? AND idBook IS NULL) AND b.available='Y'",[date,date],function(err2, rows2, fields2)
                    {
                      if(rows1.length<=0 && rows2.length<=0)
                      {
                        html="<p><b>NO BIKE AVAILABLE!<b><p>";
                      }
                      else
                      {
                        rows1.forEach(function(row1)
                        {
                          html+="<tr><td>"+row1.IDbike+"</td><td>"+row1.brand+"</td><td>"+row1.model+"</td><td>"+row1.bSize+"</td><td>"+row1.type+"</td><td><button class='btn btn-dark' id='Sbike"+row1.IDbike+"'  type='button' name='button'><i class='far fa-hand-pointer'></i></button></td></tr>";
                        });
                        rows2.forEach(function(row2)
                        {
                          html+="<tr><td>"+row2.IDbike+"</td><td>"+row2.brand+"</td><td>"+row2.model+"</td><td>"+row2.bSize+"</td><td>"+row2.type+"</td><td><button class='btn btn-dark' id='Rbike"+row2.IDbike+"'  type='button' name='button'><i class='far fa-trash-alt'></i></button></td></tr>";
                        });
                      }
                      res.send(html);
                    });
                  }
                });
              }

              if(req.body.insert)
              {
                var date=req.body.date;
                var idb=req.body.idb;
                connection.query("INSERT INTO specsbook(dateBegin,dateFinish,bikeBooked) VALUES(?,?,?)",[date,date,idb],function(err, rows, fields)
                {
                  var idSpec = rows.insertId;
                  var idpeer = takePeerId();
                  var stringa = new Date(date);
                  connection.query("INSERT INTO clientPeer(idSpecBook,idPeer,role,notes) VALUES(?,?,?,?)",[idSpec,idpeer,'A',req.session.mail]);
                  var message = "<html><head></head><body><h1>YOUR NAVIGATION CODE</h1><p>DATA: "+stringa.toLocaleDateString()+"<br>ID BIKE: "+idb+"<br>CODE: <a href='https://80.211.229.225/public/AreaNavigator/navigatorLogin.html?idPeer=" +idpeer+ "'>"+idpeer+"</a></p></body></html>";
                  var mailOptions =
                  {
                    from: '"RENTBIKE" <sender@rentbikeappennino.info>',
                    to: req.session.mail,
                    subject: 'NAVIGATION CODE',
                    html: message
                  };
                  transporter.sendMail(mailOptions, function(error, info){if (error) {console.log(error);}});
                  res.send("ok");
                });
              }

              if(req.body.remove)
              {
                var date=req.body.date;
                var idb=req.body.idb;
                connection.query("SELECT * FROM specsbook WHERE dateBegin=? AND dateFinish=? AND bikeBooked=? AND idBook IS NULL",[date,date,idb],function(err, rows, fields)
                {
                  var idSpec = rows[0].IDspecBook;
                  connection.query("DELETE FROM clientPeer WHERE idSpecBook=?",[idSpec]);
                  connection.query("DELETE FROM specsbook WHERE IDspecBook=?",[idSpec]);
                  res.send("ok");
                });
              }
            });

            router.post('/AbikeRT',(req,res) =>
            {
              if(req.body.bikeinmaps)
              {
                var coords=[];
                connection.query("SELECT * FROM clientPeer,specsbook WHERE specsbook.IDspecBook=clientPeer.idSpecBook AND ((specsbook.dateBegin<=date(CURRENT_TIMESTAMP) AND specsbook.dateFinish>=date(CURRENT_TIMESTAMP)) OR unlockId=1) AND (role='A' OR role='C') AND (idActive=1 OR unlockId=1) AND lastLng IS NOT NULL AND lastLat IS NOT NULL",function(err, rows, fields)
                {
                  if(rows.length>0)
                  {
                    rows.forEach(function(row)
                    {
                      var lat=row.lastLat;
                      var long=row.lastLng;
                      var obj={lat:lat,lng:long,role:row.role,id:row.bikeBooked,idPeer:row.idPeer};
                      coords.push(obj);
                    });
                    res.send(coords);
                  }
                  else
                  {
                    res.send("Null");
                  }
                });
              }
            });

            peerServer.on('connection', function (id)
            {
              var idx=connected.indexOf(id);
              if (idx==-1)
              {
                connected.push(id);
              }
            });

            peerServer.on('disconnect', function (id)
            {
              var idx=connected.indexOf(id);
              if (idx!==-1)
              {
                connected.splice(idx,1);
              }
            });

            router.post("/clientPeer", (req, res) =>
            {
              if (req.body.getConnected)
              {
                res.send(connected);
              }

              if (req.body.helper)
              {
                var lat=req.body.lat;
                var lng=req.body.lng;
                var sosPeer=req.body.sosPeer;
                connection.query("UPDATE clientPeer SET sosEnable=1, lastLng=?, lastLat=? WHERE idPeer=?",[lng,lat,sosPeer]);
                connection.query("SELECT * FROM clientPeer c, specsbook s WHERE c.idSpecBook=s.IDspecBook AND s.dateBegin>=date(CURRENT_TIMESTAMP) AND s.dateFinish<=date(CURRENT_TIMESTAMP) AND c.role='A' AND c.lastLng IS NOT NULL AND c.lastLat IS NOT NULL AND c.sosEnable=b'0' AND (c.idActive=b'1' OR c.unlockId=b'1') AND c.idPeer!=?",[sosPeer],function(err, rows, fields)
                {
                  if (err==null && rows.length>0)
                  {
                    var minDistance=[]; //pos 0 distanza minima, pos 1 idpeer minimo
                    for(var i=0; i<rows.length; i++)
                    {
                      if (i==0)
                      {
                        minDistance.push(getDistanceKm(lat,lng,rows[i].lastLat,rows[i].lastLng));
                        minDistance.push(rows[i].idPeer);
                      }
                      else
                      {
                        var distance=getDistanceKm(lat,lng,rows[i].lastLat,rows[i].lastLng);
                        if(distance<minDistance[0])
                        {
                          minDistance[0]=distance;
                          minDistance[1]=rows[i].idPeer;
                        }
                      }
                    }
                    idHelper=minDistance[1];
                    connection.query("UPDATE clientPeer SET sosEnable=1 WHERE idPeer=?",[idHelper]);
                    res.send(idHelper);
                  }
                  else
                  {
                    console.log(err);
                    res.send("noOK");
                  }
                });
              }

              if (req.body.upCoords)
              {
                var lat=req.body.lat;
                var lng=req.body.lng;
                var peer=req.body.peer;
                connection.query("SELECT lastLng, lastLat FROM clientPeer where idPeer=?",[peer],function(err, rows, fields)
                {
                  if(rows.length>0)
                  {
                    oldLat=rows[0].lastLat;
                    oldLng=rows[0].lastLng;
                    var diffKm = getDistanceKm(parseFloat(oldLat).toFixed(5),parseFloat(oldLng).toFixed(5),parseFloat(lat).toFixed(5),parseFloat(lng).toFixed(5));
                    connection.query("UPDATE clientPeer SET lastLng=?, lastLat=? WHERE idPeer=? AND (role='A' OR role='C')",[lng,lat,peer]);
                    res.send(diffKm);
                  }
                });
              }

              if (req.body.disconnect)
              {
                var circle = Math.pow((fixLongitude - parseFloat(req.body.lng)),2) + Math.pow((fixLatitude - parseFloat(req.body.lat)),2);
                if(circle<=Math.pow(0.011,2))
                {
                  connection.query('UPDATE clientPeer SET idActive=0 WHERE idPeer=?', [req.body.id], function (err, result, fields)
                  {
                    if (!err)
                    {
                      connection.query('SELECT b.km as km, b.IDbike as idbike FROM bike b, clientPeer c, specsbook s where c.idPeer=? AND c.idSpecBook=s.IDspecBook AND s.bikeBooked=b.IDbike', [req.body.id],function (err, result, fields)
                      {
                        if(result.length>0)
                        {
                          var totalkm=result[0].km+req.body.km;
                          connection.query('UPDATE bike SET km=? WHERE IDbike=?', [totalkm,result[0].idbike]);
                          delete req.session.peerInfo;
                          res.send("ok");
                        }
                        else
                        {
                          res.send("nook");
                        }
                      });
                    }
                    else
                    {
                      res.send("nook");
                    }
                  });
                }
                else
                {
                  res.send("out");
                }
              }

              if (req.body.validpeer)
              {
                var query = "SELECT * FROM clientPeer cp, specsbook sb WHERE cp.idSpecBook=sb.IDspecBook AND cp.idPeer LIKE ? AND ((CURDATE()>=sb.dateBegin AND CURDATE()<=sb.dateFinish AND cp.idActive=1) OR cp.unlockId=1)";
                var values = [req.body.validpeer];
                connection.query(query,values,function(err, rows, fields)
                {
                  if (rows.length>0)
                  {
                    req.session.peerInfo=rows[0];
                    res.send("ok");
                  }
                  else
                  {
                    res.send("nook");
                  }
                });
              }

              if (req.body.checkPeerSession)
              {
                if (req.session.peerInfo)
                {
                  res.send(req.session.peerInfo);
                }
                else
                {
                  res.send(null);
                }
              }

              if (req.body.hello)
              {
                connection.query('UPDATE clientPeer SET lastLng=?, lastLat=? WHERE idPeer=?', [req.body.lng,req.body.lat,req.body.id], function (err, result, fields)
                {
                  if (!err)
                  {
                    res.send("ok");
                  }
                  else
                  {
                    res.send("nook");
                  }
                });
              }

              if (req.body.sosStop)
              {
                connection.query("UPDATE clientPeer SET sosEnable=b'0' WHERE idPeer=?",[req.body.id1]);
                connection.query("UPDATE clientPeer SET sosEnable=b'0' WHERE idPeer=?",[req.body.id2]);
                res.send("ok");
              }
            });

            app.use('/', router);
            server.listen(port);
