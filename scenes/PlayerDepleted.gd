extends "res://script/health.gd"

func _on_health_health_depleted():
	queue_free()
