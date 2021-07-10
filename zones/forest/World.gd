extends Node2D

onready var player := $Player
onready var player_camera := $Player/Camera2D
onready var tiles := $GroundTiles

func _ready() -> void:
	set_camera_limits()
	
func _unhandled_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("debug_spawn"):
		var err = get_tree().reload_current_scene()
		if err:
			print("Error reloading current scene")
		
	if event.is_action_pressed("exit"):
		var err = get_tree().change_scene("res://Screens/title_screen/TitleScreen.tscn")
		if err:
			print("Error changing to title screen")

func set_camera_limits() -> void:
	var map_limits = tiles.get_used_rect()
	var map_cell_size = tiles.cell_size
	
	player_camera.limit_left = map_limits.position.x * map_cell_size.x
	player_camera.limit_right = map_limits.end.x * map_cell_size.x
	player_camera.limit_top = map_limits.position.y * map_cell_size.y
	player_camera.limit_bottom = map_limits.end.y * map_cell_size.y
