extends Area2D

onready var anim = $AnimationPlayer
onready var cooldown = $Gracetimer


func _on_Shrooms_body_entered(body: Node) -> void:
	anim.play("hide")


func _on_Shrooms_body_exited(body: Node) -> void:
	cooldown.start()


func _on_Gracetimer_timeout() -> void:
	anim.play("show")

func _finish_animation() -> void:
	anim.stop()
