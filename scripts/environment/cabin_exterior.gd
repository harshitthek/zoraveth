class_name CabinExterior
extends StaticBody2D

## Emitted when player requests entry into the cabin.
signal enter_requested(player: CharacterBody2D)

@export var doorway_spawn_offset: Vector2 = Vector2(0, 32)

@onready var interaction_area: Area2D = $InteractionArea
@onready var chimney_smoke: CPUParticles2D = $Visuals/Chimney/SmokeParticles


func get_interaction_label() -> String:
	return "[E] Enter Cabin"


func get_interaction_priority() -> int:
	return 10


func can_interact() -> bool:
	return true


func interact(player: CharacterBody2D) -> void:
	enter_requested.emit(player)
