#player_controller2.gd
class_name Player
extends Character

@export var player_actions : PlayerActions


func _on_health_health_depleted() -> void:
	queue_free()
