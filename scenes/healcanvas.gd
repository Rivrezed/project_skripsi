# floating_text.gd
extends CanvasGroup

@onready var label: Label = $Label

var display_duration: float = 1.0 # Durasi teks ditampilkan
var float_speed: float = 50.0 # Kecepatan teks bergerak ke atas
var fade_start_time: float = 0.5 # Waktu mulai memudar

func _ready():
	# Memulai timer untuk menghapus node setelah durasi
	var timer = get_tree().create_timer(display_duration)
	timer.timeout.connect(queue_free)

func _process(delta: float):
	# Gerakkan teks ke atas
	# Menggunakan self.position
	self.position.y -= float_speed * delta

	# Efek memudar
	# Menggunakan self.alpha
	if get_tree().get_time_since_started() > fade_start_time:
		var fade_progress = (get_tree().get_time_since_started() - fade_start_time) / (display_duration - fade_start_time)
		self.alpha = lerp(1.0, 0.0, fade_progress)

func set_text(amount: int):
	label.text = "+%d" % amount
	# Posisi label agar berpusat pada parent (FloatingText)
	label.position = -label.size / 2
