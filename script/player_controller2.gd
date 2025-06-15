class_name Player
extends Character

@export var player_actions : PlayerActions
@export var initial_heal_amount: int = 999999999999

# Export var untuk menunjuk langsung ke node Player_Health
@export var player_health_node: Node

signal player_died_event

func _ready():
	_apply_initial_heal()

func _on_health_health_depleted() -> void:
	player_died_event.emit()
	queue_free()

func _apply_initial_heal():
	# Tunggu 1 detik sebelum melanjutkan kode heal
	await get_tree().create_timer(1.0).timeout

	if player_health_node != null:
		if player_health_node.has_method("get_health") and player_health_node.has_method("set_health"):
			var current_health = player_health_node.call("get_health")
			var max_health = 0

			if player_health_node.has_method("get_max_health"):
				max_health = player_health_node.call("get_max_health")
			else:
				max_health = initial_heal_amount + current_health

			var new_health = min(current_health + initial_heal_amount, max_health)
			player_health_node.call("set_health", new_health)

			print("Player healed for %d on game start!" % initial_heal_amount)
		else:
			print("Kesalahan: Node Player_Health yang ditunjuk tidak memiliki metode 'get_health' atau 'set_health'.")
	else:
		print("Kesalahan: Node Player_Health belum ditunjuk di editor untuk Player.")
