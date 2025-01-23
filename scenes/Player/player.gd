extends CharacterBody2D

const movement_speed = Globals.player_config.movement_speed
const halt_speed = Globals.player_config.halt_speed

func _physics_process(delta):
	# if the sum of the input strength of W and S isnt 0: set x velocity to movement speed in the appropriate direction
	# otherwise: decrease x velocity
	# the halt_speed is multiplied by delta to compensate for fps irregularites.
	#   movement_speed isnt multiplied by delta since its a constant velocity and thus not affected by fps
	var y_direction = Input.get_axis("W", "S")
	if y_direction: velocity.y = movement_speed * y_direction
	else:           velocity.y = move_toward(velocity.y, 0, halt_speed * delta)
	
	# the the same as above but with the y axis
	var x_direction = Input.get_axis("A", "D")
	if x_direction: velocity.x = movement_speed * x_direction
	else:           velocity.x = move_toward(velocity.x, 0, halt_speed * delta)
	
	# normalize the velocity vector2 to prevent greater movement speed while walking diagonally
	# only normalize if the velocity increased this frame. otherwise halt_speed wouldnt work
	# KNWON ISSUE:
	#     the gradual decline in y velocity isnt smooth when holding W xor S
	#     using AND in the below if statement wouldnt give the desired result
	#     this issue wont be fixed since the effort would be greater than the benefit
	if y_direction or x_direction:
		velocity = velocity.normalized() * movement_speed
	
	move_and_slide()
