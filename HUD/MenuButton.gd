extends Button

func _process(delta: float) -> void:
	if disabled:
		$Label.add_color_override("font_color", Color(1,1,1,0.5))
	else: 
		$Label.add_color_override("font_color", Color(1,1,1,1))
