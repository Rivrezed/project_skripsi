extends State

var can_transition: bool = false

func enter():
	super.enter()
	animation_player.play("skill")
	await animation_player.animation_finished
	can_transition = true
	
func teleport():
	# Cek apakah objek 'player' masih valid sebelum mengakses posisinya
	if is_instance_valid(player):
		owner.position = player.position + Vector2.RIGHT * 50
	else:
		print("Warning: Player object was freed before teleportation could occur.")
		pass # Ini akan membuat fungsi mengabaikan teleportasi jika player sudah tidak ada

func transition():
	if can_transition:
		get_parent().change_state("Attack")
		can_transition = false
