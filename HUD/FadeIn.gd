extends ColorRect

signal fade_finished

onready var anim = $AnimationPlayer

func fade_in(): 
	anim.play("fade_in")

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	emit_signal("fade_finished")
