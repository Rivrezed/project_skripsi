class_name Player_Health
extends Node

signal max_health_changed(diff: int)
signal health_changed(diff: int)
signal health_depleted

@export var character_stats: CharacterStats

# --- Variabel Referensi Animasi ---
@export var animation_player: AnimationPlayer
@export var player_visuals: CanvasItem # BARU: Tambahkan variabel untuk node visual pemain (e.g., Sprite2D)

@export var immortality: bool = false : set = set_immortality, get = get_immortality

# --- Variabel Audio ---
@export var damage_sound_player: AudioStreamPlayer2D
@export var damage_sound_effect: AudioStream
@export var damage_sfx_cooldown: float = 0.2

var immortality_timer: Timer = null
var _can_play_damage_sfx: bool = true

var _current_max_health: int = 1
var health: int = 1 : set = set_health, get = get_health

func _ready():
	if character_stats == null:
		print("Warning: character_stats not assigned to Health node. Using default max_health.")
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
		health_changed.emit(difference)

		if health == 0:
			health_depleted.emit()

func get_health():
	return health

func apply_damage(amount: int):
	if immortality and amount > 0:
		return

	if amount > 0 and health - amount < health:
		set_health(health - amount)
		play_damage_sound()
		_play_damage_feedback() # BARU: Panggil fungsi feedback visual

# BARU: Fungsi untuk memutar efek visual saat terkena damage
func _play_damage_feedback():
	if player_visuals == null:
		push_warning("Player Visuals node is not assigned in Player_Health.")
		return

	# Buat Tween untuk menganimasikan properti modulate
	var tween = get_tree().create_tween()
	
	# Atur warna menjadi merah seketika
	player_visuals.modulate = Color.RED
	
	# Animasikan warna kembali ke putih (normal) selama 0.3 detik.
	# Ini menciptakan efek "fade" kembali ke warna semula, bukan kembali secara tiba-tiba.
	tween.tween_property(player_visuals, "modulate", Color.WHITE, 0.3)

func play_damage_sound():
	if not _can_play_damage_sfx:
		return

	if damage_sound_player and damage_sound_effect:
		damage_sound_player.stream = damage_sound_effect
		damage_sound_player.play()
		
	_can_play_damage_sfx = false
	get_tree().create_timer(damage_sfx_cooldown).timeout.connect(func():
		_can_play_damage_sfx = true
	)

func update_from_resource():
	if character_stats != null:
		set_max_health(character_stats.max_health_stat)
