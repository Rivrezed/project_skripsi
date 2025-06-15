# Ini adalah skrip untuk node Button Anda
extends Button

@onready var animation_player = $"../../../../AnimationPlayer" # Ganti path ini sesuai dengan lokasi AnimationPlayer Anda

func _ready():
	# Menghubungkan sinyal 'pressed' dari tombol ke fungsi '_on_Button_pressed'
	pressed.connect(_on_Button_pressed)

func _on_Button_pressed():
	# Memutar animasi 'options_open' saat tombol ditekan
	if animation_player:
		animation_player.play("credits_open")
	else:
		print("Error: AnimationPlayer not found!")
