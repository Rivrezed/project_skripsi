#character_state.gd
class_name CharacterState
extends LimboState

@export var animation_name : StringName

var character : Character
var animation_lock : bool = false

func _enter() -> void:
	character = agent as Character
	character.animation_player.play(animation_name)


func _apply_gravity(p_delta : float):
	if not character.is_on_floor():
		character.velocity += character.get_gravity() * p_delta

func lock_animation():
	animation_lock = true

func unlock_animation():
	animation_lock = false
