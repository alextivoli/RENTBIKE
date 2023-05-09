function checkCoords(superPeer)
{
  superPeer.connections.forEach(function(item,index)
  {
	  if (item.open)
	  {
		 item.send({mex:"coords"}); 
	  }
	  else
	  {
		item.on('open', function() 
		{
			item.send({mex:"coords"});
		});
	  }    
  });
}

$(document).ready(function()
{
  var myPeer="e569c21b-a673-49ac-a4cb-228885479ce6";
  var listConnections=[];
  var idVideoCall=null;
  var otherConnection=null;
  const video = document.querySelector('video');
  video.width = 300;
  video.height = 200;
  var getUserMedia = (function ()
  {
    if (navigator.mediaDevices.getUserMedia)
    {
      return navigator.mediaDevices.getUserMedia.bind(navigator)
    }
  
    if (navigator.webkitGetUserMedia)
    {
      return navigator.webkitGetUserMedia.bind(navigator)
    }
  
    if (navigator.mozGetUserMedia)
    {
      return navigator.mozGetUserMedia.bind(navigator)
    }
  })();

	var superPeer = new Peer(myPeer,
	{
	  host: '87.18.46.169',
	  port: 80,
	  path: '/public',
	  debug: 3
	});

    //setInterval(checkCoords(superPeer), 300000);//ogni 5 min secondi richiede l'aggiornamento
    $.post("/clientPeer",{getConnected:true},function(data)
    {
      if (data.length>0)
      {
        data.forEach(function(item,index)
        {
			if (item!=myPeer) //se l'id dei peer connessi non è quello del supernodo allora lo aggiungo alla lista delle connessioni
			{
				var instantConn = superPeer.connect(item); //le apro (con open) di già????
				listConnections.push(instantConn);
			}
        });
      }
    });

    //setto sos a 0
    $("#terminate").click(function()
    {
      if (confirm("Are you sure to terminate SOS call?"))
      {
        $.post("/clientPeer",{terminate:true},function(data)
        {
          if (data=="ok")
          {
            $("#video").css("display","none");
            idVideoCall.close();
            $("#info").text("SOS call terminated!");
            $("#terminate").css("display","none");
            $("#sos").css("display","block");
          }
        });
      }
    });

    superPeer.on('open', function(id)
    {
      $("#status").text("Super peer connected with peer ID "+id);
    });


    superPeer.on('error', function (err)
    {
      console.log(err);
      $("#status").text("Failed to connect: "+err);
      //window.setTimeout("window.location.reload()", 10000);
    });

    superPeer.on('disconnected', function (err)
    {
      superPeer.reconnect();
    });

    superPeer.on('call', function(call) //fare funzione che fa partire chiamata!!!!
    {
      $("#terminate").css("display","block");
      $("#info").text("Connection from " + call.peer);
      getUserMedia({video: true, audio: true}, function(stream)
      {
        //accetto e rispondo alla chiamata mandando il mio stream
        call.answer(stream);
        //quando l'altro peer mi manda il suo stream
        call.on('stream', function(remoteStream)
        {
          //lo faccio vedere nella mia pag html
          video.srcObject = remoteStream;
        });

        call.on('close', function()
        {
          $("#video").css("display","none");
          $("#info").text("SOS call terminated!");
          $("#terminate").css("display","none");
        });
      },
      function(err)
      {
        $("#status").text('Failed to get local stream '+err);
        console.log('Failed to get local stream' ,err);
      });
    });


    //ricevo dati del peer da soccorere dal server oppure di risposta a una richiesta sos
    superPeer.on('connection', function(conn)
    {
      conn.on('error', function(err)
      {
        console.log(err);
      });

      conn.on('data',function(data)
      {
        if (data.mex=="sos")
        {
          var lat=data.lat;
          var lng=data.lng;
          var idHelper=myPeer;
          var sosPeer=data.peerid;

          $.post("/clientPeer",{helper:true, lng:lng, lat:lat, sosPeer:sosPeer},function(result)
          {			  
			console.log(lat+" "+lng+" "+idHelper+" "+sosPeer+" "+result);
            if (result!="noOK")
            {
			  if (conn.open)
			  {
				 conn.send({mex:"okSOS"});
			  }
			  else
			  {
				conn.on('open', function() 
				{
					conn.send({mex:"okSOS"});
				});
			  }
              var okConn=false;
              listConnections.forEach(function(item,index)
              {
                if (item.peer==result && okConn==false)
                {
                  otherConnection=item;
                  okConn=true;
                }
              });

              if (okConn!=false)
              {
				  if (otherConnection.open)
				  {
					 otherConnection.send({mex:"serveSOS",idToServe:sosPeer});
				  }
				  else
				  {
					otherConnection.on('open', function() 
					{
						otherConnection.send({mex:"serveSOS",idToServe:sosPeer});
					});
				  }
              }
              else
              {
                  otherConnection = superPeer.connect(result);
				  if (otherConnection.open)
				  {
					 otherConnection.send({mex:"serveSOS",idToServe:sosPeer});
				  }
				  else
				  {
					otherConnection.on('open', function() 
					{
						otherConnection.send({mex:"serveSOS",idToServe:sosPeer});
					});
				  }
              }
            }
            else
            {
              //se ne fa carico il superpeer che attiverà la chiamata e modificheremo html
              $("#video").css("display","block");
              getUserMedia({video: true, audio: true}, function(stream)
              {
                idVideoCall = superPeer.call(sosPeer, stream);
                idVideoCall.on('stream', function(remoteStream)
                {
                  video.srcObject = remoteStream;
                });

                idVideoCall.on('close', function()
                {
                  $("#video").css("display","none");
                  idVideoCall=null;
                  $("#info").text("SOS call terminated!");
                  $("#terminate").css("display","none");
                });
              },
              function(err)
              {
                console.log('Failed to get local stream' ,err);
              });
            }
          });
        }
        else if (data.mex=="coordsOK")
        {
          var lat=data.lat;
          var lng=data.lng;

          $.post("/clientPeer",{upCoords:true, lng:lng, lat:lat, peer:data.peer});
        }
        else if (data.mex=="disconnect")
        {
          var peerId=data.id;
		  console.log("cacca bella");
          $.post("/clientPeer",{disconnect:true, id:peerId},function(data)
          {
            if (data=="ok")
            {
              var idx=listConnections.indexOf(conn); // only attempt to remove id if it's in the list
              
			  if (idx!==-1)
              {
                listConnections.splice(idx,1);
              }
			  
			  if (conn.open)
			  {
				 conn.send({mex:"okDisconnect", status:0});
			  }
			  else
			  {
				conn.on('open', function() 
				{
					conn.send({mex:"okDisconnect", status:0});
				});
			  }
            }
            else
            {
			  //da gestire
              if (conn.open)
			  {
				 conn.send({mex:"okDisconnect", status:1});
				 conn.close();
			  }
			  else
			  {
				conn.on('open', function() 
				{
					conn.send({mex:"okDisconnect", status:1});
					conn.close();
				});
			  }
            }
          });
        }
        else if (data.mex=="hello")
        {
          var idx=listConnections.indexOf(conn);
          if (idx==-1)
          {
            listConnections.push(conn);
          }
		  //console.log(Object.keys(superPeer.connections));
        }
        else if (data.mex=="SOSterminate")
        {
          //da fareeeeeeeeeeee
        }
      });
    });
});
