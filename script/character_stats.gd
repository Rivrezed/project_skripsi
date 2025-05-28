class_name CharacterStats
extends Resource

# Define the signal here
signal resource_changed_custom # Using a custom name to avoid conflict and be explicit

@export var run_speed : float = 300.0
@export var attacking_run_speed : float = 150.0
@export var max_air_speed :float = 200.0
@export var air_acceleration :float = 200.0
@export var jump_velocity : float = 600.0

# Use a setter for max_health_stat to emit the signal
var _max_health_stat: int = 3
@export var max_health_stat: int:
	get:
		return _max_health_stat
	set(value):
		_max_health_stat = value
		resource_changed_custom.emit() # Emit your custom signal here

@export var base_damage_stat: int = 5
@export var damage_random_range_stat: int = 3
@export var crit_rate_stat: float = 0.1
@export var crit_damage_multiplier_stat: float = 1.5
