extends Control

func _ready() -> void:
	set_process_unhandled_input(true)
	hide()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("e"):
		if self.visible:
			upgrade_menu()
		else:
			upgrade_select()

func _unhandled_input(event: InputEvent) -> void:
	if self.visible:
		get_viewport().set_input_as_handled()

func upgrade_select():
	show()
		
func upgrade_menu():
	hide()
