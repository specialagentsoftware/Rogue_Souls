extends Marker2D

func _process(_delta: float) -> void:
	rotate(get_angle_to(get_global_mouse_position()))
