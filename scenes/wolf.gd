extends CharacterBody2D

@export var stats : CharacterStats
@onready var player = get_parent().find_child("Player2")
@onready var animated_sprite = $AnimatedSprite2D

var direction: Vector2
var gravity: float = 500.0  # Nilai gravitasi (bisa disesuaikan)
var speed: float = 200.0

@onready var animation_player = $AnimationPlayer

signal player_died_event

func _on_health_health_depleted() -> void:
	player_died_event.emit()
	animation_player.play("death")
	queue_free()
	## Mulai animasi kematian
	#animation_player.play("death")
#
	## Menunggu animasi selesai, lalu menjalankan _on_death_animation_finished sekali
	#animation_player.animation_finished.connect(_on_death_animation_finished, CONNECT_ONE_SHOT)
#
	## Matikan physics dan logic proses
	#set_physics_process(false)
	#set_process(false)
#
#func _on_death_animation_finished(_anim_name: String) -> void:
	#if _anim_name == "death":
		#queue_free()  # Hapus node ini sepenuhnya dari scene

		
func _ready():
	set_physics_process(false)

func _process(_delta):
	if is_instance_valid(player):
		direction = player.position - position

		animated_sprite.flip_h = direction.x < 0

func _physics_process(delta):
	velocity.y += gravity * delta

	if is_instance_valid(player):
		var horizontal_direction = player.position.x - position.x

		if abs(horizontal_direction) > 1:
			velocity.x = sign(horizontal_direction) * speed
		else:
			velocity.x = 0
	else:
		velocity.x = 0

	move_and_slide()
