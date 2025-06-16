class_name GroundState
extends CharacterState

@export var can_move : bool = true
@export var can_jump : bool = true
@export var jump_anim : StringName = "jump"
@export var movement_speed_var : StringName = "run_speed"
@export var animated_sprite: AnimatedSprite2D
@export var dash_sfx: AudioStreamPlayer2D  # SFX Dash
@export var dash_speed_ground : float = 1250.0
@export var dash_duration_ground : float = 0.1
@export var dash_cooldown_ground : float = 1.0  # Cooldown dash dalam detik

var _on_first_frame = true
var _dash_timer_ground : float = 0.0
var _dash_cooldown_timer_ground : float = 0.0
var _is_dashing_ground : bool = false

func _update(p_delta: float) -> void:
	# Update cooldown timer
	if _dash_cooldown_timer_ground > 0:
		_dash_cooldown_timer_ground -= p_delta

	# Dash hanya jika di tanah
	if Input.is_action_just_pressed("dash") and not _is_dashing_ground and _dash_cooldown_timer_ground <= 0.0 and character.is_on_floor():
		dash()

	if can_move:
		_apply_gravity(p_delta)
		move()

	if character.is_on_floor():
		if can_jump and blackboard.get_var(BBNames.jump_var) and blackboard.get_var(BBNames.jumps_made_var) == 0:
			jump()
	elif not _on_first_frame:
		dispatch("in_air")

	_on_first_frame = false

	if _is_dashing_ground:
		# Hentikan dash jika tidak lagi di tanah
		if not character.is_on_floor():
			_is_dashing_ground = false
			animated_sprite.play("")  # Reset animasi
			_dash_cooldown_timer_ground = dash_cooldown_ground
			character.velocity.x = 0
		else:
			_dash_timer_ground -= p_delta
			if _dash_timer_ground <= 0:
				_is_dashing_ground = false
				animated_sprite.play("")  # Reset animasi
				_dash_cooldown_timer_ground = dash_cooldown_ground

				# Cegah bug meluncur jauh saat tidak ada input gerak
				if not Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right"):
					character.velocity.x = 0

func move() -> Vector2:
	var direction : Vector2 = blackboard.get_var(BBNames.direction_var)
	var move_speed : float = character.stats.get(movement_speed_var)

	if _is_dashing_ground:
		character.velocity.x = direction.x * dash_speed_ground
	else:
		if not is_zero_approx(direction.x):
			character.velocity.x = direction.x * move_speed
		else:
			character.velocity.x = move_toward(character.velocity.x, 0, move_speed)

	character.move_and_slide()
	return character.velocity

func jump():
	if not blackboard.get_var(BBNames.jump_var):
		return

	var max_jumps : int = character.stats.max_jumps
	var current_jumps : int = blackboard.get_var(BBNames.jumps_made_var)

	if current_jumps < max_jumps:
		character.velocity.y = -character.stats.jump_velocity
		blackboard.set_var(BBNames.jumps_made_var, current_jumps + 1)
		dispatch("jump")
		blackboard.set_var(BBNames.jump_var, false)

func dash():
	_is_dashing_ground = true
	_dash_timer_ground = dash_duration_ground
	animated_sprite.play("dash")
	dispatch("dash")

	# Mainkan SFX hanya jika belum diputar
	if dash_sfx and not dash_sfx.playing:
		dash_sfx.play()
