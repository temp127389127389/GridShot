extends Node

var scenes = _scenes.new()
class _scenes extends RefCounted:
	const main_menu           : PackedScene = preload("res://scenes/MainMenu/main_menu.tscn")
	const game                : PackedScene = preload("res://scenes/Game/game.tscn")
	
	const player              : PackedScene = preload("res://scenes/Player/player.tscn")
	const throwable_preview   : PackedScene = preload("res://scenes/ThrowablePreview/throwable_preview.tscn")
	const tripwire_preview    : PackedScene = preload("res://scenes/TripwirePreview/tripwire_preview.tscn")
	
	const screen_flash        : PackedScene = preload("res://scenes/ScreenFlash/screen_flash.tscn")
	const smoke_cloud         : PackedScene = preload("res://scenes/SmokeCloud/smoke_cloud.tscn")
	const tripwire            : PackedScene = preload("res://scenes/Tripwire/tripwire.tscn")
	
	const bullet              : PackedScene = preload("res://scenes/Projectiles/Bullet/bullet.tscn")
	const molotov             : PackedScene = preload("res://scenes/Projectiles/Molotov/molotov.tscn")
	const flash_grenade       : PackedScene = preload("res://scenes/Projectiles/FlashGrenade/flash_grenade.tscn")
	const smoke_grenade       : PackedScene = preload("res://scenes/Projectiles/SmokeGrenade/smoke_grenade.tscn")


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
	if event.is_action_pressed("E"):
		print(scenes.get("game"))
	
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
	main_node.add_child(scenes.game.instantiate())

func exit_game():
	main_node.get_node("Game").queue_free()
	main_node.add_child(scenes.main_menu.instantiate())

func quit_program():
	get_tree().quit()



@rpc("any_peer", "call_local")
func spawn_projectile(
			projectile_scene_name : String,
			owner_node_name : String,
			rotation : float,
			position : Vector2,
			throw_distance = null # float | null
		):
	
	var game_node = main_node.get_node("Game")
	var owner_player_node = game_node.get_node(owner_node_name)
	
	var new_projectile = scenes.get(projectile_scene_name).instantiate()
	
	if new_projectile is ThrowableProjectile: new_projectile.setup(owner_player_node, rotation, position, throw_distance)
	else: new_projectile.setup(owner_player_node, rotation, position)
	
	game_node.add_child(new_projectile, true)

@rpc("any_peer", "call_local")
func flash_peer():
	var flash = scenes.screen_flash.instantiate()
	
	var player_camera = main_node.get_node("Game/%s/Camera2D" % multiplayer.get_unique_id())
	player_camera.add_child(flash, true)

@rpc("any_peer", "call_local")
func spawn_smoke_cloud(position):
	var smoke_cloud = scenes.smoke_cloud.instantiate()
	smoke_cloud.position = position
	smoke_cloud.seed = randi()
	smoke_cloud.emitting = true
	
	var game_node = main_node.get_node("Game")
	game_node.add_child(smoke_cloud, true)

@rpc("any_peer", "call_local")
func spawn_tripwire(
			owner_node_name : String,
			position_1 : Vector2,
			rotation_1 : float,
			position_2 : Vector2,
			rotation_2 : float
		):
	
	var game_node = main_node.get_node("Game")
	var owner_player_node = game_node.get_node(owner_node_name)
	
	var tripwire = scenes.tripwire.instantiate()
	tripwire.source = owner_player_node
	tripwire.position_1 = position_1
	tripwire.rotation_1 = rotation_1
	tripwire.position_2 = position_2
	tripwire.rotation_2 = rotation_2
	
	game_node.add_child(tripwire, true)
