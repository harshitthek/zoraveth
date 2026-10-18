class_name CabinInterior
extends Node2D

## Emitted when player requests to leave the cabin through the entrance doorway.
signal exit_requested(player: CharacterBody2D)

@export var spawn_position: Vector2 = Vector2(230, 240)

@onready var hearth_fire: Polygon2D = $SortableEntities/Fireplace/FireGlow
@onready var exit_area: Area2D = $ExitDoorway
@onready var sortable_entities: Node2D = $SortableEntities
@onready var stranger: StaticBody2D = $SortableEntities/ElderlyStranger

var _fire_timer: float = 0.0


func _ready() -> void:
	if exit_area:
		exit_area.set_meta("interaction_label", "[E] Exit to Forest")


func _process(delta: float) -> void:
	# Subtle cozy hearth flame flicker
	_fire_timer += delta * 6.0
	if hearth_fire:
		var flicker: float = 0.85 + sin(_fire_timer) * 0.1 + cos(_fire_timer * 2.3) * 0.05
		hearth_fire.scale = Vector2(flicker, flicker)


func get_interaction_label() -> String:
	return "[E] Exit to Forest"


func get_interaction_priority() -> int:
	return 10


func can_interact() -> bool:
	return true


func interact(player: CharacterBody2D) -> void:
	exit_requested.emit(player)
