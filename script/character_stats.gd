# CharacterStats.gd
class_name CharacterStats
extends Resource

signal resource_changed_custom

@export var run_speed : float = 300.0:
	set(value):
		run_speed = value
		resource_changed_custom.emit()

@export var attacking_run_speed : float = 150.0:
	set(value):
		attacking_run_speed = value
		resource_changed_custom.emit()

@export var max_air_speed : float = 200.0:
	set(value):
		max_air_speed = value
		resource_changed_custom.emit()

@export var air_acceleration : float = 200.0:
	set(value):
		air_acceleration = value
		resource_changed_custom.emit()

@export var jump_velocity : float = 600.0:
	set(value):
		jump_velocity = value
		resource_changed_custom.emit()
		
@export var damage_random_range_stat: int = 5:
	set(value):
		damage_random_range_stat = value
		resource_changed_custom.emit()

var _max_health_stat: int = 12500 
@export var max_health_stat: int:
	get:
		return _max_health_stat
	set(value):
		_max_health_stat = value
		resource_changed_custom.emit()

var _base_damage_stat: int = 123 
@export var base_damage_stat: int:
	get:
		return _base_damage_stat
	set(value):
		_base_damage_stat = value
		resource_changed_custom.emit()

var _crit_rate_stat: float = 0.25 
@export var crit_rate_stat: float:
	get:
		return _crit_rate_stat
	set(value):
		_crit_rate_stat = clampf(value, 0.0, 1.0)
		resource_changed_custom.emit()

var _crit_damage_multiplier_stat: float = 2.5 
@export var crit_damage_multiplier_stat: float:
	get:
		return _crit_damage_multiplier_stat
	set(value):
		_crit_damage_multiplier_stat = maxf(1.0, value)
		resource_changed_custom.emit()

func reset_to_default():
	max_health_stat = 10000
	base_damage_stat = 100
	crit_rate_stat = 0.25
	crit_damage_multiplier_stat = 1.5
	
	# --- Add this section to save the resource ---
	if ResourceLoader.exists(self.resource_path): # Check if the resource has a path (is saved to disk)
		var error = ResourceSaver.save(self, self.resource_path)
		if error == OK:
			print("Player stats reset and saved to: ", self.resource_path)
		else:
			push_error("Error saving player stats: ", error)
	else:
		print("Player stats resource has no path, cannot save to disk.")
	# --- End of added section ---
	
	print("Player stats reset to default values.")
