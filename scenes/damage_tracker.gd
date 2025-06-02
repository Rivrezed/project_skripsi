extends Node

@export var damage_display_label: Label = null

var total_damage_taken: int = 0

func _ready():
	if damage_display_label == null:
		print("Peringatan: damage_display_label tidak ditetapkan ke DamageTracker.")

	# Pastikan semua entitas yang menggunakan Health ditambahkan ke grup "entities_with_health"
	for node in get_tree().get_nodes_in_group("entities_with_health"):
		if node.has_method("get_health_node"): # Asumsi entitas punya metode untuk mendapatkan node Health
			var health_node = node.get_health_node() # Dapatkan referensi ke skrip Health
			if health_node != null and not health_node.health_changed.is_connected(_on_health_value_changed):
				health_node.health_changed.connect(_on_health_value_changed)
		elif node is Health: # Jika node itu sendiri adalah skrip Health
			if not node.health_changed.is_connected(_on_health_value_changed):
				node.health_changed.connect(_on_health_value_changed)
	
	_update_damage_display()

# Fungsi callback ketika sinyal health_changed dipancarkan
func _on_health_value_changed(difference: int):
	# Jika 'difference' negatif, artinya kesehatan berkurang (damage)
	if difference < 0:
		total_damage_taken += abs(difference) # Tambahkan nilai absolut dari kerusakan
		_update_damage_display()

func _update_damage_display():
	if damage_display_label != null:
		damage_display_label.text = "Total Kerusakan: " + str(total_damage_taken)

# Tambahan: Jika Anda memiliki entitas kompleks, Anda mungkin perlu cara
# untuk mendapatkan referensi ke node Health dari entitas tersebut.
# Misalnya, jika Character (Player/Enemy) adalah Parent dari Health.
# Di skrip Player/Enemy:
# func get_health_node() -> Health:
#     return $HealthNodePath # Ganti dengan path ke node Health Anda
