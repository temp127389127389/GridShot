extends Node

var MainMenu_scene = preload("res://scenes/MainMenu/MainMenu.tscn")
var Game_scene = preload("res://scenes/Game/Game.tscn")

@onready var main_node = $/root/main

func start_game():
	main_node.get_node("MainMenu").queue_free()
	main_node.add_child(Game_scene.instantiate())

func quit_game():
	get_tree().quit()
