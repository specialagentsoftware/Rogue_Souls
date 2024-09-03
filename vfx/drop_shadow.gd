extends Node2D

@export var is_static = false
@export var offset_amnt = 14
const shadow_direction = 30 # in degrees

var shadow_node : Node2D
func _ready():
	var parent : Node2D = get_parent()
	var shadow_manager = get_tree().get_first_node_in_group("shadow_manager")
	
	if shadow_manager == null or !(parent is Sprite2D or AnimatedSprite2D or TileMap):
		set_process(false)
		return
	if is_static:
		set_process(false)
	
	global_scale = parent.global_scale
	shadow_node = parent.duplicate(8)
	for c in shadow_node.get_children():
		c.free()
	shadow_node.modulate = Color.BLACK
	#shadow_manager.add_child(shadow_node)
	shadow_manager.call_deferred("add_child", shadow_node)
	update_position()
	update_visibility()

func _process(_delta):
	update_position()

func update_position():
	var pos_vec = Vector2.RIGHT.rotated(deg_to_rad(shadow_direction))*offset_amnt
	position = Vector2.ZERO
	shadow_node.global_position = global_position + pos_vec
	shadow_node.global_rotation = global_rotation
	shadow_node.global_scale = global_scale

func update_visibility():
	shadow_node.visible = is_visible_in_tree()

func on_tree_exit():
	if is_instance_valid(shadow_node):
		shadow_node.queue_free()
