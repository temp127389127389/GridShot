extends Node2D

@onready var path_line = $PathLine

var player_raycast : RayCast2D
@onready var tripwire_length_raycast : RayCast2D = $TripwireLengthRaycast

@onready var tripwire_connector_1 : Line2D = $TripwireConnector1
@onready var tripwire_connector_2 : Line2D = $TripwireConnector2
@onready var tripwire_line : Line2D = $TripwireLine

var source : Player :
	set = _on_source_set

var tripwire_valid = false

func _ready():
	tripwire_length_raycast.target_position = Vector2.RIGHT * Config.throwables.tripwire_max_length

func _on_source_set(new_value):
	source = new_value
	player_raycast = source.get_node("ThrowablePreviewRaycast")

func _process(_delta):
	if player_raycast.is_colliding():
		position = player_raycast.get_collision_point()
		rotation = player_raycast.get_collision_normal().angle()
		
		tripwire_valid = check_tripwire_length_valid()
	
	else:
		var direction = Vector2.from_angle(player_raycast.global_rotation)
		position = source.position + direction * player_raycast.target_position.length()
		rotation = position.angle_to_point(source.position)
		
		tripwire_valid = false
	
	
	if tripwire_valid:
		tripwire_connector_1.default_color = Color("#0c7f96") # turquoise
		
		tripwire_connector_2.visible = true
		tripwire_connector_2.position = to_local(tripwire_length_raycast.get_collision_point())
		tripwire_connector_2.global_rotation = tripwire_length_raycast.get_collision_normal().angle()
		
		tripwire_line.set_point_position(1, tripwire_connector_2.position)
		
		# TODO THIS SHIT SHOULDNT UPDATE EVERY FRAME
		
	else:
		tripwire_connector_1.default_color = Color("#c92e2ed3") # red
		
		tripwire_connector_2.visible = false
		tripwire_line.set_point_position(1, Vector2.ZERO)
	
	move_path_line()


func check_tripwire_length_valid() -> bool:
	tripwire_length_raycast.force_raycast_update()
	if tripwire_length_raycast.is_colliding():
		return true
	else:
		return false

func move_path_line():
	var preview_position = to_local(global_position)
	var player_position = to_local(source.global_position)
	var player_point_position = player_position + player_position.direction_to(preview_position) * 76
	var preview_point_position = preview_position + preview_position.direction_to(player_position) * 36
	
	if preview_point_position.distance_to(player_position) < player_point_position.distance_to(player_position):
		path_line.set_point_position(0, Vector2.ZERO)
		path_line.set_point_position(1, Vector2.ZERO)
	
	else:
		path_line.set_point_position(0, player_point_position)
		path_line.set_point_position(1, preview_point_position)
