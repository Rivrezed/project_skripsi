extends Camera2D

const MIN_ZOOM = Vector2(1.0, 1.0)
const MAX_ZOOM = Vector2(2.0, 2.0)
const ZOOM_STEP = 0.5
const ZOOM_SPEED = 15 # Semakin besar, semakin cepat transisinya

var target_zoom: Vector2

# --- Camera Shake Variables ---
var shake_strength: float = 0.0
var shake_duration: float = 0.0
var shake_timer: float = 0.0
var original_offset: Vector2 = Vector2.ZERO # Untuk menyimpan offset asli kamera

func _ready():
	target_zoom = zoom
	# Pastikan Camera2D ini masuk dalam grup "MainCamera" agar HurtBox bisa menemukannya
	if not is_in_group("MainCamera"):
		add_to_group("MainCamera")
	original_offset = offset # Simpan offset awal kamera

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			_zoom_out()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_zoom_in()

func _process(delta):
	# Interpolasi zoom
	zoom = zoom.lerp(target_zoom, delta * ZOOM_SPEED)

	# --- Camera Shake Logic ---
	if shake_timer > 0:
		shake_timer -= delta
		# Hitung offset getaran acak
		var random_offset = Vector2(randf_range(-shake_strength, shake_strength), randf_range(-shake_strength, shake_strength))
		
		# Gabungkan offset asli dengan offset getaran
		offset = original_offset + random_offset
		
		# Opsional: Kurangi kekuatan getaran seiring waktu untuk efek yang lebih halus
		# shake_strength = lerp(shake_strength, 0, delta * 5) 

		if shake_timer <= 0:
			offset = original_offset # Reset offset ke nilai asli setelah getaran selesai
			shake_strength = 0.0 # Reset kekuatan getaran
	else:
		# Pastikan offset kembali ke nilai asli jika tidak ada getaran yang aktif
		# Ini penting jika Anda tidak menggunakan lerp untuk shake_strength
		offset = original_offset 

func _zoom_in():
	target_zoom -= Vector2(ZOOM_STEP, ZOOM_STEP)
	target_zoom.x = clamp(target_zoom.x, MIN_ZOOM.x, MAX_ZOOM.x)
	target_zoom.y = clamp(target_zoom.y, MIN_ZOOM.y, MAX_ZOOM.y)

func _zoom_out():
	target_zoom += Vector2(ZOOM_STEP, ZOOM_STEP)
	target_zoom.x = clamp(target_zoom.x, MIN_ZOOM.x, MAX_ZOOM.x)
	target_zoom.y = clamp(target_zoom.y, MIN_ZOOM.y, MAX_ZOOM.y)

# --- Public function to initiate camera shake ---
func shake(strength: float, duration: float):
	shake_strength = strength
	shake_duration = duration
	shake_timer = duration
	# original_offset sudah disimpan di _ready, jadi tidak perlu di sini lagi
