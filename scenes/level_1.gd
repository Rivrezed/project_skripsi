extends Node2D

@export var player_node: Player # Pastikan tipe 'Player' adalah class_name dari script player Anda
@export var ui_manager: Control # Pastikan tipe 'Control' atau tipe dasar dari UI Manager Anda

func _ready():
	if player_node and ui_manager:
		# Pastikan sinyal 'player_died_event' ada di script Player
		# dan fungsi 'show_game_over_menu' ada di script UI Manager
		player_node.player_died_event.connect(ui_manager.show_game_over_menu)
	else:
		# Pesan peringatan jika ada node yang belum ditetapkan di editor
		if not player_node:
			print("Peringatan: Player node belum ditetapkan di Main.gd!")
		if not ui_manager:
			print("Peringatan: UI Manager node belum ditetapkan di Main.gd!")
