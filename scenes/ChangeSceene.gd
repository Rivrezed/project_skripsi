extends Button

@export var target_scene_path: String = "res://scenes/scene.tscn" # Default value disetel di sini

func _ready():
	# Menghubungkan sinyal 'pressed' dari tombol ini ke fungsi '_on_pressed'
	pressed.connect(_on_pressed)

func _on_pressed():
	# Fungsi ini akan dipanggil saat tombol ditekan
	if target_scene_path and not target_scene_path.is_empty():
		get_tree().change_scene_to_file(target_scene_path)
	else:
		print("ERROR: 'target_scene_path' (String) is not assigned or is empty for this button!")
