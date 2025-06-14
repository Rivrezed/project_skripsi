# OptionsMenuButton.gd
extends Button

@export var options_menu_path: NodePath # Path ke Node2D menu opsi Anda

var options_menu: Node2D

func _ready():
	# Pastikan Node2D menu opsi ada dan disembunyikan di awal
	options_menu = get_node(options_menu_path)
	if options_menu:
		options_menu.visible = false
	else:
		print("Error: Node2D Options Menu tidak ditemukan di path: ", options_menu_path)

	# Hubungkan sinyal 'pressed' dari tombol ini ke fungsi _on_pressed
	pressed.connect(_on_pressed)

func _on_pressed():
	# Logika untuk menampilkan menu opsi
	if options_menu:
		# Kita ingin menu opsi muncul di atas segalanya, jadi kita pastikan terlihat
		options_menu.visible = true
		print("Menampilkan menu Opsi.")

	# Jika Anda memiliki menu utama yang sedang terlihat, Anda mungkin ingin menyembunyikannya
	# Ini adalah contoh, sesuaikan dengan struktur scene Anda
	var main_menu = get_parent().get_node_or_null("MainMenuContainer") # Ganti "MainMenuContainer" dengan nama node menu utama Anda
	if main_menu and main_menu.visible:
		main_menu.visible = false
