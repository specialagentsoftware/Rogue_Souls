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
@export var health: int = 100
@export var stamina: int = 100
@export var xp: int = 0
@export var lvl: int = 1
@onready var asprite : AnimatedSprite2D = $Marker2D/Graphics/AnimatedSprite2D
@onready var ap :AnimationPlayer = $Marker2D/Graphics/AnimationPlayer
@onready var current_state: states = states.Idling
@onready var dodge_timer: Timer = $Timers/Dodge_timer
@onready var particles : GPUParticles2D = $Marker2D/GPUParticles2D
@onready var dodge_cooldown_timer: Timer = $Timers/Dodge_cooldown
@onready var can_dodge: bool = true
@onready var health_bar: ProgressBar = $Camera2D/Health
@onready var stamina_bar: ProgressBar = $Camera2D/Stamina
@onready var experience_bar: ProgressBar = $Camera2D/Experience
@onready var lvl_bar: Label = $Camera2D/LVL

func _ready() -> void:
	stamina_bar.value = stamina
	health_bar.value = health
	experience_bar.value = xp
	lvl_bar.text = str(lvl)

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

func _physics_process(_delta:float) -> void:
	var direction: Vector2 = get_movement()
	
	if direction.x == 0 and direction.y == 0 and (ap.current_animation != "Punch" or ap.current_animation != "Block"):
		current_state = states.Idling
		asprite.visible = false
		#ap.play("Idle")
	elif (ap.current_animation != "Punch" or ap.current_animation != "Block"):
		asprite.visible = true
		asprite.play("walk")
		current_state = states.Walking
		
	if Input.is_action_just_pressed("punch") and stamina > 10:
		if ap.current_animation == "Punch":
			return
		ap.stop()
		ap.play("Punch",-1,punch_animation_speed,false)
		current_state = states.Attacking
		_take_stamina(10)
		
	if Input.is_action_just_pressed("block") and stamina > 10:
		if ap.current_animation == "Block":
			return
		ap.stop()
		ap.play("Block",-1,block_animation_speed,false)
		current_state = states.Blocking
		_take_stamina(10)
		
	if Input.is_action_just_pressed("dodge") and stamina >20:
		if (direction.x == 0 and direction.y == 0) or current_state == states.Dodging or can_dodge == false:
			return
		current_state = states.Dodging
		_take_stamina(20)
		dodge_speed()
		
	if Input.is_action_just_pressed("hurt"):
		_take_health(10)
	
	if Input.is_action_just_pressed("xp"):
		_give_xp(10)
		
	if direction.length() > 0:
		velocity = velocity.lerp(direction.normalized() * speed, acceleration)
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)
		
	move_and_slide()
	
func dodge_speed() -> void:
	ap.play("Dash")
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
	
func _take_stamina(cost:int) -> void:
	stamina -= clampi(cost,0,100)
	stamina_bar.value = stamina
	
func _take_health(cost:int) -> void:
	health -= clampi(cost,0,100)
	health_bar.value = health
	
	if health == 0:
		queue_free()

func _give_health(health_give:int)->void:
	health += clampi(health_give,0,100)
	health_bar.value = health

func _give_xp(xp_add:int)-> void:
	xp += clampi(xp_add,0,100)
	experience_bar.value = xp
	
func _level_up() -> void:
	lvl += 1
	lvl_bar.text = str(lvl)
	ap.play("flash_lvl")
	Globals.open_upgrade_menu()
	
func _process(_delta: float) -> void:
	if stamina < 20:
		ap.play("flash_stamina")
	if health < 20:
		ap.play("flash_health")
		
	stamina_bar.value = stamina
	health_bar.value = health
	experience_bar.value = xp
	lvl_bar.text = str(lvl)
	
	if experience_bar.value == 100:
		_level_up()
		xp = 0
	
func _on_stamina_regen_timer_timeout() -> void:
	stamina += clampi(5,0,100)


func _on_health_regen_timer_timeout() -> void:
	health += clampi(5,0,100)
