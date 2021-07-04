extends State

onready var timer: Timer = $DashTimer

export var dash_speed := 1000.0

var direction := Vector2.ZERO
var _velocity := Vector2.ZERO

func enter(msg: Dictionary = {}):
	timer.connect("timeout", self, "_on_DashTimer_timeout", [], CONNECT_ONESHOT)
	direction = msg.direction
	timer.start()
	
func physics_process(delta: float) -> void:
	_velocity = owner.move_and_slide(direction * dash_speed, owner.FLOOR_NORMAL)
	Events.emit_signal("owner_moved", owner)
	
func _on_DashTimer_timeout() -> void:
	_state_machine.transition_to("Move/Air", { velocity = _velocity / 2 })
