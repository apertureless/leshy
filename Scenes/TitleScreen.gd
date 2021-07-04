extends Control

var scene_path : String 
onready var fade = $FadeIn

func _ready() -> void:
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
	if scene_path != "":
		get_tree().change_scene(scene_path)
