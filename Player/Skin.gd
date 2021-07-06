extends Node2D

signal animation_finished(anim_name)

onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var sprite: Sprite = $Sprite

func _ready() -> void:
	animation_player.connect("animation_finished", self, "_on_AnimationPlayer_animation_finished")

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	emit_signal("animation_finished", anim_name)
	
func play(anim_name: String, data: Dictionary = {}) -> void:
	assert(anim_name in animation_player.get_animation_list())
	
	if "from" in data:
		position = data.from
	animation_player.stop()
	animation_player.play(anim_name)

func set_flip_h(value: bool) -> void: 
	sprite.flip_h = value
