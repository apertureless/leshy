extends Camera2D
	

func _physics_process(delta: float) -> void:
	var player = get_node("../Player")

	global_position = player.global_position.round()
	force_update_scroll()
