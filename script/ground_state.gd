extends CharacterState

@export var idle_anim : StringName = "idle"
@export var move_anim : StringName = "run"

var _on_first_frame = true

func _enter() -> void:
	super()
	_on_first_frame = true
	blackboard.set_var(BBNames.jumps_made_var, 0)

func _update(delta: float) -> void:
	_apply_gravity(delta)
	var velocity : Vector2 = move()

	if Vector2.ZERO.is_equal_approx(velocity):
		character.sprite.play(idle_anim)
	else:
		character.sprite.play(move_anim)

	# Cek lompat
	if blackboard.get_var(BBNames.jump_var) and blackboard.get_var(BBNames.jumps_made_var) == 0:
		jump()

	# Pindah ke state in_air kalau sudah tidak di lantai
	if not character.is_on_floor() and not _on_first_frame:
		dispatch("in_air")

	_on_first_frame = false

func jump():
	character.velocity.y = -character_stats.jump_velocity
	var current_jump : int = blackboard.get_var(BBNames.jumps_made_var)
	blackboard.set_var(BBNames.jumps_made_var, current_jump + 1)
	blackboard.set_var(BBNames.jump_var, false) # Reset trigger jump

# ground movement
func move() -> Vector2:
	var direction : Vector2 = blackboard.get_var(BBNames.direction_var)

	if not is_zero_approx(direction.x):
		character.velocity.x = direction.x * character_stats.run_speed
	else:
		character.velocity.x = move_toward(character.velocity.x, 0, character_stats.run_speed)

	character.move_and_slide()
	return character.velocity
