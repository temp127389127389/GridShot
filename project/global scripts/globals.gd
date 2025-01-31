extends Node

var MainMenu_scene = preload("res://scenes/MainMenu/main_menu.tscn")
var Game_scene = preload("res://scenes/Game/game.tscn")

@onready var main_node = $/root/main


func _ready():
	#get_window().set_mode(Window.MODE_FULLSCREEN)
	
	# debug
	multiplayer.connected_to_server.connect(print.bind("connected to server"))
	multiplayer.connection_failed.connect(print.bind("connection failed"))
	multiplayer.server_disconnected.connect(print.bind("server disconnect"))
	multiplayer.peer_connected.connect(print.bind("peer connected"))
	multiplayer.peer_disconnected.connect(print.bind("peer disconnected"))
	
	disperse_windows.call_deferred()

# debug
func disperse_windows():
	var screen_TL = DisplayServer.screen_get_position(DisplayServer.get_primary_screen()) + Vector2i(0, 40)
	var pos_idx = OS.get_cmdline_args()[-1].to_int()
	
	get_window().position = [
		screen_TL + Vector2i(0, 0),
		screen_TL + Vector2i(get_window().size.x - 20, 0),
		screen_TL + Vector2i(0, get_window().size.y),
		screen_TL + get_window().size
	][pos_idx]


func _input(event):
	if event.is_action_pressed("Esc"):
		# debug
		get_window().set_mode(Window.MODE_WINDOWED)
	
	# debug
	if Input.is_key_pressed(KEY_CTRL) and Input.is_key_label_pressed(KEY_W):
		quit_program()



func start_game():
	main_node.get_node("MainMenu").queue_free()
	main_node.add_child(Game_scene.instantiate())

func exit_game():
	main_node.get_node("Game").queue_free()
	main_node.add_child(MainMenu_scene.instantiate())

func quit_program():
	get_tree().quit()
