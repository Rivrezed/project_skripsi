class_name Health
extends Node

signal max_health_changed(diff: int)
signal health_changed(diff: int)
signal health_depleted

# Hapus atau ubah ini jika Anda tidak ingin max_health diekspor di Health.gd secara langsung
# @export var max_health: int = 3 : set = set_max_health, get = get_max_health

# Ini adalah cara Health akan mendapatkan statsnya
@export var character_stats: CharacterStats # WAJIB: Ini harus diekspor agar bisa diatur di editor

@export var immortality: bool = false : set = set_immortality, get = get_immortality

var immortality_timer: Timer = null

# Inisialisasi health di _ready setelah max_health diatur
var _current_max_health: int = 1 # Variabel internal untuk menyimpan max_health yang efektif
var health: int = 1 : set = set_health, get = get_health # Gunakan setter saat inisialisasi

func _ready():
	# Pastikan character_stats sudah terhubung
	if character_stats == null:
		# Peringatan atau error jika resource tidak terhubung, atau gunakan default
		print("Warning: character_stats not assigned to Health node. Using default max_health.")
		set_max_health(3) # Default jika tidak ada stats yang diberikan
	else:
		# Gunakan nilai dari character_stats untuk menginisialisasi max_health
		set_max_health(character_stats.max_health_stat)
	
	# Inisialisasi health setelah max_health diatur.
	# Gunakan setter untuk memastikan health tidak melebihi max_health_stat
	set_health(_current_max_health) # Inisialisasi health ke nilai max_health

func set_max_health(value: int):
	var clamped_value = max(1, value) # Pastikan max_health minimal 1
	
	if not clamped_value == _current_max_health: # Bandingkan dengan _current_max_health
		var difference = clamped_value - _current_max_health
		_current_max_health = clamped_value # Set _current_max_health ke nilai yang sudah diklamp
		max_health_changed.emit(difference)
		
		# Jika health saat ini melebihi max_health yang baru, turunkan health
		if health > _current_max_health:
			set_health(_current_max_health) # Gunakan setter untuk memastikan health tidak melebihi _current_max_health

func get_max_health() -> int:
	return _current_max_health # Mengembalikan _current_max_health

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

# Fungsi setter untuk 'health' (memastikan nilai selalu di antara 0 dan _current_max_health)
func set_health(value: int):
	# Kunci: Selalu klamphp di sini menggunakan _current_max_health!
	var new_health_value = clampi(value, 0, _current_max_health) 
	
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
