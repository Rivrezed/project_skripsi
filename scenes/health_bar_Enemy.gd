# HealthBarUI.gd
extends Control
@onready var progress_bar: ProgressBar = $ProgressBar
@export var health_component: Health # Menggunakan export var untuk komponen Health

func _ready():
	# Pastikan kita memiliki ProgressBar yang terhubung
	if progress_bar == null:
		print("Error: ProgressBar not assigned to HealthBarUI. Please assign it in the editor.")
		return

	if health_component != null:
		connect_health_component()
		# Inisialisasi awal nilai healthbar setelah koneksi
		# Panggil _on_max_health_changed() dan _on_health_changed()
		# untuk memastikan nilai-nilai awal ditampilkan dengan benar.
		# Menggunakan getter untuk mendapatkan nilai yang benar.
		progress_bar.max_value = health_component.get_max_health()
		progress_bar.value = health_component.get_health()
	else:
		print("Warning: Health component not assigned to HealthBarUI. Please assign it in the editor.")

func set_health_component(health_comp: Health):
	if health_component != null:
		disconnect_health_component() # Disconnect jika sudah terhubung sebelumnya

	health_component = health_comp
	if health_component != null:
		connect_health_component()
		# Inisialisasi awal nilai healthbar setelah koneksi baru
		progress_bar.max_value = health_component.get_max_health()
		progress_bar.value = health_component.get_health()

func connect_health_component():
	if health_component != null:
		# Gunakan metode connect yang benar
		health_component.max_health_changed.connect(_on_max_health_changed)
		health_component.health_changed.connect(_on_health_changed)
	else:
		print("Error: Attempting to connect null health_component.")

func disconnect_health_component():
	# Periksa apakah koneksi masih ada sebelum memutuskan
	if health_component != null:
		if health_component.max_health_changed.is_connected(_on_max_health_changed):
			health_component.max_health_changed.disconnect(_on_max_health_changed)
		if health_component.health_changed.is_connected(_on_health_changed):
			health_component.health_changed.disconnect(_on_health_changed)

func _on_max_health_changed(_diff: int):
	if health_component != null:
		# Akses melalui getter: health_component.get_max_health()
		progress_bar.max_value = health_component.get_max_health()
		# Pastikan health bar terupdate jika max health berubah
		# Tidak perlu memanggil _on_health_changed(0) karena sinyal health_changed
		# akan dipancarkan secara otomatis oleh Health.gd jika health berubah
		# saat max_health berubah (misalnya health dikurangi karena melebihi max_health baru).
		# Namun, jika Anda ingin memastikan nilai health bar selalu sinkron saat max_health berubah,
		# memanggil ini juga tidak masalah dan bisa jadi lebih aman.
		progress_bar.value = health_component.get_health() # Pastikan nilai juga diperbarui

func _on_health_changed(_diff: int):
	if health_component != null:
		# Akses melalui getter: health_component.get_health()
		progress_bar.value = health_component.get_health()
