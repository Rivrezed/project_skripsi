extends Label

@export var character_stats: CharacterStats # Referensi ke CharacterStats Resource Anda
@onready var player_health_node: Node = $"../../../PlayerHealth" # Sesuaikan path ini ke node Health pemain Anda

func _ready() -> void:
	# Pastikan referensi tidak null
	if character_stats == null:
		push_warning("HealthLabel: character_stats Resource not assigned!")
		return
	if player_health_node == null:
		push_warning("HealthLabel: Player Health node not found at specified path!")
		return

	# Hubungkan sinyal untuk memperbarui label secara otomatis
	player_health_node.health_changed.connect(_on_health_changed)
	character_stats.resource_changed_custom.connect(_on_character_stats_changed) # Untuk update max health

	# Perbarui tampilan awal
	update_health_display()

func _on_health_changed(_diff: int) -> void:
	# Dipanggil ketika kesehatan saat ini berubah
	update_health_display()

func _on_character_stats_changed() -> void:
	# Dipanggil ketika CharacterStats Resource berubah (misal, max_health_stat)
	update_health_display()

func update_health_display() -> void:
	# Pastikan referensi valid sebelum mencoba mengakses propertinya
	if player_health_node != null and character_stats != null:
		text = str(player_health_node.health) + "/" + str(character_stats.max_health_stat)
	else:
		text = "N/A" # Teks fallback jika ada masalah
