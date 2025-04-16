extends CharacterState
## Idle state for the player character

func _update(_delta: float) -> void:
	var velocity : Vector2 = move()

	if not Vector2.ZERO.is_equal_approx(velocity):
		dispatch("moving", velocity)
