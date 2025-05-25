class_name GroundState
extends CharacterState
## Controls what the character can do on the character.
## actions like attacks, jumps, etc

@export var can_move : bool = true
@export var can_jump : bool = true
@export var jump_anim : StringName = "jump" # This variable is still here but not used for playing in this script
@export var movement_speed_var : StringName = "run_speed"

# --- Variabel Dash Baru ---
@export var dash_speed = 750.0
@export var dash_max_distance = 100.0
@export var dash_curve : Curve # Anda perlu membuat Resource Curve baru di Godot
@export var dash_cooldown = 0.5
@export var dash_animation : StringName = "dash" # New export variable for dash animation

# --- Tambahkan ini untuk referensi AnimatedSprite2D ---
@export var animated_sprite: AnimatedSprite2D 

var is_dashing = false
var dash_start_position = 0.0
var dash_direction = 0.0
var dash_timer = 0.0
# --- Akhir Variabel Dash Baru ---

var _on_first_frame = true

func _update(p_delta: float) -> void:
	if not is_dashing: # Hanya bisa melakukan aksi lain jika tidak sedang dash
		if can_move:
			_apply_gravity(p_delta)
			move()
		if character.is_on_floor():
			if can_jump && blackboard.get_var(BBNames.jump_var) and blackboard.get_var(BBNames.jumps_made_var) == 0:
				jump()
		elif not _on_first_frame:
			dispatch("in_air")
		
		# Panggil fungsi dash di sini
		if Input.is_action_just_pressed("dash") and not is_dashing and dash_timer <= 0:
			var direction_x = blackboard.get_var(BBNames.direction_var).x
			if direction_x != 0: # Hanya bisa dash jika ada arah horizontal
				start_dash(direction_x)
	else:
		perform_dash(p_delta) # Lanjutkan dash jika sedang aktif

	# Mengurangi timer dash (berjalan terlepas dari apakah sedang dash atau tidak)
	if dash_timer > 0:
		dash_timer -= p_delta

	_on_first_frame = false


## Movement for running on the ground when free to do so
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
		return # Prevent jumping if the jump input is not active

	var max_jumps : int = character.stats.max_jumps
	var current_jumps : int = blackboard.get_var(BBNames.jumps_made_var)

	if current_jumps < max_jumps:
		character.velocity.y = -character.stats.jump_velocity
		blackboard.set_var(BBNames.jumps_made_var, current_jumps + 1)
		
		# --- Perubahan di sini: Kode untuk memutar animasi jump sudah dihapus ---
		# if animated_sprite and jump_anim != &"" and animated_sprite.animation != jump_anim:
		# 	animated_sprite.play(jump_anim)
		# ----------------------------------------------------------------------
		
		dispatch("jump")
		blackboard.set_var(BBNames.jump_var, false) # Reset the jump input flag

# --- Fungsi Dash Baru ---
func start_dash(direction: float):
	is_dashing = true
	dash_start_position = character.position.x
	dash_direction = direction
	dash_timer = dash_cooldown
	# Panggil fungsi play_dash_animation
	play_dash_animation()

func play_dash_animation():
	# Play dash animation if specified and not already playing
	if animated_sprite and dash_animation != &"" and animated_sprite.animation != dash_animation:
		animated_sprite.play(dash_animation)

func perform_dash(_delta: float):
	var current_distance = abs(character.position.x - dash_start_position)
	if current_distance >= dash_max_distance or character.is_on_wall():
		is_dashing = false
		character.velocity.x = 0 # Hentikan kecepatan horizontal setelah dash selesai
		# Optional: Stop dash animation or transition to idle/run animation
		# animated_sprite.stop() or animated_sprite.play("idle")
	else:
		var curve_value = dash_curve.sample(current_distance / dash_max_distance) if dash_curve else 1.0
		character.velocity.x = dash_direction * dash_speed * curve_value
		_apply_gravity(_delta) # Continue to apply gravity
	character.move_and_slide()
# --- Akhir Fungsi Dash Baru ---
