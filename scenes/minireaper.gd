extends CharacterBody2D

@onready var player = get_parent().find_child("Player2")
@export var stats : CharacterStats
@export var speed: float = 200

@onready var animated_sprite = $AnimatedSprite2D
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



var direction : Vector2

func _ready():
	set_physics_process(false)

func _process(_delta):
	if is_instance_valid(player):
		direction = player.position - position
		animated_sprite.flip_h = direction.x < 0
	else:
		set_physics_process(false)

func _physics_process(delta):
	if is_instance_valid(player):
		velocity = direction.normalized() * speed
		move_and_collide(velocity * delta)
	else:
		velocity = Vector2.ZERO
