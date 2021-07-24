extends Area2D

var is_active: bool = false

func _ready() -> void:
	_play_default_animation()
	if Gamestate.state.active_checkpoint[0] == name and \
		Gamestate.state.active_checkpoint[1] == owner.filename:
			activate_checkpoint()
	
func activate_checkpoint() -> void:
	print("Activating checkpoint")
	if is_active:
		_play_active_animation()
		_enable_light()
	else:
		_play_enter_animation()
		_enable_light()
		_set_active_state()

func _play_enter_animation() -> void:
	$Sprite.frame = 1
	
func _play_active_animation() -> void:
	$Sprite.frame = 1

func _play_default_animation() -> void:
	$Sprite.frame = 1
	
func _enable_light() -> void:
	$Light2D.enabled = true
	
func _set_active_state() -> void:
	is_active = true

func _on_Checkpoint_body_entered(body: Node) -> void:
	activate_checkpoint()
	Gamestate.state.active_checkpoint[0] = name
	Gamestate.state.active_checkpoint[1] = owner.filename
	Gamestate.state.current_position = Gamestate.state.active_checkpoint[0]
	Gamestate.state.current_level = Gamestate.state.active_checkpoint[1]
	
	Gamestate.save_gamestate()
