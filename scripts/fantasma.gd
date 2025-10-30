extends CharacterBody2D

var SPEED = 50.0
const JUMP_VELOCITY = -600.0
var life = 2

@onready var wall_detector: RayCast2D = $Wall_detector
@onready var texture: AnimatedSprite2D = $AnimatedSprite2D
@onready var morte: AudioStreamPlayer = $morte
@onready var colisao: CollisionShape2D = $colisao
@onready var colisao_2: CollisionShape2D = $colisao2
@onready var hitbox: Area2D = $Hitbox




var direction := -1

func _physics_process(_delta: float) -> void:
	# Detecta colisão com parede e inverte direção
	if wall_detector.is_colliding():
		direction *= -1
		wall_detector.scale.x *= -1
		
	# Atualiza direção do sprite
	if direction == 1:
		texture.flip_h = true
	else:
		texture.flip_h = false

	# Movimento horizontal simples
	velocity.x = direction * SPEED
	velocity.y = 0.0

	move_and_slide()

func _on_animated_sprite_2d_animation_finished(anim_name: String) -> void:
	if anim_name == "dano":
		if life == 1:
			morte.play()
			queue_free()
