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

func move() -> Vector2:
	var direction : Vector2 = blackboard.get_var(BBNames.direction_var)

	if not is_zero_approx(direction.x):
		character.velocity.x = direction.x * character_stats.run_speed
	else:
		character.velocity.x = move_toward(character.velocity.x, 0, character_stats.run_speed)

	character.move_and_slide()
	return character.velocity
