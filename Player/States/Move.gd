extends State

## Parent state that handles basic movement

export var max_speed_default := Vector2(500.0, 900.0)
export var acceleration_default := Vector2(100000, 3000.0)
export var jump_impulse := 900.0
export var small_jump_factor := 0.5
export var max_fall_speed := 300.0

var acceleration := acceleration_default
var max_speed := max_speed_default
var velocity := Vector2.ZERO
var dash_count := 0
var dash_direction := Vector2.ZERO

func unhandled_input(event: InputEvent) -> void:
	if owner.is_on_floor() and event.is_action_pressed("jump"):
		_state_machine.transition_to("Move/Air", { impulse = jump_impulse })
	
func physics_process(delta: float) -> void:
	var _dir = get_movement_direction()
	velocity = calculate_velocity(
		velocity,
		max_speed,
		acceleration,
		delta,
		_dir,
		max_fall_speed
	)
	
	# Flip sprite 
	if _dir.x != 0.0:
		dash_direction = _dir
		owner.ledge_detector.scale.x = sign(_dir.x)
		owner.skin.set_flip_h(_dir.x > 0)
		
	velocity = owner.move_and_slide(velocity, owner.FLOOR_NORMAL)
	Events.emit_signal("player_moved", owner)

static func calculate_velocity(
	old_velocity: Vector2, 
	max_speed: Vector2,
	acceleration: Vector2,
	delta: float,
	move_direction: Vector2,
	max_speed_fall := 1500.0
) -> Vector2:
	var new_velocity := old_velocity
	new_velocity += move_direction * acceleration * delta
	new_velocity.x = clamp(new_velocity.x, -max_speed.x, max_speed.x)
	new_velocity.y = clamp(new_velocity.y, -max_speed.y, max_speed_fall)
	
	return new_velocity

static func get_movement_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		1.0
	)

func enter(msg: Dictionary = {}) -> void:
	$Air.connect("jumped", $Idle.jump_delay, "start")
	
func exit() -> void:
	$Air.disconnect("jumped", $Idle.jump_delay, "start")
