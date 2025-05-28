extends Control

@onready var health_display_label: Label = $HealthDisplayLabel

@export var player_stats: CharacterStats # Ini yang berubah

func _ready():
	# Pastikan player_stats telah ditetapkan di editor
	if player_stats == null:
		push_warning("player_stats Resource not assigned in the editor!")
		return

	update_health_display()
	# Connect to your custom signal if other parts of your game need to react
	# player_stats.resource_changed_custom.connect(update_health_display) # Optional: if you want the label to update when the resource changes elsewhere

func _on_IncreaseHealthButton_pressed():
	if player_stats == null: return # Pencegahan error
	player_stats.max_health_stat += 1 # The setter in CharacterStats will emit the signal
	update_health_display() # Update immediately
	ResourceSaver.save(player_stats, player_stats.resource_path)

func _on_DecreaseHealthButton_pressed():
	if player_stats == null: return # Pencegahan error
	if player_stats.max_health_stat > 1:
		player_stats.max_health_stat -= 1 # The setter in CharacterStats will emit the signal
		update_health_display() # Update immediately
		ResourceSaver.save(player_stats, player_stats.resource_path)

func update_health_display():
	if player_stats == null: return # Pencegahan error
	health_display_label.text = "" + str(player_stats.max_health_stat)
