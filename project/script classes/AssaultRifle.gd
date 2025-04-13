class_name AssaultRifle
extends Weapon

const base_spread = Config.weapons.assault_rifle_base_spread
const ads_spread = Config.weapons.assault_rifle_ads_spread
const firing_speed = Config.weapons.assault_rifle_firing_speed

func fire(player_name : String, current_ads_factor : float, rotation : float, position : Vector2):
	# the bullet always travels in the direction it is facing
	# therefore bullet spread can be done by modifying the bullets rotation
	var current_accuracy = get_current_accuracy(current_ads_factor)
	var bullet_rotation = rotation + randf_range(-current_accuracy/2, current_accuracy/2)
	
	# the below line calls the function `spawn_bullet(name, rotation, position)` on
	#   the peer with peer id 1, aka the lobby host. this is needed since adding children
	#   from any peer which isnt the lobby host is wonky and likely to fail
	Globals.spawn_bullet.rpc_id(1, player_name, bullet_rotation, position)
