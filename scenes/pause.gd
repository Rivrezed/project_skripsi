extends Control

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("esc"):
		pause_or_unpause()

func pause_or_unpause():
	if get_tree().paused == true:
		$".".hide() # This line seems to be a placeholder or incomplete from the image, normally it would be a specific node path like $"CanvasLayer/PauseMenu".hide()
		get_tree().paused = false
	elif get_tree().paused == false:
		$".".show() # This line also appears to be a placeholder or incomplete.
		get_tree().paused = true
