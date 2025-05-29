extends Control

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("e"):
		if self.visible: # Jika kontrol saat ini terlihat
			upgrade_menu() # Panggil fungsi untuk menyembunyikan
		else:            # Jika kontrol saat ini tersembunyi
			upgrade_select() # Panggil fungsi untuk menunjukkan
		
func upgrade_select():
	show()
		
func upgrade_menu():
	hide()
