#air_state.gd
class_name AirState
extends CharacterState

@export var can_move : bool = true

# --- Variabel Dash Baru (Salin dari GroundState) ---
@export var dash_speed = 750.0
@export var dash_max_distance = 100.0
@export var dash_curve : Curve # Anda perlu membuat Resource Curve baru di Godot
@export var dash_cooldown = 0.5
@export var dash_animation : StringName = "dash"
@export var animated_sprite: AnimatedSprite2D # Pastikan ini juga ada di AirState

# --- Variabel Audio Baru ---
@export var dash_sound_player: AudioStreamPlayer2D # Reference to your AudioStreamPlayer2D node
@export var dash_sound_effect: AudioStream # The actual sound file (e.g., a .wav or .ogg)

var is_dashing = false
var dash_start_position = 0.0
var dash_direction = 0.0
var dash_timer = 0.0
# --- Akhir Variabel Dash Baru ---

func _update(_delta: float) -> void:
	if not is_dashing: # Hanya bisa melakukan aksi lain jika tidak sedang dash
		if can_move:
			air_move()
			_apply_gravity(_delta)
		
		if character.is_on_floor():
			dispatch("on_ground")
		
		# Panggil fungsi dash di sini
		if Input.is_action_just_pressed("dash") and not is_dashing and dash_timer <= 0:
			var direction_x = blackboard.get_var(BBNames.direction_var).x
			if direction_x != 0: # Hanya bisa dash jika ada arah horizontal
				start_dash(direction_x)
	else:
		perform_dash(_delta) # Lanjutkan dash jika sedang aktif
		
	# Mengurangi timer dash (berjalan terlepas dari apakah sedang dash atau tidak)
	if dash_timer > 0:
		dash_timer -= _delta

func air_move() -> Vector2:
	var direction : Vector2 = blackboard.get_var(BBNames.direction_var)

	#move right
	if direction.x > 0:
		var attempted_velocity_x = min(character.stats.max_air_speed, character.velocity.x + character.stats.air_acceleration)
		character.velocity.x = max(character.velocity.x, attempted_velocity_x)
	elif direction.x < 0:
		var attempted_velocity_x = max(-1 * character.stats.max_air_speed, character.velocity.x - character.stats.air_acceleration)
		character.velocity.x = min(character.velocity.x, attempted_velocity_x)

	character.move_and_slide()
	return character.velocity

# --- Fungsi Dash Baru (Salin dari GroundState) ---
func start_dash(direction: float):
	is_dashing = true
	dash_start_position = character.position.x
	dash_direction = direction
	dash_timer = dash_cooldown
	play_dash_animation()
	play_dash_sound() # Panggil fungsi play_dash_sound di sini

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
		character.velocity.x = 0 # Hentikan kecepatan horizontal setelah dash selesai
		# Optional: Stop dash animation or transition to air idle/fall animation
	else:
		var curve_value = dash_curve.sample(current_distance / dash_max_distance) if dash_curve else 1.0
		character.velocity.x = dash_direction * dash_speed * curve_value
		_apply_gravity(_delta) # Continue to apply gravity
	character.move_and_slide()
# --- Akhir Fungsi Dash Baru ---
