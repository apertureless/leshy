extends Node2D

onready var player := $Player
onready var player_camera := $Player/Camera2D
onready var tiles := $GroundTiles

func _ready() -> void:
	set_camera_limits()
	
func _unhandled_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("debug_spawn"):
		get_tree().reload_current_scene()
		
	if event.is_action_pressed("exit"):
		get_tree().change_scene("res://Scenes/TitleScreen.tscn")

func set_camera_limits() -> void:
	var map_limits = tiles.get_used_rect()
	var map_cell_size = tiles.cell_size
	
	player_camera.limit_left = map_limits.position.x * map_cell_size.x
	player_camera.limit_right = map_limits.end.x * map_cell_size.x
	player_camera.limit_top = map_limits.position.y * map_cell_size.y
	player_camera.limit_bottom = map_limits.end.y * map_cell_size.y
