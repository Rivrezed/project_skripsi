# Ini adalah skrip untuk state Attack

extends State

@export var teleport_away_distance: float = 250.0

# Flag dan timer untuk mencegah transisi instan
var can_transition: bool = false
var transition_delay_timer

func enter():
	super.enter()
	can_transition = false
	transition_delay_timer = get_tree().create_timer(0.2)
	transition_delay_timer.timeout.connect(func(): can_transition = true)

	var health_comp = owner.get_node("Health") as Health
	if health_comp:
		health_comp.health_changed.connect(_on_health_changed)

	combo()

func exit():
	super.exit()
	# SceneTreeTimer akan hancur secara otomatis, jadi tidak perlu dihentikan
	var health_comp = owner.get_node("Health") as Health
	if health_comp and health_comp.is_connected("health_changed", _on_health_changed):
		health_comp.health_changed.disconnect(_on_health_changed)

func transition():
	if not can_transition:
		return

	if owner.direction.length() > 200:
		get_parent().change_state("Follow")
	if owner.direction.length() > 300:
		get_parent().change_state("Teleport")

# Fungsi ini dipanggil di tengah proses fisika
func _on_health_changed(difference: int):
	if difference < 0:
		# Menghentikan animasi umumnya aman dan tidak memengaruhi state fisika.
		animation_player.stop()

		# INI BAGIAN KUNCINYA:
		# Anda tidak langsung teleport, tapi "menjadwalkan" teleportasi
		# untuk dieksekusi nanti setelah Godot selesai dengan urusan internalnya.
		call_deferred("_execute_teleport_and_exit")

# Fungsi ini akan dieksekusi pada "idle time", yaitu saat Godot 
# sudah aman untuk menerima perubahan state fisika.
func _execute_teleport_and_exit():
	teleport_away() # Mengubah owner.global_position
	get_parent().change_state("Follow") # Mengubah state, yang mungkin menonaktifkan/mengaktifkan collision shape

## ❗ FUNGSI YANG DIMODIFIKASI ❗ ##
func teleport_away():
	if not is_instance_valid(owner.player):
		return

	# Tentukan arah horizontal menjauh dari pemain
	var horizontal_direction = sign(owner.global_position.x - owner.player.global_position.x)

	# Jika berada di posisi x yang sama, pilih arah acak (kiri atau kanan)
	if horizontal_direction == 0:
		horizontal_direction = 1.0 if randf() > 0.5 else -1.0

	# Hitung posisi baru hanya pada sumbu X
	var new_position = owner.global_position
	new_position.x += horizontal_direction * teleport_away_distance

	# Tetapkan posisi baru
	owner.global_position = new_position


func attack(move = "1"):
	animation_player.play("attack_" + move)
	await animation_player.animation_finished

func combo():
	var move_set = ["1", "1", "2"]
	for i in move_set:
		await attack(i)
		if get_parent().current_state.name != "Attack":
			return
	combo()
