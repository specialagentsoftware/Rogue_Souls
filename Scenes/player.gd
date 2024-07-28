extends CharacterBody2D

@export var speed :int = 200
@export var friction :float = 0.50
@export var acceleration :float = 0.1
@onready var ap = $Marker2D/Graphics/AnimationPlayer


func get_movement():
	var input = Vector2()
	if Input.is_action_pressed('right'):
		input.x += 1
	if Input.is_action_pressed('left'):
		input.x -= 1
	if Input.is_action_pressed('back'):
		input.y += 1
	if Input.is_action_pressed('forward'):
		input.y -= 1
	return input

func _physics_process(delta):
	var direction = get_movement()
	
	if direction.x != 0 or direction.y != 0 and ap.current_animation != "Punch" and ap.current_animation != "Block":
		_play_animation("Walk")
	elif ap.current_animation != "Punch" and ap.current_animation != "Block":
		_play_animation("Idle")
		
	if Input.is_action_just_pressed("punch"):
		direction.x = 0
		direction.y = 0
		ap.stop()
		if ap.current_animation == "Punch":
			return
		ap.play("Punch")
		
	if Input.is_action_just_pressed("block"):
		direction.x = 0
		direction.y = 0
		ap.stop()
		if ap.current_animation == "Block":
			return
		ap.play("Block")
	
	if direction.length() > 0:
		velocity = velocity.lerp(direction.normalized() * speed, acceleration)
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)
	move_and_slide()
	
func _play_animation(animation_name):
	ap.play(animation_name)
