@tool
extends Node2D

@onready var hand_pos_marker :Marker2D = $HandMarker
var global_hand_pos : Vector2
@onready var shoulder :Node2D = $Shoulder
@onready var elbow :Node2D = $Shoulder/Elbow
@onready var hand :Node2D = $Shoulder/Elbow/Hand

@export var elbow_flipped :bool = true

var upper_arm_len :int = 0
var lower_arm_len :int = 0
var max_len :int = 0

func _ready() -> void:
	update_arm_lens()

func update_arm_lens() -> void:
	upper_arm_len = shoulder.global_position.distance_to(elbow.global_position)
	lower_arm_len = hand.global_position.distance_to(elbow.global_position)
	max_len = upper_arm_len + lower_arm_len

func _process(delta:float) -> void:
	if Engine.is_editor_hint():
		update_arm_lens() # arm sizing can be changed whenever while in editor
	
	if !is_instance_valid(hand_pos_marker):
		return
	
	var dist :float = global_hand_pos.distance_to(hand_pos_marker.global_position)
	if dist < 1.0:
		hand.global_rotation = hand_pos_marker.global_rotation
		return
	
	global_hand_pos = hand_pos_marker.global_position

	var hand_pos :Vector2 = to_global(get_hand_pos_local())
	var elbow_pos :Vector2 = to_global(get_elbow_pos_local())
	shoulder.global_rotation = global_position.angle_to_point(elbow_pos)
	elbow.global_position = elbow_pos
	elbow.global_rotation = (hand_pos - elbow_pos).angle()
	hand.global_rotation = hand_pos_marker.global_rotation

func get_hand_pos_local() -> Vector2:
	var hand_pos: Vector2 = global_hand_pos
	if shoulder.global_position.distance_to(hand_pos) > max_len:
		var dir: Vector2 = global_position.direction_to(hand_pos)
		hand_pos = global_position + dir * max_len
	return to_local(hand_pos)

func get_elbow_pos_local() -> Vector2:
	var local_hand_pos :Vector2 = to_local(global_hand_pos)
	
	var hand_pos_x_sq :float = local_hand_pos.x * local_hand_pos.x
	var hand_pos_y_sq :float = local_hand_pos.y * local_hand_pos.y
	var n :float = upper_arm_len * upper_arm_len + hand_pos_x_sq + hand_pos_y_sq - lower_arm_len * lower_arm_len
	var d :float = 2 * upper_arm_len * sqrt(hand_pos_x_sq + hand_pos_y_sq)
	var relative_elbow_angle :float = acos(n/d)
	
	if is_nan(relative_elbow_angle):
		relative_elbow_angle = 0.0
	
	var sign :int = 1
	if elbow_flipped:
		sign = -1
	
	return Vector2.RIGHT.rotated(sign * relative_elbow_angle + local_hand_pos.angle()) * upper_arm_len
