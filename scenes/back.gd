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

func _input(event):
	# Sembunyikan menu opsi ketika tombol ESC ditekan dan menu sedang terlihat
	if event.is_action_pressed("ui_cancel") and options_menu and options_menu.visible:
		options_menu.visible = false
		print("Menu Opsi disembunyikan (ESC ditekan).")
		get_viewport().set_input_as_handled() # Menggunakan Viewport untuk menangani input
		# Atau, lebih tepatnya, Anda dapat memanggil event.is_handled() jika Anda ingin event tersebut tidak disebarkan lebih lanjut
		# event.set_handled(true) # Ini akan menandai event sudah ditangani

func _on_pressed():
	# Logika untuk menampilkan menu opsi
	if options_menu:
		options_menu.visible = false # Pastikan menu terlihat saat tombol ditekan
		print("Menampilkan menu Opsi.")

	# Jika Anda memiliki menu utama yang sedang terlihat, Anda mungkin ingin menyembunyikannya
	# Ini adalah contoh, sesuaikan dengan struktur scene Anda
	var main_menu = get_parent().get_node_or_null("MainMenuContainer") # Ganti "MainMenuContainer" dengan nama node menu utama Anda
	if main_menu and main_menu.visible:
		main_menu.visible = false
