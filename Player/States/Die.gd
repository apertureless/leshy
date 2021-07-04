extends State

func _ready() -> void:
	yield(owner, "ready")
	

func _on_Skin_animation_finished(anim_name: String) -> void:
	_state_machine.transition_to("Spawn")
	 
func enter(msg: Dictionary = {}) -> void:
	owner.is_active = false
	owner.skin.play("die")
	owner.skin.connect("animation_finished", self, "_on_Skin_animation_finished")

func exit() -> void: 
	owner.is_active = true
	owner.skin.disconnect("animation_finished", self, "_on_Skin_animation_finished")
