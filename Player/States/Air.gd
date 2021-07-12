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
onready var controls_freeze: Timer = $ControlsFreeze

var jump_count := 0

func unhandled_input(event: InputEvent) -> void:
	var move = get_parent()

	# Dash 
	if move.dash_count == 0 and event.is_action_pressed("dash"):
		move.dash_count += 1
		_state_machine.transition_to("Move/Dash", { 
			direction = Vector2(move.dash_direction.normalized().x, 0.0)
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
	
	# Overwrite the jump direction if we are on the wall
	# To prevent climbing up with jumps
	var direction: Vector2 = move.get_movement_direction() if controls_freeze.is_stopped() else Vector2(sign(move.velocity.x), 1.0)
	
	move.velocity = move.calculate_velocity(
		move.velocity,
		move.max_speed,
		move.acceleration,
		delta,
		direction,
		move.max_fall_speed
	)
	
#
#	# Flip sprite 
	if direction.x != 0.0:
		move.dash_direction = direction
		owner.skin.set_flip_h(direction.x > 0)
		owner.ledge_detector.scale.x = sign(direction.x)

	move.velocity = owner.move_and_slide(move.velocity, owner.FLOOR_NORMAL)
	Events.emit_signal("player_moved", owner)
	
	#move.physics_process(delta)
	
	if move.velocity.y >= 0.0:
		owner.skin.play("jump_down")
	
	# Landing on floor
	if owner.is_on_floor():
		move.dash_count = 0
		# Fucking weird way of doing ternary operations, without ternary operators
		var target_state := "Move/Idle" if move.get_movement_direction().x == 0.0 else "Move/Run"
		_state_machine.transition_to(target_state)
		
	elif owner.ledge_detector.is_against_ledge():
		_state_machine.transition_to("Ledge", { move_state = move })
		
	if owner.is_on_wall():
		# Direction of the wall. If we are colliding
		# with a wall in front us or behind us.
		var wall_normal: float = owner.get_slide_collision(0).normal.x
		_state_machine.transition_to(
			"Move/Wall", 
			{ 
				normal = wall_normal,
				velocity = move.velocity
			}
		)

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
	
	if "wall_jump" in msg:
		controls_freeze.start()
		move.max_speed.x = max(move.max_speed_default.x, abs(move.velocity.x))
		move.acceleration.y = move.acceleration_default.y
		
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
