class_name Player
extends KinematicBody2D

signal player_dead

onready var state_machine: StateMachine = $StateMachine
onready var collider: CollisionShape2D = $CollisionShape2D
onready var skin: Node2D = $Skin
onready var ledge_detector: LedgeWallDetector = $LedgeWallDetector
onready var floor_detector: FloorDetector = $FloorDetector

const FLOOR_NORMAL := Vector2.UP

var is_active := true setget set_is_active

func set_is_active(value: bool) -> void:
	is_active = value
	
	if not collider: 
		return
	collider.disabled = not value

func play_jump() -> void:
	$jump.play()
# Dropzone is a collider under the map. So if the player
# falls through it, he will die.
func _on_Dropzone_body_entered(body: Node) -> void:
	emit_signal("player_dead")
