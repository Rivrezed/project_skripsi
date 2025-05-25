@tool
extends BTAction
@export var max_distance : float = 200.0

var npc : NPC
var rng : RandomNumberGenerator

func _generate_name() -> String:
	return "nav to new point %s to left right to where chara is" %max_distance

func _setup() -> void:
	npc = agent as NPC
	rng = RandomNumberGenerator.new()

func _enter() -> void:
	npc.navigation.target_position = pick_destination()

func _tick(_delta: float) -> Status:
	if npc.navigation.is_navigation_finished():
		return SUCCESS

	if not npc.navigation.is_target_reachable():
		return FAILURE

	move()

	return RUNNING

## Choose a new point to navigate the NPC to
func pick_destination() -> Vector2:
	var current_position = npc.get_global_position()
	var offset = rng.randf_range(-max_distance, max_distance)
	var new_destination = Vector2(
		current_position.x + offset,
		current_position.y
	)
	return new_destination

func move():
	var next_path = npc.navigation.get_next_path_position()
	var move_direction = Vector2(
		npc.global_position.direction_to(next_path).x,
	0
)
	
	var new_velocity = move_direction * npc.stats.run_speed
	npc.velocity = new_velocity
	npc.move_and_slide()
