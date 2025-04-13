extends CharacterBody2D

# CharacterBody2D is used for its velocity and physics process
# Area2D is used for its collision detection

var source : CharacterBody2D
var direction : Vector2

const movement_speed = Config.weapons.bullet_movement_speed

func setup(source : CharacterBody2D, rotation : float, position : Vector2):
	self.source = source
	
	direction = Vector2.from_angle(rotation)
	self.rotation = rotation
	self.position = position + direction * Vector2(64, 64) # offset spawn position from player center
	
	$LifeTimeTimer.wait_time = Config.weapons.bullet_life_time

func _physics_process(_delta):
	if not is_multiplayer_authority():
		return
	
	velocity = direction * movement_speed
	move_and_slide()



func _on_body_entered(body : Node2D):
	if not is_multiplayer_authority():
		return
	
	if body != source and body is CharacterBody2D:
		print("bullet hit body %s %s" % [body, typeof(body)])
		queue_free()
	
	elif body is TileMapLayer:
		queue_free()


# a timer that removes the projectile if its been alive for long enough
func _on_life_time_timer_timeout():
	queue_free()
