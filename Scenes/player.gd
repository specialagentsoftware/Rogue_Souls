extends CharacterBody2D

@export var speed :int = 200
@export var friction :float = 0.50
@export var acceleration :float = 0.1
@export var walk_animation_speed :float = 2
@export var punch_animation_speed :float = 5.5
@export var block_animation_speed :float = 3
@export var idle_animation_speed :float = 1.2
@onready var asprite : AnimatedSprite2D = $Marker2D/Graphics/AnimatedSprite2D
@onready var ap :AnimationPlayer = $Marker2D/Graphics/AnimationPlayer


func get_movement() -> Vector2:
	var input: Vector2 = Vector2()
	if Input.is_action_pressed('back'):
		input.y += 1
	if Input.is_action_pressed('forward'):
		input.y -= 1
	if Input.is_action_pressed('right'):
		input.x += 1
	if Input.is_action_pressed('left'):
		input.x -= 1
	return input

func _physics_process(delta:float) -> void:
	var direction: Vector2 = get_movement()
	
	if direction.x == 0 and direction.y == 0 and (ap.current_animation != "Punch" or ap.current_animation != "Block"):
		asprite.visible = false
	elif (ap.current_animation != "Punch" or ap.current_animation != "Block"):
		asprite.visible = true
		
		
	if Input.is_action_just_pressed("punch"):
		if ap.current_animation == "Punch":
			return
		ap.stop()
		ap.play("Punch",-1,punch_animation_speed,false)
		
	if Input.is_action_just_pressed("block"):
		if ap.current_animation == "Block":
			return
		ap.stop()
		ap.play("Block",-1,block_animation_speed,false)
	
	if direction.length() > 0:
		velocity = velocity.lerp(direction.normalized() * speed, acceleration)
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)
		
	print(ap.current_animation)
	move_and_slide()
	
