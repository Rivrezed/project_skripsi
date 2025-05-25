#air_move_state.gd
extends AirState

@export var rising_animation : StringName = "rising"
@export var falling_animation : StringName = "falling"
# @export var jump_animation : StringName = "jump" # This line is removed

func _update(delta: float) -> void:
	super(delta) 
	select_animation()

	if blackboard.get_var(BBNames.attack_var):
		dispatch("attack")

func select_animation():
	if animation_lock:
		return
	
	if character.velocity.y <= 0.0:
		# Play rising animation only if not already playing
		if character.animation_player.current_animation != rising_animation:
			character.animation_player.play(rising_animation)
	else:
		# Play falling animation only if not already playing
		if character.animation_player.current_animation != falling_animation:
			character.animation_player.play(falling_animation)
