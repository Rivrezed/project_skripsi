#limbo_hsm.gd
extends LimboHSM
## State machine for player character

@export var character : CharacterBody2D
@export var states : Dictionary[String, LimboState]

func _ready() -> void:
	_binding_setup()
	initialize(character)
	set_active(true)

func _binding_setup():
	add_transition(states["ground"], states["air"], "in_air")
	add_transition(states["air"], states["ground"], "on_ground")
	add_transition(states["ground"], states["air"], "jump")
	add_transition(states["attack"], states["air"], "jump")
	add_transition(states["ground"], states["attack"], "attack")
	add_transition(states["air"], states["air_attack"], "attack")
	add_transition(states["attack"], states["ground"], "finished")
	add_transition(states["air_attack"], states["air"], "finished")
	add_transition(states["air_attack"], states["ground"], "on_ground")
