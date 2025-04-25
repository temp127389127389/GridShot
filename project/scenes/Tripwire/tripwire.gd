extends Node2D

# conenctor 1
@onready var tripwire_connector_1 : Line2D = $TripwireConnector1
var position_1 : Vector2
var rotation_1 : float

# connector 2
@onready var tripwire_connector_2 : Line2D = $TripwireConnector2
var position_2 : Vector2
var rotation_2 : float

@onready var tripwire_line : Line2D = $TripwireLine
@onready var collision_polygon : CollisionPolygon2D = $Area2D/CollisionPolygon2D

var source : Player


func _ready():
	# connector positions and rotations
	tripwire_connector_1.position = position_1
	tripwire_connector_1.rotation = rotation_1
	
	tripwire_connector_2.position = position_2
	tripwire_connector_2.rotation = rotation_2
	
	# tripwire line
	tripwire_line.set_point_position(0, position_1)
	tripwire_line.set_point_position(1, position_2)
	
	# calc collision polygon points positions
	var p0 = position_1 + Vector2.from_angle(rotation_1 + PI/2) * (tripwire_line.width/2)
	var p1 = position_1 - Vector2.from_angle(rotation_1 + PI/2) * (tripwire_line.width/2)
	var p2 = position_2 + Vector2.from_angle(rotation_2 + PI/2) * (tripwire_line.width/2)
	var p3 = position_2 - Vector2.from_angle(rotation_2 + PI/2) * (tripwire_line.width/2)
	
	# set collision polygon points
	collision_polygon.polygon = PackedVector2Array([p0, p1, p2, p3])


func _on_body_entered(body : Player):
	if is_multiplayer_authority():
		print("tripwire collision")
		tripwire_connector_1.self_modulate = Color.RED
		get_tree().create_timer(0.1).timeout.connect(func(): tripwire_connector_1.self_modulate = Color.WHITE)
		
		tripwire_connector_2.self_modulate = Color.RED
		get_tree().create_timer(0.1).timeout.connect(func(): tripwire_connector_2.self_modulate = Color.WHITE)
