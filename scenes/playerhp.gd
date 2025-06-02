# HealthBarUI.gd
extends Control
@onready var progress_bar: ProgressBar = $ProgressBar
@export var health_component: Node # Menggunakan export var untuk komponen Health

func _ready():
	# Pastikan kita memiliki ProgressBar dan HealthComponent yang terhubung
	if progress_bar == null:
		print("Error: ProgressBar not assigned to HealthBarUI. Please assign it in the editor.")
		return

	if health_component != null:
		connect_health_component()
		# Inisialisasi awal nilai healthbar
		_on_max_health_changed(0) # Panggil untuk mengatur max_value
		_on_health_changed(0)     # Panggil untuk mengatur value
	else:
		print("Warning: Health component not assigned to HealthBarUI. Please assign it in the editor.")

func set_health_component(health_comp: Health):
	if health_component != null:
		disconnect_health_component() # Disconnect jika sudah terhubung sebelumnya

	health_component = health_comp
	if health_component != null:
		connect_health_component()
		# Inisialisasi awal nilai healthbar
		_on_max_health_changed(0) # Panggil untuk mengatur max_value
		_on_health_changed(0)     # Panggil untuk mengatur value

func connect_health_component():
	if health_component != null:
		health_component.max_health_changed.connect(_on_max_health_changed)
		health_component.health_changed.connect(_on_health_changed)
	else:
		print("Error: Attempting to connect null health_component.")

func disconnect_health_component():
	if health_component != null && health_component.max_health_changed.is_connected(_on_max_health_changed):
		health_component.max_health_changed.disconnect(_on_max_health_changed)
	if health_component != null && health_component.health_changed.is_connected(_on_health_changed):
		health_component.health_changed.disconnect(_on_health_changed)

func _on_max_health_changed(_diff: int):
	if health_component != null:
		# PERBAIKAN: Gunakan get_max_health()
		progress_bar.max_value = health_component.get_max_health()
		# Pastikan health bar terupdate jika max health berubah
		_on_health_changed(0)

func _on_health_changed(_diff: int):
	if health_component != null:
		# PERBAIKAN: Gunakan get_health()
		progress_bar.value = health_component.get_health()
