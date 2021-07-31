extends Node

signal gamestate_changed

var state := {} setget _set_state
var saved_state := {}
# Save File
var _fname := "gamestate.dat"
var first_start := true

var debug_state = {
	"active_checkpoint": ["", ""],
	"current_level": "res://zones/mystic/stage-01.tscn",
	"current_position": "StartingPosition",
	"current_dir": 1,
	"can_double_jump": true,
	"can_wall_jump": true,
	"can_dash": true,
	"can_ledge": false,
	"life": 3,
	"max_life": 3
}  

func _ready() -> void:
	initiate()
	
func initiate() -> void:
	state = _get_initial_gamestate()
	saved_state = state.duplicate(true)
	
func _set_state(value) -> void:
	state = value
	emit_signal("gamestate_changed")
	
func _get_initial_gamestate() -> Dictionary:
	# Checkpoint will contain the current_pos and current_level
	if Game.debug:
		return debug_state
	return {
		"active_checkpoint": ["", ""],
		"current_level": "",
		"current_position": "",
		"current_dir": 1,
		"can_double_jump": true,
		"can_wall_jump": true,
		"can_dash": true,
		"can_ledge": false,
		"life": 3,
		"max_life": 3
	}

# Public save gamestate function
func save_gamestate() -> bool:
	return _save_gamestate()

# Save gamestate to file?
func _save_gamestate() -> bool:
	saved_state = state.duplicate(true)
	var f := File.new()
	var err := f.open_encrypted_with_pass(_fname, File.WRITE, OS.get_unique_id())
	
	if err == OK:
		f.store_var(state)
		f.close()
		return true
	else:
		f.close()
		return false

# Public load gamestate method
func load_gamestate() -> bool:
	var saved = _load_gamestate()
	
	# Save File is empty
	if saved.empty():
		# Check if backup state is empty
		if !saved_state.empty():
			state = saved_state.duplicate(true)
		else:
			state = _get_initial_gamestate()
			saved_state = state.duplicate(true)
	
	state = saved
	saved_state = state.duplicate(true)
	first_start = false
	return true
	
# Load gamestate from file
func _load_gamestate() -> Dictionary:
	var f := File.new()
	
	if not f.file_exists(_fname):
		return {}
	
	var err := f.open_encrypted_with_pass(_fname, File.READ, OS.get_unique_id())
	
	if err != OK:
		f.close()
		return {}
	
	var data = f.get_var()
	f.close()
	
	return data

func has_gamestate_file() -> bool:
	var tmp = _load_gamestate()
	
	return !tmp.empty()

