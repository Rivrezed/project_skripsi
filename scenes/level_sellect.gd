# SceneTransitionArea.gd
extends Area2D

@export var target_scene: PackedScene
@export var target_player_name: StringName = &"Player" # Gunakan StringName untuk nama player
@export var delay_before_transition: float = 0.0
@export var disable_area_after_trigger: bool = true

var _is_triggered: bool = false

func _ready():
	monitoring = true
	set_process_mode(Node.PROCESS_MODE_PAUSABLE)
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D):
	# Mengubah kondisi pemeriksaan dari grup menjadi nama node
	if _is_triggered or not (body.name == target_player_name):
		return

	_is_triggered = true

	if disable_area_after_trigger:
		set_deferred("monitoring", false)
		set_deferred("monitorable", false)

	if delay_before_transition > 0:
		print("Player entered! Delaying scene transition by %s seconds..." % delay_before_transition)
		await get_tree().create_timer(delay_before_transition).timeout

	_change_scene()

func _change_scene():
	if target_scene == null:
		print("Error: Target scene PackedScene is not assigned for SceneTransitionArea!")
		return

	print("Changing scene using PackedScene...")
	get_tree().change_scene_to_packed(target_scene)
