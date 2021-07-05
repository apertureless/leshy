class_name Player
extends KinematicBody2D

onready var state_machine: StateMachine = $StateMachine
onready var collider: CollisionShape2D = $CollisionShape2D
onready var skin: Node2D = $Skin

const FLOOR_NORMAL := Vector2.UP

var is_active := true setget set_is_active

func set_is_active(value: bool) -> void:
	is_active = value
	
	if not collider: 
		return
	collider.disabled = not value

func _on_Dropzone_body_entered(body: Node) -> void:
	get_tree().reload_current_scene()
