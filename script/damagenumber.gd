extends Node

# Preload font resource di sini
const DAMAGE_FONT: Font = preload("res://assets/fibberish.ttf")
# Ganti "res://path/to/your_custom_font.tres" dengan jalur sebenarnya ke resource font Anda.
# Jika Anda mengimpor file .ttf/.otf dan Godot mengkonversinya, Anda bisa preload file .ttf/.otf tersebut.
# Contoh: const DAMAGE_FONT: Font = preload("res://fonts/MyFont.ttf")

func display_number(value: int, position: Vector2, is_critical: bool = false, is_health_gain: bool = false):
	var number = Label.new()
	number.global_position = position
	# Tambahkan tanda '+' di depan jika ini penambahan health
	number.text = ("+" if is_health_gain and value > 0 else "") + str(value)
	number.z_index = 5
	number.label_settings = LabelSettings.new()

	# Atur custom font di sini
	if DAMAGE_FONT: # Pastikan font berhasil di-preload
		number.label_settings.font = DAMAGE_FONT
	else:
		push_error("Failed to load damage font! Using default font.")

	var color = "#FFF"
	var base_font_size = 30
	var outline_color = "#000000"
	var outline_size = 1

	if is_critical:
		color = "#FFD700" # Emas untuk critical damage
		outline_color = "#8B0000" # Merah tua untuk outline critical
		outline_size = 2
		base_font_size = 50
	elif is_health_gain:
		color = "#00FF00" # Hijau terang untuk health gain
		outline_color = "#006400" # Hijau tua untuk outline health gain
		outline_size = 2
		base_font_size = 40 # Sedikit lebih besar dari damage biasa
	elif value == 0:
		color = "#FFFFFF88" # Transparan untuk 0 damage
	else:
		color = "#FFF" # Putih untuk damage biasa
		outline_color = "#000000"
		outline_size = 1

	number.label_settings.font_color = Color(color)
	number.label_settings.outline_color = Color(outline_color)
	number.label_settings.outline_size = outline_size
	number.label_settings.font_size = base_font_size

	number.label_settings.shadow_size = 4
	number.label_settings.shadow_color = Color(0, 0, 0, 0.5)

	call_deferred("add_child", number)

	await number.resized
	number.pivot_offset = Vector2(number.size / 2)
	number.position -= number.size / 2

	var tween = get_tree().create_tween()
	tween.set_parallel(true)

	var initial_rotation_degrees = randf_range(-10, 10)
	number.rotation_degrees = initial_rotation_degrees

	var start_position = number.position

	var random_x_movement = randf_range(-20, 20)
	var random_y_movement = randf_range(-40, 40)
	var end_position = start_position + Vector2(random_x_movement, random_y_movement)

	# Animasi posisi
	tween.tween_property(
		number, "position", end_position, 0.5
	).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

	# Animasi fade out
	tween.tween_property(
		number, "modulate:a", 0.0, 0.5
	).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE).set_delay(0.2)

	# Animasi scale (pop dan kemudian kembali ke ukuran normal)
	var pop_scale_factor = 1.4
	if is_critical:
		pop_scale_factor = 1.8
	elif is_health_gain: # Pop sedikit lebih besar untuk health gain
		pop_scale_factor = 1.6

	tween.tween_property(
		number, "scale", Vector2.ONE * pop_scale_factor, 0.1
	).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)

	tween.tween_property(
		number, "scale", Vector2.ONE, 0.1
	).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE).set_delay(0.1)

	# Animasi rotasi
	var target_rotation_degrees = initial_rotation_degrees + randf_range(-15, 15)
	tween.tween_property(
		number, "rotation_degrees", target_rotation_degrees, 0.75
	).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

	await tween.finished
	number.queue_free()
