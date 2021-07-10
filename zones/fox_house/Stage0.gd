extends Node2D


func _ready() -> void:
	set_camera_limits()
	
func set_camera_limits() -> void:
	var map_limits = tiles.get_used_rect()
	var map_cell_size = tiles.cell_size
	
	player_camera.limit_left = map_limits.position.x * map_cell_size.x
	player_camera.limit_right = map_limits.end.x * map_cell_size.x
	player_camera.limit_top = map_limits.position.y * map_cell_size.y
	player_camera.limit_bottom = map_limits.end.y * map_cell_size.y
