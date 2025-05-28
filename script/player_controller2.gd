class_name Player
extends Character

@export var player_actions : PlayerActions

signal player_died_event 

func _on_health_health_depleted() -> void:
	player_died_event.emit()
	queue_free()
