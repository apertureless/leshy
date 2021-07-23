extends Camera2D
	
export(int) var tile_size = 16

func _physics_process(delta: float) -> void:
	var player = get_node("../Player")

	global_position = player.global_position.round()
	offset.y = -tile_size*3
	
	force_update_scroll()
