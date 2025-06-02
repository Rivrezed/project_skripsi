extends Label

@export var combo_timeout: float = 2.0 # Waktu tunggu sebelum combo reset

var total_combo_damage: int = 0
var combo_timer: Timer
var current_tween: Tween = null
var combo_active: bool = false

func _ready():
	text = ""
	hide()
	modulate.a = 1.0 # Langsung terlihat saat show() dipanggil
	scale = Vector2.ONE

	combo_timer = Timer.new()
	combo_timer.one_shot = true
	combo_timer.wait_time = combo_timeout
	add_child(combo_timer)
	combo_timer.timeout.connect(_on_combo_timeout)

func add_combo_damage(amount: int):
	if amount <= 0:
		return

	# Jika combo tidak aktif, mulai dari awal (reset damage)
	if not combo_active:
		total_combo_damage = 0
		combo_active = true

	total_combo_damage += amount
	text = "Total Damage\n" + str(total_combo_damage)
	show()

	# Restart timer setiap kali ada hit
	combo_timer.start()

	# Hentikan tween lama jika ada
	if current_tween != null and current_tween.is_valid():
		current_tween.kill()

	# Tween baru
	current_tween = create_tween()

	# Efek scale cepat dan smooth
	current_tween.tween_property(self, "scale", Vector2(1.025, 1.025), 0.01)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	current_tween.tween_property(self, "scale", Vector2.ONE, 0.05)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN).set_delay(0.01)

func _on_combo_timeout():
	# Hentikan tween lama
	if current_tween != null and current_tween.is_valid():
		current_tween.kill()

	# Tween untuk fade-out dan reset
	current_tween = create_tween()
	current_tween.tween_property(self, "modulate:a", 0.0, 0.2)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	current_tween.tween_callback(Callable(self, "_reset_combo")).set_delay(0.2)

func _reset_combo():
	total_combo_damage = 0
	text = ""
	hide()
	scale = Vector2.ONE
	combo_active = false
	modulate.a = 1.0 # Pastikan kembali terlihat saat muncul lagi
