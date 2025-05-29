class_name HitBox
extends Area2D

var _character_stats: CharacterStats = null

@export var character_stats: CharacterStats:
	set(value):
		if _character_stats and _character_stats.has_signal("resource_changed_custom"):
			_character_stats.resource_changed_custom.disconnect(update_from_resource)

		_character_stats = value

		if _character_stats != null:
			update_from_resource()
			if _character_stats.has_signal("resource_changed_custom"):
				_character_stats.resource_changed_custom.connect(update_from_resource)
	get:
		return _character_stats

var base_damage: int = 5 : set = set_base_damage, get = get_base_damage
var damage_random_range: int = 3 : set = set_damage_random_range, get = get_damage_random_range
var crit_rate: float = 0.0 : set = set_crit_rate, get = get_crit_rate
var crit_damage_multiplier: float = 1.5 : set = set_crit_damage_multiplier, get = get_crit_damage_multiplier

func _ready():
	if character_stats != null:
		update_from_resource()
	else:
		print("Warning: character_stats not assigned to HitBox. Using default damage values.")
		set_base_damage(base_damage)
		set_damage_random_range(damage_random_range)
		set_crit_rate(crit_rate)
		set_crit_damage_multiplier(crit_damage_multiplier)

func update_from_resource():
	if character_stats == null: return
	set_base_damage(character_stats.base_damage_stat)
	set_damage_random_range(character_stats.damage_random_range_stat)
	set_crit_rate(character_stats.crit_rate_stat)
	set_crit_damage_multiplier(character_stats.crit_damage_multiplier_stat)

func set_base_damage(value: int):
	base_damage = max(1, value)

func get_base_damage() -> int:
	return base_damage

func set_damage_random_range(value: int):
	damage_random_range = max(0, value)

func get_damage_random_range() -> int:
	return damage_random_range

func set_crit_rate(value: float):
	crit_rate = clampf(value, 0.0, 1.0)

func get_crit_rate() -> float:
	return crit_rate

func set_crit_damage_multiplier(value: float):
	crit_damage_multiplier = maxf(1.0, value)

func get_crit_damage_multiplier() -> float:
	return crit_damage_multiplier

func calculate_damage() -> Dictionary:
	var calculated_base_damage: int
	var final_damage: int
	var is_critical: bool = false

	var min_damage = base_damage - damage_random_range
	var max_damage = base_damage + damage_random_range
	min_damage = max(1, min_damage)
	calculated_base_damage = randi_range(min_damage, max_damage)
	final_damage = calculated_base_damage

	if randf() < crit_rate:
		is_critical = true
		final_damage = roundi(float(calculated_base_damage) * crit_damage_multiplier)

	return {"damage": final_damage, "is_critical": is_critical}
