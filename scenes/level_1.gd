# Main.gd
extends Node2D

@export var player_stats: CharacterStats 
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
		
	if player_stats == null:
		player_stats = load("res://player_stats.tres")
		if player_stats == null:
			print("Error: player_stats.tres not found at specified path!")
			return
		
	# Reset Player Stats
	player_stats.reset_to_default()
	print("Player stats have been reset on game start.")

	# Reset Coin Amount from Autoload
	# Replace 'Startupcoin' with the actual name you gave your autoload in Project Settings
	if has_node("/root/Startupcoin"): 
		get_node("/root/Startupcoin").reset_coins_to_default()
	else:
		print("Peringatan: Autoload 'Startupcoin' tidak ditemukan! Pastikan telah diatur di Project Settings.")
