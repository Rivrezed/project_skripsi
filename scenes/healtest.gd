class_name HealingArea
extends Area2D

@export var heal_amount: int = 1
@export var heal_cooldown: float = 0.5
@export var disable_on_heal: bool = false

var _can_heal: bool = true

func _ready():
	monitoring = true
	monitorable = false
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D):
	var health_node: Health = _get_health_node_from_body(body)

	if health_node != null:
		_apply_heal(health_node)

func _apply_heal(health_node: Health):
	if not _can_heal:
		return

	if health_node.get_health() < health_node.get_max_health():
		health_node.set_health(health_node.get_health() + heal_amount)

		# Tampilkan popup +heal_amount di posisi Area2D (HealingArea)
		if has_node("/root/Damagenumber"):
			var damage_number = get_node("/root/Damagenumber")
			var position = self.global_position  # posisi Area2D healingnya
			damage_number.display_number(heal_amount, position, false, true)

		if disable_on_heal:
			set_deferred("monitoring", false)
			print("HealingArea disabled after healing.")
		else:
			_start_cooldown()



func _start_cooldown():
	_can_heal = false
	var cooldown_timer = get_tree().create_timer(heal_cooldown)
	cooldown_timer.timeout.connect(func(): _can_heal = true)

func _get_health_node_from_body(body: Node) -> Health:
	if body == null:
		return null

	if body is Health:
		return body as Health

	for child in body.get_children():
		if child is Health:
			return child as Health

	for child in body.get_children():
		var found_health: Health = _get_health_node_from_body(child)
		if found_health != null:
			return found_health

	return null
