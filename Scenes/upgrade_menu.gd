class_name UpgradeMenu extends Control

@onready var level_number: Label = $Panel/LevelNumber
@onready var p: player = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	get_tree().paused = true
	
func _set_level(level:int):
	level_number.text = str(level)

func _on_button_pressed() -> void:
	get_tree().paused = false
	queue_free() # Replace with function body.

func _on_strength_pressed() -> void:
	p._set_strength(1)
	get_tree().paused = false
	queue_free()

func _on_speed_pressed() -> void:
	p._set_speed(1)
	get_tree().paused = false
	queue_free()

func _on_magic_pressed() -> void:
	p._set_magic(1)
	get_tree().paused = false
	queue_free()

func _on_stamina_pressed() -> void:
	p._set_stamina(1)
	get_tree().paused = false
	queue_free()

func _on_health_pressed() -> void:
	p._set_health(1)
	get_tree().paused = false
	queue_free()
	
func _on_special_pressed() -> void:
	p._set_special(1)
	get_tree().paused = false
	queue_free()
