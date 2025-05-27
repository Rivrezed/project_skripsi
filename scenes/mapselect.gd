extends Node2D

# @onready akan mencari node AnimationPlayer saat scene siap.
# Asumsikan AnimationPlayer adalah anak langsung dari Node2D ini.
# Sesuaikan path jika AnimationPlayer berada di lokasi lain.
@onready var animation_player: AnimationPlayer = $"AnimationPlayer"

func _ready() -> void:
	# Pastikan AnimationPlayer ditemukan dan memiliki animasi bernama "start"
	if animation_player:
		if animation_player.has_animation("start"):
			animation_player.play("start")
		else:
			# Pesan kesalahan jika animasi "start" tidak ditemukan
			# Ini akan membantu Anda debugging
			print("ERROR: Animation 'start' not found in AnimationPlayer!")
	else:
		# Pesan kesalahan jika node AnimationPlayer tidak ditemukan
		print("ERROR: AnimationPlayer node not found at path '", animation_player.get_path() if animation_player else "null path", "'. Check the @onready path.")
