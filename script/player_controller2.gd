class_name Player
extends CharacterBody2D

@export var stats : PlayerStats
@export var player_actions : PlayerActions
@export var sprite : AnimatedSprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = stats.jump_velocity
