extends Node

class player:
	const movement_speed = 250         # constant velocity
	const movement_ads_speed = 125     # constant velocity
	const movement_halt_speed = 2000   # -velocity/second
	const rotation_speed = 4
	const rotation_ads_speed = 1.5
	const rotation_halt_speed = 35

class weapons:
	const bullet_movement_speed = 1000        # constant velocity
	const bullet_life_time = 5                # seconds
	
	const assault_rifle_base_spread = PI/4    # radians bullet spread
	const assault_rifle_ads_spread = PI/32    # radians bullet spread
	const assault_rifle_firing_speed = 6      # shots per second
	
	const sub_machine_gun_base_spread = PI/3  # radians bullet spread
	const sub_machine_gun_ads_spread = PI/6   # radians bullet spread
	const sub_machine_gun_firing_speed = 18   # shots per second
	
	const shotgun_base_spread = PI/2          # radians bullet spread
	const shotgun_ads_spread = PI/5           # radians bullet spread
	const shotgun_firing_speed = 1.25         # shots per second
	const shotgun_fragment_count = 10

class network:
	const signaling_server_url = "wss://theodor-test-ced3867bc168.herokuapp.com/"
	const lobby_size = 6

class debug:
	const multiplayer_enabled = false
	const network_logs_verbose = false
	const print_network_logs = false
