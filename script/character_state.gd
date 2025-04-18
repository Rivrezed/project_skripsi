class_name CharacterState
extends LimboState

@export var animation_name : StringName

var character : CharacterBody2D
var character_stats : CharacterStats

func _enter() -> void:
	character = owner as CharacterBody2D
	var sprite = owner.get("sprite") as AnimatedSprite2D
	if sprite:
		sprite.play(animation_name)
	else:
		print("Gagal memainkan animasi karena sprite tidak ditemukan.")
	character_stats = character.stats


func _apply_gravity(delta: float) -> void:
	if not character.is_on_floor():
		character.velocity.y += character_stats.gravity * delta
