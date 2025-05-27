extends Button

@onready var animation_player: AnimationPlayer = $"../../../../AnimationPlayer"

@export var target_scene_path: String = "res://scenes/mapselect.tscn"

func _ready() -> void:
	pressed.connect(_on_start_button_pressed)

	if animation_player:
		animation_player.animation_finished.connect(_on_camera_animation_finished)

func _on_start_button_pressed() -> void:
	if animation_player and animation_player.has_animation("camera_start"):
		set_process_mode(PROCESS_MODE_DISABLED)
		
		if get_parent():
			for child in get_parent().get_children():
				if child is Button and child != self:
					child.set_process_mode(PROCESS_MODE_DISABLED)

		animation_player.play("camera_start")
	else:
		_change_to_level1_scene()

func _on_camera_animation_finished(anim_name: String) -> void:
	if anim_name == "camera_start":
		_change_to_level1_scene()

func _change_to_level1_scene() -> void:
	var tree = get_tree()
	if tree == null:
		return

	if target_scene_path.is_empty():
		return

	if not ResourceLoader.exists(target_scene_path):
		return

	tree.change_scene_to_file(target_scene_path)


func _on_Restart_pressed() -> void:
	pass # Replace with function body.
