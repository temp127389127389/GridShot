extends Node2D

#@onready var Camera_node = $Camera
#@onready var Player_node = $Player

@onready var Player_scene = preload("res://scenes/Player/player.tscn")

func _ready():
	call_deferred("add_player")

func add_player():
	add_child(Player_scene.instantiate())
