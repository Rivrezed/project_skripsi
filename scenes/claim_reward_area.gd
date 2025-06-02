extends Area2D

# Target node yang memiliki fungsi claim_rewards (misalnya: UI, GameManager, dsb)
@export var reward_target: NodePath

func _ready():
	connect("body_entered", _on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.name == "Player2":  # Ganti sesuai nama node player di scene kamu
		if has_node(reward_target):
			var target_node = get_node(reward_target)
			if target_node.has_method("_claim_rewards"):
				target_node._claim_rewards()
			else:
				push_warning("Target node tidak memiliki fungsi _claim_rewards.")
		else:
			push_warning("Reward target tidak ditemukan.")
