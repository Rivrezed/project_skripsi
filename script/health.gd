class_name Health
extends Node

signal max_health_changed(diff: int)
signal health_changed(diff: int)
signal health_depleted


@export var max_health: int = 3 : set = set_max_health, get = get_max_health
@export var immortality: bool = false : set = set_immortality, get = get_immortality

var immortality_timer: Timer = null

@onready var health: int = max_health : set = set_health, get = get_health


func set_max_health(value: int):
	var clamped_value = max(1, value) # Pastikan max_health minimal 1
	
	if not clamped_value == max_health:
		var difference = clamped_value - max_health
		max_health = clamped_value # Set max_health ke nilai yang sudah diklamp
		max_health_changed.emit(difference)
		
		if health > max_health:
			set_health(max_health) # Gunakan setter untuk memastikan health tidak melebihi max_health


func get_max_health() -> int:
	return max_health


func set_immortality(value: bool):
	immortality = value


func get_immortality() -> bool:
	return immortality


func set_temporary_immortality(time: float):
	if immortality_timer == null:
		immortality_timer = Timer.new()
		immortality_timer.one_shot = true
		add_child(immortality_timer)
	
	if immortality_timer.timeout.is_connected(set_immortality):
		immortality_timer.timeout.disconnect(set_immortality)
	
	immortality_timer.set_wait_time(time)
	immortality_timer.timeout.connect(set_immortality.bind(false))
	immortality = true
	immortality_timer.start()

# Fungsi setter untuk 'health' (memastikan nilai selalu di antara 0 dan max_health)
func set_health(value: int):
	var new_health_value = clampi(value, 0, max_health) # Kunci: Selalu klamphp di sini!
	
	if new_health_value != health:
		var difference = new_health_value - health
		health = new_health_value # Set health ke nilai yang sudah diklamp
		health_changed.emit(difference)
		
		if health == 0:
			health_depleted.emit()

func get_health():
	return health

# Fungsi baru untuk menerapkan damage atau healing
func apply_damage(amount: int):
	if immortality and amount > 0: # Jika ada damage dan immortality aktif, jangan lakukan apa-apa
		return
	
	set_health(health - amount) # Gunakan setter untuk mengurangi health
