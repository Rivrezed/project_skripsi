extends Area2D

@export var stats_hub_node_path: NodePath  # Path ke node UI yang punya fungsi _claim_rewards
var stats_hub = null

func _ready():
	if stats_hub_node_path != null:
		stats_hub = get_node(stats_hub_node_path)
	else:
		push_warning("stats_hub_node_path belum di-set di editor!")

	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node) -> void:
	# Pastikan body adalah player, misal cek group "player"
		if stats_hub != null:
			stats_hub._claim_rewards(body)
		else:
			push_warning("stats_hub belum ditemukan!")
