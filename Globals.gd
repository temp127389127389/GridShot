extends Node

var MainMenu_scene = preload("res://scenes/MainMenu/MainMenu.tscn")
var Game_scene = preload("res://scenes/Game/Game.tscn")

@onready var main_node = $/root/main

func start_game():
	main_node.get_node("MainMenu").queue_free()
	main_node.add_child(Game_scene.instantiate())

func quit_game():
	get_tree().quit()



func _input(event):
	if event.is_action_pressed("Esc"):
		get_window().set_mode(Window.MODE_WINDOWED)
		get_window().set_size(Vector2(1000, 500))
		get_window().set_position(get_window().size/2)
