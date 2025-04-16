extends LimboHSM
## State machine for player character

@export var character : CharacterBody2D
@export var states : Dictionary[String, LimboState]

func _ready() -> void:
	_binding_setup()
	initialize(character)
	set_active(true)

func _binding_setup():
	add_transition(states["idle"], states["move"], "moving")
	add_transition(states["move"], states["idle"], "stopped")
 
