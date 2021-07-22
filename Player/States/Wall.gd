extends State

export var slide_acceleration := 400.0
export var max_slide_speed := 150.0
export(float, 0.0, 1.0) var friction_factor := 0.15
export var jump_strength:= Vector2(300.0, 600.0)

var _wall_normal := -1.0
var _velocity := Vector2.ZERO
var particle_timer := 0.05

func unhandled_input(event: InputEvent) -> void:
	var move = get_parent()
	if event.is_action_pressed("jump"):
		jump()
		
	if event.is_action_released("wall_slide"):
		move.is_wall_sliding = false

func physics_process(delta: float) -> void:
	var move = get_parent()
	var dir = 1 if move.get_movement_direction().x > 0.0 else -1
	if _velocity.y > max_slide_speed:
		_velocity.y = lerp(_velocity.y, max_slide_speed, friction_factor)
	else:
		_velocity.y += slide_acceleration * delta
	
	particle_timer -= delta
	if particle_timer <= 0:
		particle_timer = 0.2
		var p = preload("res://Player/Dust/WallSlide.tscn").instance()
		p.position = owner.global_position + Vector2( 4 * dir, 0 )
		p.scale.x = dir
		owner.get_parent().add_child( p )
	#_velocity.y = clamp(_velocity.y, -max_slide_speed, max_slide_speed)
	_velocity = owner.move_and_slide(_velocity, owner.FLOOR_NORMAL)
	
	if owner.is_on_floor():
		_state_machine.transition_to("Move/Idle")
		

	var is_moving_away_from_wall := sign(move.get_movement_direction().x) == sign(_wall_normal)
	
	if is_moving_away_from_wall or not owner.ledge_detector.is_against_wall():
		_state_machine.transition_to("Move/Air", { velocity = _velocity })
		
#	if owner.ledge_detector.is_against_ledge():
#		_state_machine.transition_to("Ledge", { move_state = move, velocity = _velocity })

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
