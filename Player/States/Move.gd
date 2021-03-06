extends State

## Parent state that handles basic movement

export var max_speed_default := Vector2(500.0, 900.0)
export var acceleration_default := Vector2(100000, 3000.0)
export var jump_impulse := 900.0
export var small_jump_factor := 0.5
export var max_fall_speed := 280.0

var acceleration := acceleration_default
var max_speed := max_speed_default
var velocity := Vector2.ZERO
var dash_count := 0
var dash_direction := Vector2.ZERO
var is_wall_sliding := false

func unhandled_input(event: InputEvent) -> void:
	if owner.is_on_floor() and event.is_action_pressed("jump"):
		_state_machine.transition_to("Move/Air", { impulse = jump_impulse, dust = true })
		owner.play_jump()
	
			
	if Gamestate.state.can_wall_jump && event.is_action_pressed("wall_slide"):
		is_wall_sliding = true
		
	if event.is_action_released("wall_slide"):
		is_wall_sliding = false
		
	
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
		owner.ledge_detector.scale.x = 1 if _dir.x > 0.0 else -1
		owner.skin.set_flip_h(_dir.x > 0)
		
	velocity = owner.move_and_slide(velocity, owner.FLOOR_NORMAL)
	Events.emit_signal("player_moved", owner)

static func calculate_velocity(
	old_velocity: Vector2, 
	max_speed: Vector2,
	acceleration: Vector2,
	delta: float,
	move_direction: Vector2,
	max_speed_fall := 280.0
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


func _run_dust() -> void:
	var d = preload("res://Player/Dust/Run.tscn").instance()
	var dir = get_movement_direction()
	d.scale.x = 1 if dir.x > 0.0 else -1
	d.position = owner.global_position
	owner.get_parent().add_child(d)
	
func _on_Skin_run_dust() -> void:
	_run_dust()
