#state_label.gd
extends Label

@export var limbo_hsm : LimboHSM :
	set(value):
		if limbo_hsm !=null:
			limbo_hsm.active_state_changed.disconnect(_on_active_state_changed)
			
		limbo_hsm = value
		
		if limbo_hsm !=null:
			var currect_state = limbo_hsm.get_active_state()
			
			if currect_state !=null:
				text = currect_state.name
				
			limbo_hsm.active_state_changed.connect(_on_active_state_changed)
# Called when the node enters the scene tree for the first time.

func _on_active_state_changed(current : LimboState, _previous : LimboState):
	text = current.name
