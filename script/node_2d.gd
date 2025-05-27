extends Node2D

@export var max_offset_x: float = 1 # Batasan pergerakan horizontal dari posisi awal Node2D
@export var max_offset_y: float = 1  # Batasan pergerakan vertikal dari posisi awal Node2D
@export var follow_speed: float = 1   # Kecepatan Node2D mengikuti mouse (interpolasi)

var initial_node_position: Vector2

func _ready():
	# Simpan posisi awal Node2D saat scene dimuat
	initial_node_position = position
	# Pastikan kursor terlihat di menu
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _process(delta: float):
	# Dapatkan posisi mouse di viewport
	var mouse_position = get_viewport().get_mouse_position()
	var viewport_size = get_viewport_rect().size

	# Normalisasi posisi mouse dari -1 hingga 1 (pusat = 0)
	# Ini membantu menghitung offset yang seragam
	var normalized_mouse_x = (mouse_position.x / viewport_size.x) * 2.0 - 1.0
	var normalized_mouse_y = (mouse_position.y / viewport_size.y) * 2.0 - 1.0

	# Hitung target offset berdasarkan posisi mouse dan batasan
	# Perhatikan bahwa kita mengalikan dengan -1.0.
	# Ini karena kita ingin background bergerak berlawanan arah dengan mouse
	# untuk menciptakan ilusi "kamera" bergerak.
	var target_offset_x = normalized_mouse_x * max_offset_x * -1.0
	var target_offset_y = normalized_mouse_y * max_offset_y * -1.0

	# Hitung posisi target Node2D baru
	var target_node_position = initial_node_position + Vector2(target_offset_x, target_offset_y)

	# Interpolasi posisi Node2D saat ini menuju posisi target
	# Ini menciptakan gerakan yang halus
	position = position.lerp(target_node_position, follow_speed * delta)


func _on_exit_pressed() -> void:
	pass # Replace with function body.
