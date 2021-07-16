class_name Level
extends Node

onready var player := $Player
onready var player_camera := $Player/Camera2D
onready var tiles := $GroundTiles

func _ready() -> void:
	call_deferred( "_set_player" )
	call_deferred( "_set_camera" )
	
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
	
	player_camera.limit_left = (map_limits.position.x * map_cell_size.x) + map_cell_size.x
	player_camera.limit_right = map_limits.end.x * map_cell_size.x
	player_camera.limit_top = map_limits.position.y * map_cell_size.y
	player_camera.limit_bottom = map_limits.end.y * map_cell_size.y
	
func _set_player() -> void:
	print("Setting player position")
	if player == null:
		print("Player not found in this scene")
		return
	
	if Gamestate.state.keys().find("current_position") != -1 and \
		not Gamestate.state.current_position.empty():
			var start_pos = find_node(Gamestate.state.current_position)
			if start_pos == null:
				print("Start position not found")
			else:
				if Game.debug: print("Level start at", start_pos.name)
				player.global_position = start_pos.global_position
	
	else:
		var start_position = find_node("StartingPosition")
		
		if start_position == null:
			print("Starting Position not found")
		else:
			player.global_position = start_position.global_position
			
	player.connect( "player_dead", self, "_on_player_dead" )
			
func _on_player_dead() -> void:
	if Game.main == null:
		var _ret = get_tree().reload_current_scene()
	else:
		var _ret = Gamestate.load_gamestate()
		Gamestate.state.current_position = Gamestate.state.active_checkpoint[0]
		Gamestate.state.current_level = Gamestate.state.active_checkpoint[1]
		
		Game.main.load_gamestate()
