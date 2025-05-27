class_name HurtBox
extends Area2D

signal received_damage(damage: int)

@export var health: Health
# Anda bisa menambahkan offset jika ingin angka muncul sedikit di atas HurtBox
@export var damage_number_offset: Vector2 = Vector2(0, -30) # Contoh: 30 piksel di atas

func _ready():
	connect("area_entered", _on_area_entered)

func _on_area_entered(hitbox: HitBox) -> void:
	if hitbox != null and health != null: # Pastikan health tidak null
		var old_health = health.health # Simpan health lama sebelum dikurangi
		health.health -= hitbox.damage
		
		var damage_dealt = old_health - health.health # Hitung damage yang benar-benar masuk
		
		if damage_dealt > 0: # Hanya tampilkan angka jika damage benar-benar terjadi
			# Dapatkan posisi global HurtBox dan tambahkan offset
			var display_pos = global_position + damage_number_offset
			
			# Panggil singleton Damagenumber
			# Perhatikan bahwa is_critical disetel false secara default di sini.
			# Anda bisa menambahkan logika untuk critical hit di HitBox jika diperlukan.
			Damagenumber.display_number(damage_dealt, display_pos, false) 
		
		received_damage.emit(hitbox.damage)
