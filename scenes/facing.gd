class_name Facing
extends Node2D

## Updates the node's scale to face left (-1 scale.x) or right (+1 scale.x)

@export var direction: Vector2  # Ini bisa diatur oleh AI

func _physics_process(_delta: float) -> void:
	if direction.x > 0:
		scale.x = 1.0
	elif direction.x < 0:
		scale.x = -1.0
