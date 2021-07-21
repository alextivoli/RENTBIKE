function checkSessionRole()
{
	$.post("/session",{checkSessionRole:true},function(data)
	{
		if(data==false)
		{
			alert("You have to log in!");
			window.location.href = '/public/adminZone/Aindex.html';
		}
	});
}

function checkSessionClient()
{
	$.post("/session",{checkSessionClient:true},function(data)
	{
		if (data==false)
		{
			alert("You have to log in!");
			window.location.href = '/public/adminZone/Aindex.html';
		}
	});
}

function infoOpen(pippo,idBike)
{
	var str=null;
	var peerInfo = null;
	var peer = null;
	var connPeer = null;
	var instantCall = null;
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
	var idpeer=$(pippo).attr('name');
	$("#infobike").css("display","block");
	$("#viewMap").css("display","none");
	$("#showM").css("display","none");

	if(peer==null)
	{
		$.post("/clientPeer",{checkPeerSession:true},function(data)
		{
			if (data!=null)
			{
				peerInfo=data;
				peer = new Peer(data.idPeer,
					{
						host: '80.211.229.225',
						port: 443,
						path: '/public',
						debug: 3
					});
				}

				peer.on('open', function(id)
				{
					$("#info").text("I'm trying to connect...");
					$("#idbike").text(idBike);
					connPeer=peer.connect(idpeer);
					connPeer.on('open',function()
					{
						if(connPeer.open)
						{
							$("#info").text("Connected with peer "+idpeer);
						}
					});

					$("#call").click(function()
					{
						if(connPeer.open)
						{
							connPeer.send({mex:"checkCall"});
						}
						else
						{
							connPeer.on("open",function()
							{
								connPeer.send({mex:"checkCall"});
							});
						}

						connPeer.on('data', function(data)
						{
							if (data.mex=="okCheckCall" && data.currStatus)
							{
								if (confirm("Are you sure to call this client?"))
								{
									$("#video").css("display","block");
									$("#terminate").css("display","block");
									$("#call").css("display","none");
									getUserMedia({video: true, audio: true}, function(stream)
									{
										str=stream;
										instantCall = peer.call(idpeer, stream);
										instantCall.metadata="F";
										instantCall.on('stream', function(remoteStream)
										{
											video.srcObject = remoteStream;

											instantCall.on('close', function()
											{
												$("#video").css("display","none");
												instantCall=null;
												str.getTracks().forEach(function(track){track.stop()});
												$("#info").text("call terminated!");
												$("#terminate").css("display","none");
												$("#call").css("display","block");
											});
										});
									},
									function(err)
									{
										console.log('Failed to get local stream' ,err);
									});
								}
							}
							else
							{
								alert("Peer alredy busy. Try later!");
							}
						});
					});

					$("#sendMsg").click(function()
					{
						var msg = $("#textarea").val();
						if(msg!="")
						{
							$("#textarea").val("");
							if(connPeer.open)
							{
								connPeer.send({mex:"msg",text:msg});
							}
							else
							{
								connPeer.on("open",function()
								{
									connPeer.send({mex:"msg",text:msg});
								});
							}
						}
					});

					$("#clear").click(function()
					{
						if(connPeer.open)
						{
							connPeer.send({mex:"clear"});
						}
						else
						{
							connPeer.on("open",function()
							{
								connPeer.send({mex:"clear"});
							});
						}
					});

					$("#terminate").click(function()
					{
						if (confirm("Are you sure to terminate SOS call?"))
						{
							str.getTracks().forEach(function(track){track.stop()});
							if (connPeer.open)
							{
								connPeer.send({mex:"okTerminate"});
								instantCall.close();
								instantCall=null;
								str=null
								window.location.reload();
							}
							else
							{
								connPeer.on('open',function()
								{
									connPeer.send({mex:"okTerminate"});
									instantCall.close();
									instantCall=null;
									str=null;
									window.location.reload();
								});
							}
						}
					});
				});
				peer.on('error', function (err)
				{
					$("#info").text("General error about peer's connections!");
					if (err.type=="peer-unavailable")
					{
						alert("Peer unavailable or disconnected. Please try later!");
					}
					else
					{
						alert("Fatal Peer Error!");
					}
					peer.destroy();
					window.location.reload();
				});
			});
		}
		else
		{
			alert("Invalid peer!");
			window.location.replace("/");
		}
	}

	$(document).ready(function()
	{
		checkSessionRole();
		checkSessionClient();

		$("#logout").click(function()
		{
			$.post("/session",{destroySession:true},function(data)
			{
				sessionStorage.clear();
				peer.destroy();
				window.location.href = "/";
			});
		});

		$("#showM").click(function()
		{
			$("#viewMap").css("display","block");
		});

	});
