extends CharacterBody2D

@export var id : int

const movement_speed      = Config.player.movement_speed
const movement_ads_speed  = Config.player.movement_ads_speed
const movement_halt_speed = Config.player.movement_halt_speed
const rotation_speed      = Config.player.rotation_speed
const rotation_ads_speed  = Config.player.rotation_ads_speed
const rotation_halt_speed = Config.player.rotation_halt_speed

var rotation_velocity = 0

@export var ads_factor : float = 0
@onready var ads_anim_player = $AnimationPlayer

func _enter_tree():
	# ensures this instance's nodes' attributes cant be changed by other game instances
	id = int(name)
	set_multiplayer_authority(id)
	
	# debug
	$Label.text = str(get_multiplayer_authority()) + "\n" + "\n".join(IP.get_local_addresses())

func _ready():
	# all player instances in all game instances have a dedicated Camera2D
	# the below code ensures the camera of each player is prioritized in its respective game instance
	if is_multiplayer_authority():
		$Camera2D.make_current()
	
	$WeaponFireCooldownTimer.wait_time = Config.player.firing_speed

func _input(event):
	if not is_multiplayer_authority():
		return
	
	if event.is_action_pressed("Arrow up"):
		ads_anim_player.play("to ads")
	
	if event.is_action_released("Arrow up"):
		ads_anim_player.play_backwards("to ads")
	
	if event.is_action_pressed("E"):
		Globals.rpc_test.rpc_id(1, self, multiplayer.get_unique_id())

func _physics_process(delta):
	if not is_multiplayer_authority():
		return
	
	if Input.is_action_pressed("Space"):
		fire_weapon()
	
	# if the sum of the input strength of W and S isnt 0: set x velocity to movement speed in the appropriate direction
	# otherwise: decrease x velocity
	# the movement_halt_speed is multiplied by delta to compensate for fps irregularites.
	#   movement_speed isnt multiplied by delta since its a constant velocity and thus not affected by fps
	var movement_vector = Input.get_vector("A", "D", "W", "S")
	if movement_vector.x: velocity.x = get_current_movement_speed() * movement_vector.x
	else:                 velocity.x = move_toward(velocity.x, 0, movement_halt_speed * delta)
	
	# the the same as above but with the y axis
	if movement_vector.y: velocity.y = get_current_movement_speed() * movement_vector.y
	else:                 velocity.y = move_toward(velocity.y, 0, movement_halt_speed * delta)
	
	# modify velocity to push players away from eachother if they're overlapping
	var overlapping_players : Array = $PlayerRepulsionArea2D.get_overlapping_bodies().filter(func(body : Node2D): return body != self)
	if overlapping_players:
		var repulsion_vectors = []
		
		for player : Node2D in overlapping_players:
			var player_distance = max(1, position.distance_to(player.position))
			var opposite_direction = -position.direction_to(player.position)
			
			if opposite_direction == Vector2.ZERO:
				opposite_direction = Vector2.from_angle(randf()*2*PI)
			
			repulsion_vectors.append(opposite_direction * 90 * wrap((30/player_distance)**2, 0.5, 1))
		
		var final_repulsion_vector = repulsion_vectors.reduce(func(sum, vector): return sum + vector)
		velocity += final_repulsion_vector
	
	# handle rotation in the same way as movement
	var rotation_direction = Input.get_axis("Arrow left", "Arrow right")
	if rotation_direction: rotation_velocity = get_current_rotation_speed() * rotation_direction
	else:                  rotation_velocity = move_toward(rotation_velocity, 0, rotation_halt_speed * delta)
	rotation += rotation_velocity * delta
	
	
	move_and_slide()


func get_current_movement_speed() -> float:
	# the current movement speed is dependent on ads_factor, which is
	#   dependent on the to_ads animation progress
	
	var movement_speed_delta = movement_speed - movement_ads_speed
	var current_speed = movement_speed - movement_speed_delta * ads_factor
	
	return current_speed

func get_current_rotation_speed() -> float:
	# the current rotation speed is dependent on ads_factor, which is
	#   dependent on the to_ads animation progress
	
	var rotation_speed_delta = rotation_speed - rotation_ads_speed
	var current_speed = rotation_speed - rotation_speed_delta * ads_factor
	
	return current_speed


func fire_weapon():
	var timer : Timer = $WeaponFireCooldownTimer
	
	if timer.time_left == 0:
		# the below line calls the function `spawn_bullet(name, rotation, position)` on
		#   the peer with peer id 1, aka the lobby host. this is needed since adding children
		#   from any peer which isnt the lobby host is wonky and likely to fail
		Globals.spawn_bullet.rpc_id(1, name, rotation, position)
		timer.start()
