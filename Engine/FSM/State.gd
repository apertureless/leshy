## State is an interface to use in Hierachical State Machines
##
## Use State as an child of the StateMachine node
class_name State
extends Node

onready var _state_machine := _get_state_machine(self)

# Virtual unhandled_input function
# warning-ignore:unused_argument
func unhandled_input(event: InputEvent) -> void:
	pass

# Virtual physics_process function
# warning-ignore:unused_argument
func physics_process(delta: float) -> void:
	pass
	
# Enter a state
# warning-ignore:unused_argument
func enter(msg: Dictionary = {}) -> void:
	pass
	
# Exit a state
func exit() -> void:
	pass


## Recusive function to get state machine from node.
## Travels up the hierachie until a state machine is found.
func _get_state_machine(node: Node) -> Node:
	if node != null and not node.is_in_group("state_machine"):
		return _get_state_machine(node.get_parent())
	return node

