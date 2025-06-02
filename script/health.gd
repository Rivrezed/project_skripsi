class_name Health
extends Node

signal max_health_changed(diff: int)
signal health_changed(diff: int)
signal health_depleted
signal damage_taken(amount: int)

@export var character_stats: CharacterStats

@export var immortality: bool = false : set = set_immortality, get = get_immortality

# --- Re-add damage_sound_effect here! ---
@export var damage_sound_effect: AudioStream # The actual sound file (e.g., a .wav or .ogg)
@export var damage_sfx_cooldown: float = 0.2 # Durasi cooldown untuk SFX damage (dalam detik)

var immortality_timer: Timer = null
var _can_play_damage_sfx: bool = true # Flag untuk mengontrol cooldown SFX

var _current_max_health: int = 1
var health: int = 1 : set = set_health, get = get_health

# --- Tambahkan referensi ke SoundManager global ---
@onready var sound_manager = get_node("/root/SoundManager") # Pastikan nama autoload sesuai

func _ready():
	if character_stats == null:
		print("Peringatan: character_stats tidak ditetapkan ke node Health. Menggunakan max_health default.")
		set_max_health(3)
	else:
		update_from_resource()
		character_stats.resource_changed_custom.connect(update_from_resource)

	set_health(_current_max_health)

func set_max_health(value: int):
	var clamped_value = max(1, value)

	if not clamped_value == _current_max_health:
		var difference = clamped_value - _current_max_health
		_current_max_health = clamped_value
		max_health_changed.emit(difference)

		if health > _current_max_health:
			set_health(_current_max_health)

func get_max_health() -> int:
	return _current_max_health

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

func set_health(value: int):
	var new_health_value = clampi(value, 0, _current_max_health)

	if new_health_value != health:
		var difference = new_health_value - health
		health = new_health_value
		# Emit sinyal health_changed dengan perbedaan
		health_changed.emit(difference)

		if health == 0:
			health_depleted.emit()

func get_health():
	return health

func apply_damage(amount: int):
	if immortality and amount > 0:
		return

	var actual_damage = clampi(amount, 0, health) # Avoid over-damage
	
	if actual_damage > 0: # Only apply damage if there's actual damage to take
		set_health(health - actual_damage)
		play_damage_sound() # Play sound when damage is successfully applied
		damage_taken.emit(actual_damage) # Emit the damage_taken signal

		# Panggil ComboTextLabel jika ada
		var combo_label = get_tree().get_root().get_node("level1/CanvasLayer/ComboTextLabel")
		if combo_label:
			combo_label.add_combo_damage(actual_damage)

func play_damage_sound():
	# Memutar SFX melalui SoundManager global jika cooldown memungkinkan
	if _can_play_damage_sfx:
		# Panggil fungsi di SoundManager untuk memutar suara
		if sound_manager and damage_sound_effect: # CHECK FOR damage_sound_effect here
			sound_manager.play_sfx(damage_sound_effect) # Pass the specific sound effect
		
		# Set flag ke false untuk memulai cooldown
		_can_play_damage_sfx = false
		
		# Buat timer untuk mereset flag setelah durasi cooldown
		get_tree().create_timer(damage_sfx_cooldown).timeout.connect(func():
			_can_play_damage_sfx = true
		)

func update_from_resource():
	if character_stats != null:
		set_max_health(character_stats.max_health_stat)
