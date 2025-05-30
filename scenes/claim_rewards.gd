extends Area2D

@export var player_node: NodePath
@export var scene_to_open: PackedScene
@export var trigger_once: bool = false  # Bisa diatur di Inspector

var _has_been_triggered := false

func _ready():
	connect("body_entered", _on_body_entered)

func _on_body_entered(body: Node) -> void:
	if trigger_once and _has_been_triggered:
		return  # Jika hanya boleh sekali, dan sudah pernah dipicu

	var player = get_node(player_node)
	if body == player and scene_to_open:
		_has_been_triggered = true
		var scene_instance = scene_to_open.instantiate()
		call_deferred("_spawn_scene", scene_instance)
	elif body == player:
		push_error("Scene belum diatur di inspector.")

func _spawn_scene(scene_instance: Node) -> void:
	get_tree().current_scene.add_child(scene_instance)
