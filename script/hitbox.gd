class_name HitBox
extends Area2D

# Referensi ke CharacterStats resource
@export var character_stats: CharacterStats

# Properti damage yang akan diinisialisasi dari CharacterStats
# Kita tidak lagi mengekspornya langsung di HitBox karena sumbernya dari CharacterStats
var base_damage: int = 5 : set = set_base_damage, get = get_base_damage
var damage_random_range: int = 3 : set = set_damage_random_range, get = get_damage_random_range
var crit_rate: float = 0.0 : set = set_crit_rate, get = get_crit_rate
var crit_damage_multiplier: float = 1.5 : set = set_crit_damage_multiplier, get = get_crit_damage_multiplier

func _ready():
	# Inisialisasi properti damage dari CharacterStats
	if character_stats != null:
		set_base_damage(character_stats.base_damage_stat)
		set_damage_random_range(character_stats.damage_random_range_stat)
		set_crit_rate(character_stats.crit_rate_stat)
		set_crit_damage_multiplier(character_stats.crit_damage_multiplier_stat)
	else:
		# Peringatan jika CharacterStats tidak terhubung, gunakan nilai default
		print("Warning: character_stats not assigned to HitBox. Using default damage values.")
		set_base_damage(base_damage) # Set ke nilai default yang ada di HitBox (jika ada)
		set_damage_random_range(damage_random_range)
		set_crit_rate(crit_rate)
		set_crit_damage_multiplier(crit_damage_multiplier)

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
