extends Node

class player:
	const movement_speed = 200       # constant velocity
	const movement_ads_speed = 125
	const movement_halt_speed = 2000 # -velocity/second
	const rotation_speed = 3.5
	const rotation_ads_speed = 1.5
	const rotation_halt_speed = 35
	const firing_speed = 1.0/8       # seconds between shots

class projectiles:
	const bullet_movement_speed = 500

class network:
	const signaling_server_url = "wss://theodor-test-ced3867bc168.herokuapp.com/"
	const lobby_size = 6

class debug:
	const multiplayer_enabled = true
	const network_logs_verbose = false
	const print_network_logs = true
