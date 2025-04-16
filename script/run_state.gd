extends CharacterState
func _update(_delta: float) -> void:
	var velocity : Vector2 = move()

	if Vector2.ZERO.is_equal_approx(velocity):
		dispatch("stopped", velocity)
