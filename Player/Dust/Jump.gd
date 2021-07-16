extends Sprite

var jump_type := 0

func _ready() -> void:
	$Anim.play("dust_" + str(jump_type))
