extends State

func enter(msg: Dictionary = {}) -> void:
	print("ledge State")
	assert("move_state" in msg and msg.move_state is State)
	
	owner.skin.connect(
		"animation_finished", 
		self, 
		"_on_Skin_animation_finished",
		[],
		CONNECT_DEFERRED
	)
	
	var start: Vector2 = owner.global_position
	var ld: LedgeWallDetector = owner.ledge_detector
	owner.global_position = ld.get_top_global_position() + ld.get_cast_to_direction()
	owner.global_position = owner.floor_detector.get_floor_position()
	
	# Reset vertical velocity but preserve horizontal velocity
	msg.move_state.velocity.y = 0.0
	owner.skin.play("ledge", { from = start - owner.global_position})
	
func exit() -> void:
	owner.skin.disconnect("animation_finished", self, "_on_Skin_animation_finished")
	
func _on_Skin_animation_finished(name: String) -> void:
	if name == "ledge":
		_state_machine.transition_to("Move/Run")
