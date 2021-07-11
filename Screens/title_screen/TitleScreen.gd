extends Control

var scene_path : String 
onready var fade = $FadeIn

func _ready() -> void:
	# Grab focus, so menu can be used with keyboard
	$Menu/CenterRow/Buttons/NewGameButton.grab_focus()
	
	for button in $Menu/CenterRow/Buttons.get_children():
		button.connect("pressed", self, "on_Button_pressed", [button.scene_to_load])
		

func on_Button_pressed(scene: String) -> void:
	# Need to somehow assert scene name to check if its even there before trying to
	# load
	#	assert(anim_name in animation_player.get_animation_list())
	if scene != "":
		scene_path = scene
		fade.show()
		fade.fade_in()
	else:
		get_tree().quit()


func _on_FadeIn_fade_finished() -> void:
	start_new_game()
		

func start_new_game():
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
