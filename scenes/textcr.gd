extends Label

@export var player_character_stats_resource: CharacterStats # Seret file .tres Anda ke sini

func _ready():
	if player_character_stats_resource != null:
		# Akses langsung base_damage_stat dari resource CharacterStats
		text = "" + str(player_character_stats_resource.crit_rate_stat)
	else:
		print("Warning: Player CharacterStats resource not assigned to HealthTextUI. Please assign your .tres file in the editor.")
		text = "N/A"
