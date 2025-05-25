#ground_attack_state.gd
extends GroundState

@export var attack_2 : StringName
@export var attack_3 : StringName

func _enter() -> void:
	super()
	character.animation_player.animation_finished.connect(_on_animation_finished)
	blackboard.set_var(BBNames.attack_var, false)

func _exit() -> void:
	character.animation_player.animation_finished.disconnect(_on_animation_finished)

# Handles chaining of attacks is attack is still set to true or return to ground
func _on_animation_finished(p_animation : StringName):
	if not blackboard.get_var(BBNames.attack_var):
		dispatch("finished")
		return

	match p_animation:
		animation_name:
			if attack_2.is_empty():
				dispatch("finished")
				return

			character.animation_player.play(attack_2)
			blackboard.set_var(BBNames.attack_var, false)
		attack_2:
			if attack_3.is_empty():
				dispatch("finished")
				return

			character.animation_player.play(attack_3)
			blackboard.set_var(BBNames.attack_var, false)
		_:
			dispatch("finished")
