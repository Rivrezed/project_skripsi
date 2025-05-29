extends CharacterBody2D

@onready var player = get_parent().find_child("Player2")
@export var stats : CharacterStats
@export var speed: float = 200

@onready var animated_sprite = $AnimatedSprite2D
@onready var progress_bar = $UI/ProgressBar
@onready var animation_player = $AnimationPlayer

signal player_died_event

func _on_health_health_depleted() -> void:
	player_died_event.emit()
	animation_player.play("death")
	animation_player.animation_finished.connect(Callable(self, "_on_death_animation_finished"), CONNECT_ONE_SHOT)
	set_physics_process(false)
	set_process(false)

func _on_death_animation_finished(anim_name: String) -> void:
	if anim_name == "death":
		queue_free()


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
