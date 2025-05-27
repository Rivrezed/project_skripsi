extends Node

func display_number(value: int, position: Vector2, is_critical: bool = false):
	var number = Label.new()
	number.global_position = position # Ini adalah titik awal munculnya angka

	number.text = str(value)
	number.z_index = 5
	number.label_settings = LabelSettings.new()

	# Warna
	var color = "#FFF" # Default putih
	if is_critical:
		color = "#FFD700" # Emas untuk critical (lebih mencolok)
		number.label_settings.outline_color = "#8B0000" # Outline merah gelap untuk critical
		number.label_settings.outline_size = 2 # Outline lebih tebal
	elif value == 0:
		color = "#FFFFFF88" # Semi-transparan putih untuk nol
	else:
		number.label_settings.outline_color = "#000000" # Outline hitam standar
		number.label_settings.outline_size = 1

	number.label_settings.font_color = Color(color)
	number.label_settings.font_size = 30

	# Shadow untuk tampilan yang lebih dalam
	number.label_settings.shadow_size = 4
	number.label_settings.shadow_color = Color(0, 0, 0, 0.5)

	call_deferred("add_child", number)

	await number.resized
	# Posisikan ulang agar pivot di tengah, tetapi tetap berada di global_position awal
	number.pivot_offset = Vector2(number.size / 2)
	number.position -= number.size / 2 # Kritis untuk memastikan start_position benar

	var tween = get_tree().create_tween()
	tween.set_parallel(true) # Animasi berjalan bersamaan

	# Rotasi Awal Acak (rentang halus)
	var initial_rotation_degrees = randf_range(-10, 10)
	number.rotation_degrees = initial_rotation_degrees

	# Ambil posisi awal number setelah pivot_offset dan penyesuaian posisi
	var start_position = number.position

	# Target Posisi Acak (Rentang diperkecil!)
	var random_x_movement = randf_range(-20, 20) # Sebelumnya -40, 40
	var random_y_movement = randf_range(-40, 40) # Sebelumnya -70, 70
	var end_position = start_position + Vector2(random_x_movement, random_y_movement)

	# Animasi utama: Bergerak acak, lalu memudar dan mengecil
	# 1. Bergerak ke posisi acak
	tween.tween_property(
		number, "position", end_position, 0.5 # Durasi gerakan
	).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

	# 2. Memudar
	tween.tween_property(
		number, "modulate:a", 0.0, 0.5
	).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE).set_delay(0.2)

	# 3. Mengecil (scaling)
	tween.tween_property(
		number, "scale", Vector2.ZERO, 0.5
	).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK).set_delay(0.2)

	# Animasi tambahan untuk efek "pop" di awal
	# Sedikit membesar di awal
	tween.tween_property(
		number, "scale", Vector2.ONE * 1.4, 0.1 # Ukuran pop yang lebih besar
	).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)

	# Kembali ke ukuran normal sedikit lebih cepat
	tween.tween_property(
		number, "scale", Vector2.ONE, 0.1
	).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE).set_delay(0.1)

	# Animasi Rotasi (rentang halus)
	var target_rotation_degrees = initial_rotation_degrees + randf_range(-15, 15)
	tween.tween_property(
		number, "rotation_degrees", target_rotation_degrees, 0.75
	).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

	await tween.finished
	number.queue_free()
