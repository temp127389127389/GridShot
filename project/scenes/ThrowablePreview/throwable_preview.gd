extends Node2D

@onready var path_line = $PathLine

var player_raycast : RayCast2D
var distance_from_player : float

var source : Player : 
	set(new_value):
		source = new_value
		_on_source_set()

func _on_source_set():
	player_raycast = source.get_node("ThrowablePreviewRaycast")

func _process(_delta):
	# move the preview box
	if player_raycast.is_colliding():
		position = player_raycast.get_collision_point()
	else:
		var direction = Vector2.from_angle(player_raycast.global_rotation)
		position = player_raycast.global_position + direction * player_raycast.target_position.length()
	
	# move the path line
	var preview_position = to_local(global_position)
	var player_position = to_local(source.global_position)
	var player_point_position = player_position + player_position.direction_to(preview_position) * 76
	var preview_point_position = preview_position + preview_position.direction_to(player_position) * 48
	
	if preview_point_position.distance_to(player_position) < player_point_position.distance_to(player_position):
		path_line.set_point_position(0, Vector2.ZERO)
		path_line.set_point_position(1, Vector2.ZERO)
	
	else:
		path_line.set_point_position(0, player_point_position)
		path_line.set_point_position(1, preview_point_position)
	
	# update distance to player, which is used when firing
	distance_from_player = source.position.distance_to(position)
