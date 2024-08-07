extends CharacterBody2D

enum states {Attacking, Walking, Idling, Blocking, Dodging}
@export var speed :int = 200
@export var friction :float = 0.50
@export var acceleration :float = 0.1
@export var walk_animation_speed :float = 2
@export var punch_animation_speed :float = 5.5
@export var block_animation_speed :float = 3
@export var idle_animation_speed :float = 1.2
@export var dodge_animation_speed :float = 50
@onready var asprite : AnimatedSprite2D = $Marker2D/Graphics/AnimatedSprite2D
@onready var ap :AnimationPlayer = $Marker2D/Graphics/AnimationPlayer
@onready var current_state = states.Idling
@onready var dodge_timer: Timer = $Timers/Dodge_timer
@export var ghost: PackedScene
@onready var particles : GPUParticles2D = $Marker2D/GPUParticles2D
@onready var dodge_cooldown_timer = $Timers/Dodge_cooldown
@onready var can_dodge: bool = true

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
		current_state = states.Idling
		asprite.visible = false
		#ap.play("Idle")
	elif (ap.current_animation != "Punch" or ap.current_animation != "Block"):
		asprite.visible = true
		asprite.play("walk")
		current_state = states.Walking
		
	if Input.is_action_just_pressed("punch"):
		if ap.current_animation == "Punch":
			return
		ap.stop()
		ap.play("Punch",-1,punch_animation_speed,false)
		current_state = states.Attacking
		
	if Input.is_action_just_pressed("block"):
		if ap.current_animation == "Block":
			return
		ap.stop()
		ap.play("Block",-1,block_animation_speed,false)
		current_state = states.Blocking
		
	if Input.is_action_just_pressed("dodge"):
		if (direction.x == 0 and direction.y == 0) or current_state == states.Dodging or can_dodge == false:
			return
		current_state = states.Dodging
		dodge_speed()
		
		
	
	if direction.length() > 0:
		velocity = velocity.lerp(direction.normalized() * speed, acceleration)
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)
		
	move_and_slide()
	
func dodge_speed() -> void:
	speed = 650
	particles.emitting = true
	asprite.speed_scale = 3
	can_dodge = false
	dodge_timer.start()

func _on_dodge_timer_timeout() -> void:
	speed = 200
	asprite.speed_scale = 1
	particles.emitting = false
	dodge_cooldown_timer.start()

func _on_area_2d_area_entered(area: Area2D) -> void:
	print(area)


func _on_dodge_cooldown_timeout() -> void:
	can_dodge = true
