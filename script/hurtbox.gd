class_name HurtBox
extends Area2D

signal received_damage(damage: int)

@export var health: Health
@export var damage_number_offset: Vector2 = Vector2(0, -30) # Contoh: 30 piksel di atas

func _ready():
	connect("area_entered", _on_area_entered)

func _on_area_entered(hitbox: HitBox) -> void:
	if hitbox != null and health != null:
		var calculated_hit = hitbox.calculate_damage()
		var incoming_damage = calculated_hit["damage"]
		var is_critical = calculated_hit["is_critical"]

		var old_health = health.health # Simpan health lama sebelum dikurangi
		
		# Panggil fungsi apply_damage dari Health untuk mengelola pengurangan health
		# Fungsi ini akan mengurus immortality dan clamping
		health.apply_damage(incoming_damage) 
		
		var damage_dealt = old_health - health.health # Hitung damage yang benar-benar masuk setelah pengurangan oleh Health

		if damage_dealt > 0: # Hanya tampilkan angka jika damage benar-benar terjadi
			var display_pos = global_position + damage_number_offset
			Damagenumber.display_number(damage_dealt, display_pos, is_critical)
		
		received_damage.emit(damage_dealt) # Emit sinyal dengan damage yang benar-benar masuk
