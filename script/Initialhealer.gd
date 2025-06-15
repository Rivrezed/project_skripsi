# InitialHealer.gd
extends Node

@export var heal_amount_on_start: int = 999999999999

func _ready():
	await get_tree().current_scene.ready

	var player_health_node: Node = find_player_health_node()

	if player_health_node != null:
		if player_health_node.has_method("get_health") and player_health_node.has_method("set_health"):
			var current_health = player_health_node.call("get_health")
			var max_health = 0
			if player_health_node.has_method("get_max_health"):
				max_health = player_health_node.call("get_max_health")
			else:
				max_health = heal_amount_on_start + current_health

			var new_health = min(current_health + heal_amount_on_start, max_health)
			player_health_node.call("set_health", new_health)

			if has_node("/root/Damagenumber"):
				var damage_number = get_node("/root/Damagenumber")
				var display_position = Vector2.ZERO
				if player_health_node.get_parent() is Node2D:
					display_position = player_health_node.get_parent().global_position
				damage_number.display_number(heal_amount_on_start, display_position, false, true)

			print("Player healed for %d on game start!" % heal_amount_on_start)
		else:
			print("Kesalahan: Node Player_Health tidak memiliki metode 'get_health' atau 'set_health'.")
	else:
		print("Kesalahan: Node Player_Health tidak ditemukan di scene.")

func find_player_health_node() -> Node:
	# Panggil metode privat untuk memulai pencarian rekursif
	return _recursive_find_health(get_tree().root)

func _recursive_find_health(node: Node) -> Node:
	if node.get_class() == "Player_Health":
		return node

	for child in node.get_children():
		var found_node = _recursive_find_health(child)
		if found_node != null:
			return found_node
	return null
