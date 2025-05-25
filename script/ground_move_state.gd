#ground_move_state.gd
extends GroundState

@export var idle_anim : StringName = "idle"
@export var move_anim : StringName = "run"


func _enter() -> void:
	super()
	_on_first_frame = true
	blackboard.set_var(BBNames.jumps_made_var, 0)

func _update(p_delta: float) -> void:
	super(p_delta)

	if Vector2.ZERO.is_equal_approx(character.velocity):
		character.animation_player.play(idle_anim)
	else:
		character.animation_player.play(move_anim)

	if blackboard.get_var(BBNames.attack_var):
		dispatch("attack")
