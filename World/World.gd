extends Node2D

onready var player := $Player

func _unhandled_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("debug_spawn"):
		get_tree().reload_current_scene()
		
	if event.is_action_pressed("exit"):
		get_tree().change_scene("res://Scenes/TitleScreen.tscn")
