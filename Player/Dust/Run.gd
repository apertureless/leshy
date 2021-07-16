extends Sprite

func _ready() -> void:
	var r := randi() % 3
	$Anim.play("dust_" + str(r))
