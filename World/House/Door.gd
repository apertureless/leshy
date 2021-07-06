extends Area2D

export(PackedScene) var target_scene

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("move_up"):
		print("move up")
		print(get_overlapping_bodies().size())
		if target_scene and get_overlapping_bodies().size() > 0:
			next_level(target_scene)
			
func next_level(scene):
	get_tree().change_scene_to(scene)
