class_name Facing
extends Node2D

## Updates the node's scale to face left (-1 scale.x) or right (+1 scale.x)

@export var character : CharacterBody2D

func _physics_process(_delta: float) -> void:
	if character.velocity.x > 0:
		scale.x = 1.0
	elif character.velocity.x < 0:
		scale.x = -1.0
