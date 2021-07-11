extends Node

signal gamestate_changed

var state := {} setget _set_state
var saved_state := {}

var debug_state = {
	"active_checkpoint": ["", ""],
	"current_level": "res://zones/fox_house/stage-01.tscn",
	"current_position": "StartingPosition",
	"current_dir": 1,
	"can_double_jump": true,
	"can_wall_jump": true,
	"can_dash": true
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
		"can_dash": true
	}

# Save gamestate to file?
func _save_gamestate() -> bool:
	pass
	return true

# Load gamestate from file
func _load_gamestate() -> Dictionary:
	return {}
