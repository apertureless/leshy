extends State

## Air state manages all movement and landing in the air.
## Optional msg:
## {
##   velocity: Vector2, to preserve movement from the previous state
##   impulse: float, to make the character jump
## }

signal jumped
export var acceleration_x := 5000.0
export var max_jump_count := 1

onready var jump_delay: Timer = $JumpDelay

var jump_count := 0

func unhandled_input(event: InputEvent) -> void:
	var move = get_parent()

	# Dash 
	if move.dash_count == 0 and event.is_action_pressed("dash"):
		move.dash_count += 1
		_state_machine.transition_to("Move/Dash", { 
			direction = Vector2(move.get_movement_direction().normalized().x, 0.0)
		})
		return
		
	# Jump Delay
	if event.is_action_pressed("jump"):
		if move.velocity.y >= 0.0 and jump_delay.time_left > 0:
			jump()
		elif jump_count < max_jump_count:
			jump()
		emit_signal("jumped")
	if event.is_action_released("jump"):
		cut_jump()
	else:
		move.unhandled_input(event)

func physics_process(delta: float) -> void:
	var move = get_parent()
	move.physics_process(delta)
	
	if move.velocity.y >= 0.0:
		owner.skin.play("jump_down")
	
	if owner.is_on_floor():
		move.dash_count = 0
		# Fucking weird way of doing ternary operations, without ternary operators
		var target_state := "Move/Idle" if move.get_movement_direction().x == 0.0 else "Move/Run"
		_state_machine.transition_to(target_state)
	
func enter(msg: Dictionary = {}) -> void:
	var move = get_parent()
	move.enter(msg)
	move.acceleration.x = acceleration_x
	owner.skin.play("jump_up")
	
	if "velocity" in msg:
		move.velocity = msg.velocity
		move.max_speed.x = max(abs(msg.velocity.x), move.max_speed_default.x)
	
	if "impulse" in msg:
		move.velocity = calculate_jump_velocity(msg.impulse)
	
	else:
		jump_count += 1
		
	jump_delay.start()
	
# Exit a state
func exit() -> void:
	var move = get_parent()
	move.acceleration = move.acceleration_default
	jump_count = 0
	move.exit()

func calculate_jump_velocity(impulse := 0.0) -> Vector2:
	var move = get_parent()
	return move.calculate_velocity(
		move.velocity,
		move.max_speed,
		Vector2(0.0, impulse),
		1.0,
		Vector2.UP,
		move.max_fall_speed
	)

func jump() -> void:
	var move = get_parent()
	move.velocity = Vector2.ZERO
	move.velocity = calculate_jump_velocity(move.jump_impulse)
	jump_count += 1
	
func cut_jump() -> void:
	var move = get_parent()
	if move.velocity.y < -100:
		move.velocity = Vector2.ZERO
		move.velocity = calculate_jump_velocity(move.jump_impulse * move.small_jump_factor)
