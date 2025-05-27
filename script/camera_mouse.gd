extends Camera2D

@export var max_offset_x: float = 100.0 # Batasan pergerakan horizontal dari posisi awal kamera
@export var max_offset_y: float = 50.0  # Batasan pergerakan vertikal dari posisi awal kamera
@export var follow_speed: float = 5.0   # Kecepatan kamera mengikuti mouse (interpolasi)

var initial_camera_position: Vector2

func _ready():
	# Simpan posisi awal kamera saat scene dimuat
	initial_camera_position = position
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
	var target_offset_x = normalized_mouse_x * max_offset_x
	var target_offset_y = normalized_mouse_y * max_offset_y

	# Hitung posisi target kamera baru
	var target_camera_position = initial_camera_position + Vector2(target_offset_x, target_offset_y)

	# Interpolasi posisi kamera saat ini menuju posisi target
	# Ini menciptakan gerakan yang halus
	position = position.lerp(target_camera_position, follow_speed * delta)
