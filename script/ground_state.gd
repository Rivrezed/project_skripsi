class_name GroundState
extends CharacterState

@export var can_move : bool = true
@export var can_jump : bool = true
@export var jump_anim : StringName = "jump"
@export var movement_speed_var : StringName = "run_speed"
@export var dash_speed = 750.0
@export var dash_max_distance = 100.0
@export var dash_curve : Curve
@export var dash_cooldown = 0.5
@export var dash_animation : StringName = "dash"
@export var animated_sprite: AnimatedSprite2D

# --- New Audio Variables ---
@export var dash_sound_player: AudioStreamPlayer2D # Reference to your AudioStreamPlayer2D node
@export var dash_sound_effect: AudioStream # The actual sound file (e.g., a .wav or .ogg)

var is_dashing = false
var dash_start_position = 0.0
var dash_direction = 0.0
var dash_timer = 0.0
var _on_first_frame = true

func _update(p_delta: float) -> void:
	if not is_dashing:
		if can_move:
			_apply_gravity(p_delta)
			move()
		if character.is_on_floor():
			if can_jump && blackboard.get_var(BBNames.jump_var) and blackboard.get_var(BBNames.jumps_made_var) == 0:
				jump()
		elif not _on_first_frame:
			dispatch("in_air")
		
		if Input.is_action_just_pressed("dash") and not is_dashing and dash_timer <= 0:
			var direction_x = blackboard.get_var(BBNames.direction_var).x
			if direction_x != 0:
				start_dash(direction_x)
	else:
		perform_dash(p_delta)

	if dash_timer > 0:
		dash_timer -= p_delta

	_on_first_frame = false

func move() -> Vector2:
	var direction : Vector2 = blackboard.get_var(BBNames.direction_var)
	var move_speed :float = character.stats.get(movement_speed_var)
	
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

func start_dash(direction: float):
	is_dashing = true
	dash_start_position = character.position.x
	dash_direction = direction
	dash_timer = dash_cooldown
	play_dash_animation()
	play_dash_sound() # Trigger the sound here

func play_dash_animation():
	if animated_sprite and dash_animation != &"" and animated_sprite.animation != dash_animation:
		animated_sprite.play(dash_animation)

func play_dash_sound():
	if dash_sound_player and dash_sound_effect:
		dash_sound_player.stream = dash_sound_effect
		dash_sound_player.play()

func perform_dash(_delta: float):
	var current_distance = abs(character.position.x - dash_start_position)
	if current_distance >= dash_max_distance or character.is_on_wall():
		is_dashing = false
		character.velocity.x = 0
	else:
		var curve_value = dash_curve.sample(current_distance / dash_max_distance) if dash_curve else 1.0
		character.velocity.x = dash_direction * dash_speed * curve_value
		_apply_gravity(_delta)
	character.move_and_slide()
