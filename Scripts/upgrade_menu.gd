class_name UpgradeMenu extends Control

@onready var level_number: Label = $Panel/LevelNumber
@onready var p: player = get_tree().get_first_node_in_group("player")
@onready var overlay: CanvasLayer = p.get_node("Camera2D/CanvasLayer")
@onready var walls: TileMap = get_tree().get_first_node_in_group("walls")

func _ready() -> void:
	var screen_size :Vector2 = DisplayServer.screen_get_size()
	get_tree().paused = true
	overlay.visible = false
	_hide_walls()
	var mod_x = p.position.x - 300
	var mod_y = p.position.y - 250
	position = Vector2(mod_x,mod_y)
	
func _set_level(level:int):
	level_number.text = str(level)

func _on_button_pressed() -> void:
	get_tree().paused = false
	_show_overlay()
	_show_walls()
	queue_free() # Replace with function body.

func _on_strength_pressed() -> void:
	p._set_strength(1)
	_show_overlay()
	_show_walls()
	get_tree().paused = false
	queue_free()

func _on_speed_pressed() -> void:
	p._set_speed(1)
	_show_overlay()
	_show_walls()
	get_tree().paused = false
	queue_free()

func _on_magic_pressed() -> void:
	p._set_magic(1)
	_show_overlay()
	_show_walls()
	get_tree().paused = false
	queue_free()

func _on_stamina_pressed() -> void:
	p._set_stamina(1)
	_show_overlay()
	_show_walls()
	get_tree().paused = false
	queue_free()

func _on_health_pressed() -> void:
	p._set_health(1)
	_show_overlay()
	_show_walls()
	get_tree().paused = false
	queue_free()
	
func _on_special_pressed() -> void:
	p._set_special(1)
	_show_overlay()
	_show_walls()
	get_tree().paused = false
	queue_free()

func _show_overlay() -> void:
	overlay.visible = true
	
func _hide_walls() -> void:
		for child in walls.get_children():
			child.visible = false
		walls.visible = false
	
func _show_walls() -> void:
		for child in walls.get_children():
			child.visible = true
		walls.visible = true
