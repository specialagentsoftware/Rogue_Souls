class_name zombie extends CharacterBody2D

@onready var player_detection: RayCast2D = $Marker2D/Graphics/PlayerDetection
@onready var player_attack_range: RayCast2D = $Marker2D/Graphics/PlayerAttackRange
@onready var animation_player: AnimationPlayer = $Marker2D/Graphics/AnimationPlayer
@onready var animated_sprite_2d: AnimatedSprite2D = $Marker2D/Graphics/AnimatedSprite2D
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var speed: int = 80

func _process(delta: float) -> void:
	if player_detection.is_colliding():
		animated_sprite_2d.visible = true
		velocity = position.direction_to(player.position) * speed
	else:
		animated_sprite_2d.visible = false
		velocity = Vector2.ZERO
	
	if player_attack_range.is_colliding():
		animation_player.play("Attack")
	elif (animation_player.current_animation != "Attack"):
		animation_player.play("Idle")
	
	move_and_slide()
