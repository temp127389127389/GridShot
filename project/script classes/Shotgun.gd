extends Gun
class_name Shotgun

const base_spread = Config.weapons.shotgun_base_spread
const ads_spread = Config.weapons.shotgun_ads_spread
const firing_speed = Config.weapons.shotgun_firing_speed
const projectile_type = "bullet"

const fragment_count = Config.weapons.shotgun_fragment_count

func fire(player_name : String, current_ads_factor : float, rotation : float, position : Vector2):
	# the bullet always travels in the direction it is facing
	# therefore bullet spread can be done by modifying the bullets rotation
	var current_accuracy = get_current_accuracy(current_ads_factor)
	
	for _f in range(fragment_count):
		var bullet_rotation = rotation + randf_range(-current_accuracy/2, current_accuracy/2)
		
		# the below line calls the function `spawn_bullet(name, rotation, position)` on
		#   the peer with peer id 1, aka the lobby host. this is needed since adding children
		#   from any peer which isnt the lobby host is wonky and likely to fail
		Globals.spawn_projectile.rpc_id(1, projectile_type, player_name, bullet_rotation, position)
