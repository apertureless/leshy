extends Control

onready var fade = $FadeIn

func _ready() -> void:
	# Grab focus, so menu can be used with keyboard
	$Menu/CenterRow/Buttons/NewGameButton.grab_focus()
	
	for button in $Menu/CenterRow/Buttons.get_children():
		button.connect("pressed", self, "on_Button_pressed", [button.name])
		
	if !Gamestate.first_start:
		_enable_continue_button()
		
	elif Gamestate.has_gamestate_file():
		Gamestate.load_gamestate()
		Gamestate.state.current_position = Gamestate.state.active_checkpoint[0]
		Gamestate.state.current_level = Gamestate.state.active_checkpoint[1]
		
		_enable_continue_button()


func on_Button_pressed(item_num) -> void:
	print(item_num)
	
	match item_num:
		"NewGameButton":
			start_new_game()
		"ContinueButton":
			continue_game()
		"OptionsButton":
			print("options")
		"ExitButton":
			quit_game()

func _on_FadeIn_fade_finished() -> void:
	start_new_game()
		


func start_new_game() -> void:
	Gamestate.initiate()
	Gamestate.state.current_level = "res://zones/fox_house/stage-01.tscn"
	Gamestate.state.current_position = "StartingPosition"
	Gamestate.state.current_dir = 1
	Gamestate.state.active_checkpoint = [ \
		Gamestate.state.current_position, \
		Gamestate.state.current_level ]
	
	# save the new game, overlapping the old one
	# var _ret = Gamestate.save_gamestate()
	
	Game.main.load_gamestate()

func continue_game() -> void:
	Game.main.load_gamestate()

func quit_game() -> void:
	get_tree().quit()

func _enable_continue_button() -> void:
	$Menu/CenterRow/Buttons/ContinueButton.disabled = false
	$Menu/CenterRow/Buttons/ContinueButton.focus_mode = FOCUS_ALL
