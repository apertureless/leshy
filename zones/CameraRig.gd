extends Camera2D
	
export(int) var tile_size = 16
export(float, 0, 1, 0.05) var lerp_vertical_up = 0.05
export(float, 0, 1, 0.05) var lerp_vertical_down = 0.25


func _physics_process(delta: float) -> void:
	# Get player node and player state to access velocity
	var player = get_node("../Player")
	var player_state = get_node("../Player/StateMachine/Move")
	
	# Lerp speed vertical
	var lerp_speed_v = lerp_vertical_up
	# Lerp speed horizontal
	var lerp_speed_h = 0.05
	
	# If player is falling increase the vertical speed
	if player_state.velocity.y >= player_state.max_fall_speed:
		lerp_speed_v = lerp_vertical_down

	# Set different lerps for vertical and horizontal
	global_position.x = lerp(global_position.x, player.global_position.round().x, lerp_speed_h)
	global_position.y = lerp(global_position.y, player.global_position.round().y, lerp_speed_v)

	# Offet to center vertically a bit
	offset.y = -tile_size*3
	
	force_update_scroll()
