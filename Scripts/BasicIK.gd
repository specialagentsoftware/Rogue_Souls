@tool
extends Node2D

@onready var hand_pos_marker = $HandMarker
var global_hand_pos : Vector2
@onready var shoulder = $Shoulder
@onready var elbow = $Shoulder/Elbow
@onready var hand = $Shoulder/Elbow/Hand
@export var elbow_flipped = true

var upper_arm_len = 0
var lower_arm_len = 0
var max_len = 0

func _ready():
	update_arm_lens()

func update_arm_lens():
	upper_arm_len = shoulder.global_position.distance_to(elbow.global_position)
	lower_arm_len = hand.global_position.distance_to(elbow.global_position)
	max_len = upper_arm_len + lower_arm_len

func _process(_delta):
	if Engine.is_editor_hint():
		update_arm_lens() # arm sizing can be changed whenever while in editor
	
	if !is_instance_valid(hand_pos_marker):
		return
	
	var dist = global_hand_pos.distance_to(hand_pos_marker.global_position)
	if dist < 1.0:
		hand.global_rotation = hand_pos_marker.global_rotation
		return
	
	global_hand_pos = hand_pos_marker.global_position

	var hand_pos = to_global(get_hand_pos_local())
	var elbow_pos = to_global(get_elbow_pos_local())
	shoulder.global_rotation = global_position.angle_to_point(elbow_pos)
	elbow.global_position = elbow_pos
	elbow.global_rotation = (hand_pos - elbow_pos).angle()
	hand.global_rotation = hand_pos_marker.global_rotation

func get_hand_pos_local():
	var hand_pos = global_hand_pos
	if shoulder.global_position.distance_to(hand_pos) > max_len:
		var dir = global_position.direction_to(hand_pos)
		hand_pos = global_position + dir * max_len
	return to_local(hand_pos)

func get_elbow_pos_local():
	var local_hand_pos = to_local(global_hand_pos)
	
	var hand_pos_x_sq = local_hand_pos.x * local_hand_pos.x
	var hand_pos_y_sq = local_hand_pos.y * local_hand_pos.y
	var n = upper_arm_len * upper_arm_len + hand_pos_x_sq + hand_pos_y_sq - lower_arm_len * lower_arm_len
	var d = 2 * upper_arm_len * sqrt(hand_pos_x_sq + hand_pos_y_sq)
	var relative_elbow_angle = acos(n/d)
	
	if is_nan(relative_elbow_angle):
		relative_elbow_angle = 0.0
	
	var s:int = 1
	if elbow_flipped:
		s = -1
	
	return Vector2.RIGHT.rotated(s * relative_elbow_angle + local_hand_pos.angle()) * upper_arm_len
