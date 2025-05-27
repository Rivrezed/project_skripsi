class_name HitBox
extends Area2D

@export var base_damage: int = 5 : set = set_base_damage, get = get_base_damage
@export var damage_random_range: int = 3 : set = set_damage_random_range, get = get_damage_random_range # Ini adalah rentang random untuk base damage
@export var crit_rate: float = 0.0 : set = set_crit_rate, get = get_crit_rate # 0.0 hingga 1.0 (misal: 0.25 untuk 25%)
@export var crit_damage_multiplier: float = 1.5 : set = set_crit_damage_multiplier, get = get_crit_damage_multiplier # Contoh: 1.5 untuk 150% damage kritikal

func set_base_damage(value: int):
	base_damage = max(1, value) # Pastikan damage minimal 1

func get_base_damage() -> int:
	return base_damage

func set_damage_random_range(value: int):
	damage_random_range = max(0, value) # Pastikan rentang random tidak negatif

func get_damage_random_range() -> int:
	return damage_random_range

func set_crit_rate(value: float):
	crit_rate = clampf(value, 0.0, 1.0) # Pastikan antara 0.0 dan 1.0

func get_crit_rate() -> float:
	return crit_rate

func set_crit_damage_multiplier(value: float):
	crit_damage_multiplier = maxf(1.0, value) # Pastikan minimal 1.0 (tidak mengurangi damage)

func get_crit_damage_multiplier() -> float:
	return crit_damage_multiplier

# Fungsi untuk menghitung damage yang sebenarnya (termasuk crit)
func calculate_damage() -> Dictionary:
	var calculated_base_damage: int
	var final_damage: int
	var is_critical: bool = false

	# Hitung base damage dengan random range
	var min_damage = base_damage - damage_random_range
	var max_damage = base_damage + damage_random_range
	# Pastikan damage minimum tidak di bawah 1
	min_damage = max(1, min_damage)
	calculated_base_damage = randi_range(min_damage, max_damage)
	final_damage = calculated_base_damage

	# Periksa apakah serangan kritikal terjadi
	if randf() < crit_rate: # randf() menghasilkan angka float acak antara 0.0 dan 1.0
		is_critical = true
		final_damage = roundi(float(calculated_base_damage) * crit_damage_multiplier)

	return {"damage": final_damage, "is_critical": is_critical}
