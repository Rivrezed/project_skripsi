class_name PlayerHurtBox
extends Area2D

signal received_damage(damage: int)

@export var health: Node
@export var damage_number_offset: Vector2 = Vector2(0, -30) # Contoh: 30 piksel di atas
@export var camera_shake_strength: float = 5.0 # Kekuatan getaran kamera
@export var camera_shake_duration: float = 0.15 # Durasi getaran kamera

func _ready():
	connect("area_entered", _on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area is HitBox and health != null:
		var hitbox = area as HitBox
		var calculated_hit = hitbox.calculate_damage()
		var incoming_damage = calculated_hit["damage"]
		var is_critical = calculated_hit["is_critical"]

		var old_health = health.health
		health.apply_damage(incoming_damage)
		var damage_dealt = old_health - health.health

		if damage_dealt > 0:
			var display_pos = global_position + damage_number_offset
			Damagenumber.display_number(damage_dealt, display_pos, is_critical)

			var camera = get_tree().get_first_node_in_group("MainCamera")
			if camera and camera is Camera2D and camera.has_method("shake"):
				camera.shake(camera_shake_strength, camera_shake_duration)

		received_damage.emit(damage_dealt)
