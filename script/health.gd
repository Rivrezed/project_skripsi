class_name Health
extends Node

signal max_health_changed(diff: int)
signal health_changed(diff: int)
signal health_depleted
signal damage_taken(amount: int)

@export var character_stats: CharacterStats

@export var immortality: bool = false : set = set_immortality, get = get_immortality

@export var damage_sound_effect: AudioStream # The actual sound file (e.g., a .wav or .ogg)
@export var damage_sfx_cooldown: float = 0.2 # Durasi cooldown untuk SFX damage (dalam detik)

# --- Tambahan: Node CanvasItem yang akan dimodulasi warnanya ---
@export var player_canvas_item: CanvasItem # Seret node player Anda di sini (misal: Sprite2D, CharacterBody2D, dll.)
@export var flash_color_duration: float = 0.1 # Durasi kilatan merah (dalam detik)

var immortality_timer: Timer = null
var _can_play_damage_sfx: bool = true # Flag untuk mengontrol cooldown SFX
var _original_player_modulate: Color # Menyimpan warna modulasi asli pemain

var _current_max_health: int = 1
var health: int = 1 : set = set_health, get = get_health

@onready var sound_manager = get_node("/root/SoundManager") # Pastikan nama autoload sesuai

func _ready():
	if character_stats == null:
		print("Peringatan: character_stats tidak ditetapkan ke node Health. Menggunakan max_health default.")
		set_max_health(3)
	else:
		update_from_resource()
		character_stats.resource_changed_custom.connect(update_from_resource)

	set_health(_current_max_health)
	
	# Simpan warna modulasi asli jika player_canvas_item ada
	if player_canvas_item:
		_original_player_modulate = player_canvas_item.modulate

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

	var actual_damage = clampi(amount, 0, health)
	
	if actual_damage > 0:
		set_health(health - actual_damage)
		play_damage_sound()
		flash_red() # Panggil fungsi flash_red di sini
		damage_taken.emit(actual_damage)

		var combo_label = get_tree().get_root().get_node("level1/CanvasLayer/ComboTextLabel")
		if combo_label:
			combo_label.add_combo_damage(actual_damage)

func play_damage_sound():
	if _can_play_damage_sfx:
		if sound_manager and damage_sound_effect:
			sound_manager.play_sfx(damage_sound_effect)
		
		_can_play_damage_sfx = false
		
		get_tree().create_timer(damage_sfx_cooldown).timeout.connect(func():
			_can_play_damage_sfx = true
		)

# --- Fungsi baru untuk kilatan merah ---
func flash_red():
	if player_canvas_item:
		# Hentikan tween yang sedang berjalan agar tidak tumpang tindih
		if player_canvas_item.get_meta("_modulate_tween_") and \
		   is_instance_valid(player_canvas_item.get_meta("_modulate_tween_")):
			(player_canvas_item.get_meta("_modulate_tween_") as Tween).kill()

		# Mulai tween untuk mengubah warna menjadi merah
		var tween_to_red = get_tree().create_tween()
		player_canvas_item.set_meta("_modulate_tween_", tween_to_red) # Simpan referensi tween
		tween_to_red.tween_property(player_canvas_item, "modulate", Color.RED, 0.05) # Kilatan cepat ke merah
		
		# Setelah kilatan merah, kembalikan ke warna asli
		tween_to_red.tween_property(player_canvas_item, "modulate", _original_player_modulate, flash_color_duration - 0.05)
		# Pastikan tween selesai sebelum potensi perubahan warna lainnya
		tween_to_red.set_trans(Tween.TRANS_LINEAR)
		tween_to_red.set_ease(Tween.EASE_IN_OUT)


func update_from_resource():
	if character_stats != null:
		set_max_health(character_stats.max_health_stat)
