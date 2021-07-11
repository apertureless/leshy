extends Level

func _ready() -> void:
	var t = Timer.new()
	t.wait_time = 0.5
	t.one_shot = true
	t.connect("timeout", self, "_connect_areas")
	add_child(t)
	t.start()
	
func _connect_areas() -> void:
	var _ret = $StartingPosition.connect("body_entered", self, "_on_entering_starting_area")
	_ret = $FinishingPosition.connect("body_entered", self, "_on_entering_finish_area")

func _on_entering_starting_area(_body) -> void:
	Gamestate.state.current_level = "res://zones/fox_house/stage-01.tscn"
	Gamestate.state.current_position = "FinishingPosition"
	Gamestate.state.current_dir = 1
	Game.main.load_gamestate()
	
func _on_entering_finish_area(_body) -> void:
	Gamestate.state.current_level = "res://zones/fox_house/stage-01.tscn"
	Gamestate.state.current_position = "StartingPosition"
	Gamestate.state.current_dir = 1
	Game.main.load_gamestate()
