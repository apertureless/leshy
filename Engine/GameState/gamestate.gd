extends Node

signal gamestate_changed

var state := {} setget _set_state
var saved_state := {}

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
	#saved_state.state.duplicate(true)
	
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
	pass
	return true

# Public load gamestate method
func load_gamestate() -> Dictionary:
	return _load_gamestate()
	
# Load gamestate from file
func _load_gamestate() -> Dictionary:
	return {}
