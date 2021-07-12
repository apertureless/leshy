extends Area2D

var is_active: bool = false

func _ready() -> void:
	$Sprite.frame = 0
	if Gamestate.state.active_checkpoint[0] == name and \
		Gamestate.state.active_checkpoint[1] == owner.filename:
			activate_checkpoint()
	
func activate_checkpoint() -> void:
	print("Activating checkpoint")
	if is_active:
		$Sprite.frame = 1;
		$Light2D.enabled = true
	else:
		$Sprite.frame = 1;
		$Light2D.enabled = true
		is_active = true


func _on_Checkpoint_body_entered(body: Node) -> void:
	activate_checkpoint()
	Gamestate.state.active_checkpoint[0] = name
	Gamestate.state.active_checkpoint[1] = owner.filename
	Gamestate.state.current_position = Gamestate.state.active_checkpoint[0]
	Gamestate.state.current_level = Gamestate.state.active_checkpoint[1]
	
	Gamestate.save_gamestate()
