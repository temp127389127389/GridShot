extends Node2D

@onready var Camera_node = $Camera
@onready var Player_node = $Player

func _process(_delta):
	Camera_node.position = Player_node.position
