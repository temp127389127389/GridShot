extends Node2D

var Player_scene = preload("res://scenes/Player/player.tscn")

func _ready():
	if multiplayer.is_server():
		add_player()
		Network.peer_connected.connect(add_player)

func add_player(id = 1):
	var new_player = Player_scene.instantiate()
	new_player.name = str(id)
	add_child(new_player)
