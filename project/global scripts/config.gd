extends Node

class player:
	const movement_speed = 200       # constant velocity
	const movement_ads_speed = 125
	const movement_halt_speed = 2000 # -velocity/second
	const rotation_speed = 3.5
	const rotation_ads_speed = 1.5
	const rotation_halt_speed = 35

class network:
	const signaling_server_url = "wss://theodor-test-ced3867bc168.herokuapp.com/"
	const lobby_size = 6

class debug:
	const network_logs_verbose = false
	const print_network_logs = true
