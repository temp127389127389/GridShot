extends Node

var peer = ENetMultiplayerPeer.new()

# host signals
signal peer_connected(id : int)
signal peer_disconnected(id : int)

# client signals
signal connected_to_server
signal connection_failed
signal server_disconnected


#func get_mlt():
	#return get_tree().get_multiplayer("/root/main")

func _ready():
	# inherit the multiplayers signals (in quite an ugly fasion)
	multiplayer.peer_connected.connect(peer_connected.emit)
	multiplayer.peer_disconnected.connect(peer_disconnected.emit)
	multiplayer.connected_to_server.connect(connected_to_server.emit)
	multiplayer.connection_failed.connect(connection_failed.emit)
	multiplayer.server_disconnected.connect(server_disconnected.emit)

func host_session():
	peer.create_server(Config.LAN.port)
	multiplayer.multiplayer_peer = peer

func join_session(ip_address : String):
	if not ip_address.is_valid_ip_address():
		connection_failed.emit()
		return
	
	var err = peer.create_client(ip_address, Config.LAN.port)
	if err != OK:
		connection_failed.emit()
		return
	
	multiplayer.multiplayer_peer = peer
