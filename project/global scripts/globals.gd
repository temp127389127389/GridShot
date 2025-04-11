extends Node

var MainMenu_scene : PackedScene = preload("res://scenes/MainMenu/main_menu.tscn")
var Game_scene : PackedScene = preload("res://scenes/Game/game.tscn")
var Bullet_scene : PackedScene = preload("res://scenes/Bullet/bullet.tscn")

@onready var main_node = $/root/main

func _ready():
	#get_window().set_mode(Window.MODE_FULLSCREEN)
	
	# debug
	#multiplayer.connected_to_server.connect(print.bind("connected to server"))
	#multiplayer.connection_failed.connect(print.bind("connection failed"))
	#multiplayer.server_disconnected.connect(print.bind("server disconnect"))
	#multiplayer.peer_connected.connect(print.bind("peer connected"))
	#multiplayer.peer_disconnected.connect(print.bind("peer disconnected"))
	
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
	if event.is_action_pressed("Ctrl + W"):
		quit_program()




func start_as_lobby_host(lobby_name : String):
	if not Config.debug.multiplayer_enabled:
		main_node.get_node("MainMenu").queue_free()
		load_game_scene()
		(func(): main_node.get_node("Game")._on_multiplayer_ready()).call_deferred()
		return
	
	# init the multiplayer node
	var multiplayer_node : WebRTCLobbyHost = Network.init_host_node(lobby_name)
	main_node.add_child(multiplayer_node)
	
	# connect log signal to print
	if Config.debug.print_network_logs:
		multiplayer_node.Log.connect(print)
	
	main_node.get_node("MainMenu").queue_free()
	
	load_game_scene()
	multiplayer_node.LobbyReady.connect(main_node.get_node("Game")._on_multiplayer_ready)

func start_as_player_client():
	# init the multiplayer node
	var multiplayer_node : WebRTCPlayerClient = Network.init_player_node()
	main_node.add_child(multiplayer_node)
	
	# debug - enables the join button
	multiplayer_node.ConnectedToSignalingServer.connect(
		func(): main_node.get_node("MainMenu/PlayerJoinButton").disabled = false,
		CONNECT_ONE_SHOT
	)
	multiplayer_node.ReceivedLobbyDict.connect(
		func(lobby_dict : Dictionary, _hash : String): if len(lobby_dict) == 1: main_node.get_node("MainMenu/LobbyIdLineEdit").text = lobby_dict.keys()[0],
		CONNECT_ONE_SHOT
	)
	
	# connect log signal to print
	if Config.debug.print_network_logs:
		multiplayer_node.Log.connect(print)

func player_client_join_lobby(lobby_id : String):
	var multiplayer_node : WebRTCPlayerClient = main_node.get_node("WebRTCPlayerClient")
	multiplayer_node.join_lobby(lobby_id)
	
	main_node.get_node("MainMenu").queue_free()
	load_game_scene()

func load_game_scene():
	main_node.add_child(Game_scene.instantiate())

func exit_game():
	main_node.get_node("Game").queue_free()
	main_node.add_child(MainMenu_scene.instantiate())

func quit_program():
	get_tree().quit()


@rpc("any_peer", "call_local")
func spawn_bullet(owner_node_name : String, rotation : float, position : Vector2):
	var Game_node = main_node.get_node("Game")
	var owner_player_node = Game_node.get_node(owner_node_name)
	
	var bullet = Bullet_scene.instantiate()
	bullet.setup(owner_player_node, rotation, position)
	
	Game_node.add_child(bullet, true)
