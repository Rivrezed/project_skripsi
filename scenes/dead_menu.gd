extends Control

var is_game_over: bool = false

func _ready():
	hide() 

func show_game_over_menu():
	is_game_over = true
	show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) 
	print("Game Over! Menampilkan menu kematian.")
