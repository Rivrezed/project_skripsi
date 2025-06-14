extends Node2D # Atau jenis node root scene Anda (misal Node2D, Node)

func pause_or_unpause():
	if get_tree().paused == true:
		$".".hide()
	elif get_tree().paused == false:
		$".".show() # This line also appears to be a placeholder or incomplete.
		get_tree().paused = true
