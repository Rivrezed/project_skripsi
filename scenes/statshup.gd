extends Control

@onready var health_display_label: Label = $HealthDisplayLabel
@onready var base_damage_label: Label = $"../AttackUp/BaseDamageLabel"
@onready var crit_rate_label: Label = $"../CritRateUp/CritRateLabel"
@onready var crit_damage_multiplier_label: Label = $"../CritDmgUp/CritDamageMultiplierLabel"

@export var player_stats: CharacterStats # Ini yang berubah



func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("e"):
		update_all_displays()
		
func _ready():
	
	# Pastikan player_stats telah ditetapkan di editor
	if player_stats == null:
		push_warning("player_stats Resource not assigned in the editor!")
		return

	# Connect the custom signal to update all displays whenever the resource changes
	player_stats.resource_changed_custom.connect(update_all_displays)
	update_all_displays() # Call this function to update all labels initially

func _on_IncreaseHealthButton_pressed():
	if player_stats == null: return # Pencegahan error
	player_stats.max_health_stat += 1 # The setter in CharacterStats will emit the signal
	# No need to call update_health_display() here; the connected signal will handle it.
	ResourceSaver.save(player_stats, player_stats.resource_path)

func _on_DecreaseHealthButton_pressed():
	if player_stats == null: return # Pencegahan error
	if player_stats.max_health_stat > 1:
		player_stats.max_health_stat -= 1 # The setter in CharacterStats will emit the signal
		# No need to call update_health_display() here; the connected signal will handle it.
		ResourceSaver.save(player_stats, player_stats.resource_path)

func _on_IncreaseBaseDamageButton_pressed(): # New function
	if player_stats == null: return
	player_stats.base_damage_stat += 1
	# No need to call update_base_damage_display() here; the connected signal will handle it.
	ResourceSaver.save(player_stats, player_stats.resource_path)

func _on_DecreaseBaseDamageButton_pressed(): # New function
	if player_stats == null: return
	if player_stats.base_damage_stat > 0: # Prevent negative damage
		player_stats.base_damage_stat -= 1
		# No need to call update_base_damage_display() here; the connected signal will handle it.
		ResourceSaver.save(player_stats, player_stats.resource_path)

func _on_IncreaseCritRateButton_pressed(): # New function
	if player_stats == null: return
	player_stats.crit_rate_stat = min(player_stats.crit_rate_stat + 0.05, 1.0) # Increase by 5%, cap at 1.0 (100%)
	# No need to call update_crit_rate_display() here; the connected signal will handle it.
	ResourceSaver.save(player_stats, player_stats.resource_path)

func _on_DecreaseCritRateButton_pressed(): # New function
	if player_stats == null: return
	player_stats.crit_rate_stat = max(player_stats.crit_rate_stat - 0.05, 0.0) # Decrease by 5%, cap at 0.0
	# No need to call update_crit_rate_display() here; the connected signal will handle it.
	ResourceSaver.save(player_stats, player_stats.resource_path)

func _on_IncreaseCritDamageMultiplierButton_pressed(): # New function
	if player_stats == null: return
	player_stats.crit_damage_multiplier_stat += 0.1 # Increase by 0.1
	# No need to call update_crit_damage_multiplier_display() here; the connected signal will handle it.
	ResourceSaver.save(player_stats, player_stats.resource_path)

func _on_DecreaseCritDamageMultiplierButton_pressed(): # New function
	if player_stats == null: return
	if player_stats.crit_damage_multiplier_stat > 1.0: # Prevent less than 1x damage (base damage)
		player_stats.crit_damage_multiplier_stat -= 0.1
		# No need to call update_crit_damage_multiplier_display() here; the connected signal will handle it.
		ResourceSaver.save(player_stats, player_stats.resource_path)

func update_health_display():
	if player_stats == null: return
	health_display_label.text = "" + str(player_stats.max_health_stat)

func update_base_damage_display(): # New function
	if player_stats == null: return
	base_damage_label.text = "" + str(player_stats.base_damage_stat)

func update_crit_rate_display():
	if player_stats == null: return
	# Format as percentage for better readability
	# Multiplies by 100.0 to convert to percentage, then snaps to one decimal place
	crit_rate_label.text = str(snapped(player_stats.crit_rate_stat * 100.0, 0.1)) + "%"

func update_crit_damage_multiplier_display():
	if player_stats == null: return
	# Calculate the bonus percentage (e.g., 1.5 multiplier becomes +50% damage)
	var bonus_percent = (player_stats.crit_damage_multiplier_stat - 1.0) * 100.0
	# Format with a '+' sign and snap to one decimal place
	crit_damage_multiplier_label.text = "+" + str(snapped(bonus_percent, 0.1)) + "%"

func update_all_displays(): # Function to call all update functions
	update_health_display()
	update_base_damage_display()
	update_crit_rate_display()
	update_crit_damage_multiplier_display()
