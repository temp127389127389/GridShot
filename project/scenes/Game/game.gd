extends Node2D

func _on_multiplayer_ready():
	if not Config.debug.multiplayer_enabled:
		add_player()
	
	elif multiplayer.is_server():
		add_player()
		
		var multiplayer_node : WebRTCLobbyHost = Network.multiplayer_node
		multiplayer_node.PeerConnected.connect(add_player)
		multiplayer_node.PeerDisconnected.connect(remove_player)
	
	else:
		var multiplayer_node : WebRTCPlayerClient = Network.multiplayer_node
		multiplayer_node.LobbyServerDisconnected.connect(server_disconnected)

func add_player(peer_id : int = 1):
	var new_player = Globals.scenes.player.instantiate()
	new_player.name = str(peer_id)
	
	add_child(new_player)

func remove_player(peer_id : int):
	get_node(str(peer_id)).queue_free()

func server_disconnected():
	Globals.exit_game()
