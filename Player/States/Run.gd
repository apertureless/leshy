extends State
## Horizontal movement on the ground

func unhandled_input(event: InputEvent) -> void:
	get_parent().unhandled_input(event)

func physics_process(delta: float) -> void:
	var move = get_parent()
	
	if owner.is_on_floor():
		if move.get_movement_direction().x == 0.0:
			_state_machine.transition_to("Move/Idle")
	else: 
		_state_machine.transition_to("Move/Air")
		
	move.physics_process(delta)
	
func enter(msg: Dictionary = {}) -> void:
	owner.skin.play("move_left")
	get_parent().enter(msg)
	
# Exit a state
func exit() -> void:
	get_parent().exit()

