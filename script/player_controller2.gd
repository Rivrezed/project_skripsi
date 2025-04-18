class_name Player
extends CharacterBody2D

@export var stats : PlayerStats
@export var player_actions : PlayerActions
@export var sprite : AnimatedSprite2D


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
