# SoundManager.gd (Simpan sebagai SoundManager.gd di folder Autoload Anda)
extends Node

@export var sfx_player: AudioStreamPlayer # Referensi ke AudioStreamPlayer di scene ini
@export var damage_sfx: AudioStream # Sound effect damage yang akan diputar

func _ready():
	if sfx_player == null:
		print("Peringatan: sfx_player tidak ditetapkan di SoundManager.")

func play_sfx(audio_stream: AudioStream):
	if sfx_player and audio_stream:
		sfx_player.stream = audio_stream
		sfx_player.play()

# Anda bisa menambahkan fungsi lain seperti:
# func play_music(music_stream: AudioStream):
#     # Logic untuk memutar musik
# func stop_sfx():
#     sfx_player.stop()
