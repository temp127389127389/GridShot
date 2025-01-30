extends Node2D

var Player_scene = preload("res://scenes/Player/player.tscn")

func _ready():
	if multiplayer.is_server():
		add_player()
		Network.peer_connected.connect(add_player)
		Network.peer_disconnected.connect(remove_player)
	
	else:
		Network.server_disconnected.connect(server_disconnected)

func add_player(id = 1):
	var new_player = Player_scene.instantiate()
	new_player.name = Naming.to_player_name(id)
	add_child(new_player)

func remove_player(id):
	get_node(Naming.to_player_name(id)).queue_free()

func server_disconnected():
	Globals.exit_game()
