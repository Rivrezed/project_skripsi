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
		
var _damage_random_range_stat: int = 5
@export var damage_random_range_stat: int = 5:
	set(value):
		damage_random_range_stat = value
		resource_changed_custom.emit()

var _max_health_stat: int = 3
@export var max_health_stat: int:
	get:
		return _max_health_stat
	set(value):
		_max_health_stat = value
		resource_changed_custom.emit()

var _base_damage_stat: int = 5
@export var base_damage_stat: int:
	get:
		return _base_damage_stat
	set(value):
		_base_damage_stat = value
		resource_changed_custom.emit()

var _crit_rate_stat: float = 0.1
@export var crit_rate_stat: float:
	get:
		return _crit_rate_stat
	set(value):
		_crit_rate_stat = clampf(value, 0.0, 1.0)
		resource_changed_custom.emit()

var _crit_damage_multiplier_stat: float = 2.0
@export var crit_damage_multiplier_stat: float:
	get:
		return _crit_damage_multiplier_stat
	set(value):
		_crit_damage_multiplier_stat = maxf(1.0, value)
		resource_changed_custom.emit()
