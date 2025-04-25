extends ConstantProjectile


func setup(source_ : Player, rotation_ : float, start_position_ : Vector2):
	super.setup(source_, rotation_, start_position_)
	self.movement_speed = Config.weapons.bullet_movement_speed
	$LifeTimeTimer.wait_time = Config.weapons.bullet_life_time

	CollidedWithPlayer.connect(_on_collided_with_player)

func _on_collided_with_player(player : Player):
	if player != source:
		print("dealing dmg to %s" % player)
		queue_free()

# a timer that removes the projectile if its been alive for long enough
func _on_life_time_timer_timeout():
	if is_multiplayer_authority():
		queue_free()
