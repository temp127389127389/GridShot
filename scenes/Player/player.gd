extends CharacterBody2D

var id = 0

const movement_speed      = Config.player.movement_speed
const movement_halt_speed = Config.player.movement_halt_speed
const rotation_speed      = Config.player.rotation_speed
const rotation_ads_speed  = Config.player.rotation_ads_speed
const rotation_halt_speed = Config.player.rotation_halt_speed

var rotation_velocity = 0

@export var ads_factor : float = 0
@onready var ads_anim_player = $AnimationPlayer

func _ready():
	if id == 0:
		add_child(Camera2D.new())

func _input(event):
	if event.is_action_pressed("Arrow up"):
		ads_anim_player.play("to ads")
	
	if event.is_action_released("Arrow up"):
		ads_anim_player.play_backwards("to ads")

func _physics_process(delta):
	print(ads_factor)
	
	# if the sum of the input strength of W and S isnt 0: set x velocity to movement speed in the appropriate direction
	# otherwise: decrease x velocity
	# the movement_halt_speed is multiplied by delta to compensate for fps irregularites.
	#   movement_speed isnt multiplied by delta since its a constant velocity and thus not affected by fps
	var y_direction = Input.get_axis("W", "S")
	if y_direction: velocity.y = movement_speed * y_direction
	else:           velocity.y = move_toward(velocity.y, 0, movement_halt_speed * delta)
	
	# the the same as above but with the y axis
	var x_direction = Input.get_axis("A", "D")
	if x_direction: velocity.x = movement_speed * x_direction
	else:           velocity.x = move_toward(velocity.x, 0, movement_halt_speed * delta)
	
	# normalize the velocity vector2 to prevent greater movement speed while walking diagonally
	# only normalize if the velocity increased this frame. otherwise movement_halt_speed wouldnt work
	# KNWON ISSUE:
	#     the gradual decline in y velocity isnt smooth when holding W xor S
	#     using AND in the below if statement wouldnt give the desired result
	#     this issue wont be fixed since the effort would be greater than the benefit
	if y_direction or x_direction:
		velocity = velocity.normalized() * movement_speed
	
	move_and_slide()
	
	
	# handle rotation in the same way as movement
	var rotation_direction = Input.get_axis("Arrow left", "Arrow right")
	if rotation_direction: rotation_velocity = get_current_rotation_speed() * rotation_direction
	else:                  rotation_velocity = move_toward(rotation_velocity, 0, rotation_halt_speed * delta)
	rotation += rotation_velocity * delta


func get_current_rotation_speed() -> float:
	# the current rotation speed is dependent on ads_state and ads_factor
	# ads_factor is dependent on the to_ads animation progress
	
	var rotation_speed_delta = rotation_speed - rotation_ads_speed
	var current_speed = rotation_speed - rotation_speed_delta * ads_factor
	
	return current_speed
