$(document).ready(function()
{
	var superPeer = "e569c21b-a673-49ac-a4cb-228885479ce6";
	var peerInfo = null;
	var peer = null;
	var connSuper = null;
	var instantCall = null;
	var assistantPeer = null;
	const video = document.querySelector('video');
	video.width = 300;
	video.height = 200;
	var getUserMedia = (function ()
	{
	  if (navigator.getUserMedia)
	  {
		return navigator.getUserMedia.bind(navigator)
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

	//data restituisce l'id altrimenti stringa vuota
	$.post("/clientPeer",{checkPeerSession:true},function(data)
	{
	  if (data!=null)
	  {
			peerInfo=data;
			peer = new Peer(data.idPeer,
			{
			  host: '87.18.46.169',
			  port: 80,
			  path: '/public',
			  debug: 3
			});
		
		peer.on('open', function(id)
		{
			$("#status").text("Connected with peer ID "+id);
			//mi connetto al supernodo
			connSuper = peer.connect(superPeer);
			connSuper.on('open', function()
			{
			  connSuper.send({mex:"hello",id:peer.id});
			});

			$("#disconnect").click(function()
			{
				connSuper.on('error', function(err)
				{
					console.log(err);
				});
				
				if (connSuper.open)
				{
					//gestione della zona di disconnessione
					connSuper.send({mex:"disconnect",id:peer.id});
				}
				else
				{
					console.log("gesù bambino");
					connSuper.on('open', function() 
					{
						console.log("wwww MILAN");
						//gestione della zona di disconnessione
						connSuper.send({mex:"disconnect",id:peer.id});
					});
				}
			});
		
		////////////////////////////		
		peer.on('connection',function(conn)
		{
			if (conn.peer==superPeer)
			{
				connSuper=conn;
			}
		});
		
		///////////////////////
		connSuper.on('data',function(data)
		{
		  if (data.mex=="okDisconnect")
		  {
			if (data.status==0)
			{
			  peer.destroy();
			  window.location.replace("/");
			}
			else
			{
			  $("#info").text("Something was wrong to disconnect!");
			}
		  }
		  else if (data.mex=="serveSOS")
		  {
			$("#video").css("display","block");
			getUserMedia({video: true, audio: true}, function(stream)
			{
			  //chiamo l'altro peer e mando il mio stream
			  instantCall = peer.call(data.idToServe, stream);
			  //quando l'altro peer mi manda il suo stream
			  instantCall.on('stream', function(remoteStream)
			  {
				//lo faccio vedere nella mia pag html
				video.srcObject = remoteStream;
			  });
			},
			function(err)
			{
			  console.log('Failed to get local stream' ,err);
			});
		  }
		  else if (data.mex=="okSOS")
		  {
			$("#info").text("SOS request send! Wait a moment...");
			$("#sos").css("display","none");
			$("#terminate").css("display","block");
		  }
		  else if (data.mex=="okTerminate")
		  {
			$("#video").css("display","none");
			instantCall.close();
			instantCall=null;
			assistantPeer=null;
			$("#info").text("SOS call terminated!");
			$("#terminate").css("display","none");
			$("#sos").css("display","block");
		  }
		});

		$("#sos").click(function()
		{
		  //setto sos a 1
		  if (confirm("Are you sure to call SOS?"))
		  {
			/*navigator.geolocation.getCurrentPosition(function()
			{
			  connSuper.send({mex:"sos", peerid:peer.id, lat:position.coords.latitude, lng:position.coords.longitude});
			});*/
			connSuper.send({mex:"sos", peerid:peer.id, lat:44.634068, lng:10.493250});
		  }
		});

		//setto sos a 0 controlla!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! da fareee
		$("#terminate").click(function()
		{
		  if (confirm("Are you sure to terminate SOS call?"))
		  {
			  connSuper.send({mex:"SOSterminate",id:peer.id});
		  }
		});

		peer.on('call', function(call) //fare funzione che fa partire chiamata!!!!
		{
		  instantCall = call;
		  assistantPeer = call.peer;
		  $("#sos").css("display","none");
		  $("#terminate").css("display","block");
		  $("#info").text("Connection from " + assistantPeer);
		  getUserMedia({video: true, audio: true}, function(stream)
		  {
			//accetto e rispondo alla chiamata mandando il mio stream
			instantCall.answer(stream);
			//quando l'altro peer mi manda il suo stream
			instantCall.on('stream', function(remoteStream)
			{
			  //lo faccio vedere nella mia pag html
			  video.srcObject = remoteStream;
			});

			/*instantCall.on('close', function()
			{
			  $("#video").css("display","none");
			  instantCall=null;
			  assistantPeer=null;
			  $("#info").text("SOS call terminated!");
			  $("#terminate").css("display","none");
			  $("#sos").css("display","block");
			});*/
		  },
		  function(err)
		  {
			$("#status").text('Failed to get local stream '+err);
			console.log('Failed to get local stream' ,err);
		  });
		});

		// instantCall.on('close', function()
		// {
		// 	$("#video").css("display","none");
		// 	instantCall=null;
		// 	assistantPeer=null;
		// 	$("#info").text("SOS call terminated!");
		// 	$("#terminate").css("display","none");
		// 	$("#sos").css("display","block");
		// });

		/*ricevo dati del peer da soccorere dal server oppure di risposta a una richiesta sos
		peer.on('connection', function(conn)
		{
		  instantData=conn;
		  if (instantData.peer == serverPeer)
		  {
			instantData.on('data',function(data)
			{
			  if (data.mex=="serveSOS")
			  {
				$("#video").css("display","block");
				instantData.close();
				instantData=null;
				getUserMedia({video: true, audio: true}, function(stream)
				{
				  //chiamo l'altro peer e mando il mio stream
				  instantCall = peer.call(data.idToServe, stream);
				  //quando l'altro peer mi manda il suo stream
				  instantCall.on('stream', function(remoteStream)
				  {
					//lo faccio vedere nella mia pag html
					video.srcObject = remoteStream;
				  });

				  instantCall.on('close', function()
				  {
					$("#video").css("display","none");
					instantCall=null;
					assistantPeer=null;
					$("#info").text("SOS call terminated!");
					$("#terminate").css("display","none");
					$("#sos").css("display","block");
				  });
				},
				function(err)
				{
				  console.log('Failed to get local stream' ,err);
				});
			  }
			  else if (data.mex="okSOS")
			  {
				$("#info").text("SOS request send! Wait a moment...");
				$("#sos").css("display","none");
				$("#terminate").css("display","block");
			  }
			});
		  }
		  instantData.close();
		  instantData=null;
		});*/
		
		});

		peer.on('error', function (err)
		{
		  console.log("eccociiiiii!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
		  console.log(err.type);
		  $("#status").text("Failed to connect: "+err);
		  //window.setTimeout("window.location.reload()", 10000);
		});
	  }
	  else
	  {
		alert("Invalid peer!");
		$("#status").text("Failed to connect: invalid peer!");
		window.location.replace("/");
	  }
	});
});