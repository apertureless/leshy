extends "res://Props/checkpoint/Checkpoint.gd"

onready var anim = $AnimatedSprite
	
func _enable_light() -> void:
	pass
	
func _set_active_state() -> void:
	pass

func _play_enter_animation() -> void:
	print("playing enter")
	if anim != null:
		anim.play("appear")
	
func _play_active_animation() -> void:
	print("playing active")
	anim.play("active")
	
func _play_default_animation() -> void:
	#anim.play("inactive")
	pass

func _on_AnimatedSprite_animation_finished() -> void:
	if anim.animation == "appear":
		_play_active_animation()
		$Light2D.enabled = true
		is_active = true
