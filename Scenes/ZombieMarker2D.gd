extends Marker2D

@onready var player : player = get_tree().get_first_node_in_group("player")

func _process(_delta: float) -> void:
	var target = player.position
	look_at(target)
