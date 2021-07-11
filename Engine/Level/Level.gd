class_name Level
extends Node

onready var player := $Player
onready var player_camera := $Player/Camera2D
onready var tiles := $GroundTiles

func _ready() -> void:
	_set_camera()
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_spawn"):
		var err = get_tree().reload_current_scene()
		if err:
			print("Error reloading current scene")
		
	if event.is_action_pressed("exit"):
		var err = get_tree().change_scene("res://Screens/title_screen/TitleScreen.tscn")
		if err:
			print("Error changing to title screen")

func _set_camera() -> void:
	var map_limits = tiles.get_used_rect()
	var map_cell_size = tiles.cell_size
	
	player_camera.limit_left = map_limits.position.x * map_cell_size.x
	player_camera.limit_right = map_limits.end.x * map_cell_size.x
	player_camera.limit_top = map_limits.position.y * map_cell_size.y
	player_camera.limit_bottom = map_limits.end.y * map_cell_size.y
	
func _set_player() -> void:
	if player == null:
		print("Player not found in this scene")
		
	# Check in global game state if theres a current position saved
	# WIP need to implement global game state
	
	var start_position = find_node("StartingPosition")
	
	if start_position == null:
		print("Starting Position not found")
	else:
		player.global_position = start_position.global_position
