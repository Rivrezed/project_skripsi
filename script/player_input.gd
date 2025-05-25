# player_input.gd
class_name PlayerInput
extends Node

@export var player_actions : PlayerActions

@export var limbo_hsm : LimboHSM

var blackboard : Blackboard
var input_direction : Vector2
var jump : bool # Ini akan menjadi flag transient yang disetel oleh input
# Hapus var attack : bool karena kita akan langsung menulis ke blackboard

func _ready() -> void:
	blackboard = limbo_hsm.blackboard
	blackboard.bind_var_to_property(BBNames.direction_var, self, "input_direction", false)
	# Jangan bind BBNames.jump_var ke self.jump karena kita akan mengelola resetnya secara manual
	# blackboard.bind_var_to_property(BBNames.jump_var, self, "jump", false)
	# Hapus binding untuk attack_var:
	# blackboard.bind_var_to_property(BBNames.attack_var, self, "attack", false) 

func _process(_delta: float) -> void:
	input_direction = Input.get_vector(player_actions.move_left, player_actions.move_right, player_actions.move_up, player_actions.move_down)
	blackboard.set_var(BBNames.direction_var, input_direction)

	# Kelola input jump
	if jump: # Jika jump true (karena tombol ditekan)
		blackboard.set_var(BBNames.jump_var, true)
		jump = false # Reset segera setelah diberikan ke blackboard (konsumsi satu kali)
	else:
		blackboard.set_var(BBNames.jump_var, false) # Pastikan Blackboard selalu diperbarui jika tidak ada jump input

	# Kelola input attack
	if Input.is_action_just_pressed(player_actions.attack):
		blackboard.set_var(BBNames.attack_var, true)
	else:
		# Penting: Reset attack_var di blackboard jika tombol tidak ditekan
		# atau jika state attack telah mengkonsumsinya (akan set ke false di _enter)
		# Ini mencegah attack terus-menerus terpicu.
		# Namun, karena state attack akan mengelolanya, ini mungkin tidak perlu di sini
		# jika Anda hanya ingin trigger "just pressed".
		# Biarkan state attack yang meresetnya ke false saat _enter().
		pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(player_actions.jump):
		jump = true
	elif event.is_action_released(player_actions.jump): # FIX: Gunakan is_action_released
		jump = false

	# Logika attack kini di _process untuk konsistensi dengan set_var
	# if Input.is_action_just_pressed(player_actions.attack):
	# 	attack = true
