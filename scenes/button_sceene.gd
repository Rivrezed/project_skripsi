extends Button

@export var target_scene_path: String = "res://scenes/level1.tscn"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

func _ready() -> void:
	pressed.connect(_on_button_pressed)

	if animation_player:
		animation_player.animation_finished.connect(_on_animation_finished)

func _on_button_pressed() -> void:
	set_process_mode(PROCESS_MODE_DISABLED)

	if animation_player and animation_player.has_animation("select1"):
		animation_player.play("select1")
	else:
		_change_scene_to_target()

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "select1":
		_change_scene_to_target()

func _change_scene_to_target() -> void:
	call_deferred("_perform_scene_change")

func _perform_scene_change() -> void:
	var tree = get_tree()
	if tree == null:
		return

	if target_scene_path.is_empty():
		return

	if not ResourceLoader.exists(target_scene_path):
		return

	tree.change_scene_to_file(target_scene_path)
