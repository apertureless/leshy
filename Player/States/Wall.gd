extends State

export var slide_acceleration := 400.0
export var max_slide_speed := 150.0
export(float, 0.0, 1.0) var friction_factor := 0.15
export var jump_strength:= Vector2(300.0, 600.0)

var _wall_normal := -1.0
var _velocity := Vector2.ZERO

func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		jump()

func physics_process(delta: float) -> void:
	if _velocity.y > max_slide_speed:
		_velocity.y = lerp(_velocity.y, max_slide_speed, friction_factor)
	else:
		_velocity.y += slide_acceleration * delta
	#_velocity.y = clamp(_velocity.y, -max_slide_speed, max_slide_speed)
	_velocity = owner.move_and_slide(_velocity, owner.FLOOR_NORMAL)
	
	if owner.is_on_floor():
		_state_machine.transition_to("Move/Idle")
		
	var move = get_parent()
	var is_moving_away_from_wall := sign(move.get_movement_direction().x) == sign(_wall_normal)
	
	if is_moving_away_from_wall or not owner.ledge_detector.is_against_wall():
		_state_machine.transition_to("Move/Air", { velocity = _velocity })
		
	if owner.ledge_detector.is_against_ledge():
		_state_machine.transition_to("Ledge", { move_state = move, velocity = _velocity })

func enter(msg: Dictionary = {}) -> void:
	var move = get_parent()
	move.enter(msg)
	
	_wall_normal = msg.normal
	if msg.velocity.y < 0.0:
		_velocity.y = 0
	else:
		_velocity.y = max(msg.velocity.y, -max_slide_speed)

func exit() -> void:
	get_parent().exit()

func jump() -> void:
	var impulse := Vector2(_wall_normal, -1.0) * jump_strength
	var msg := {
		velocity = impulse,
		wall_jump = true
	}
	
	_state_machine.transition_to("Move/Air", msg)
