extends Sprite2D

func _ready() -> void:
	ghosting()

func set_property(tx_pos,tx_scale) -> void:
	position = tx_pos
	scale = tx_scale
	
func ghosting() -> void:
	var tween_fade = get_tree().create_tween()
	tween_fade.tween_property(self,"self_modulate",Color(1, 1, 1, 0),0.75)
	await tween_fade.finished
	queue_free()

func _process(delta):
	rotate(get_angle_to(get_global_mouse_position()))
