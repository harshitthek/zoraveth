class_name CabinInterior
extends Node2D

## Emitted when player requests to leave the cabin through the entrance doorway.
signal exit_requested(player: CharacterBody2D)

@export var spawn_position: Vector2 = Vector2(380, 280)

@onready var hearth_fire: Polygon2D = $SortableEntities/Fireplace/FireGlow
@onready var hearth_aura: Polygon2D = $HearthWarmthAura
@onready var window_beam: Polygon2D = $WindowSunlightBeam
@onready var exit_area: Area2D = $ExitDoorway
@onready var sortable_entities: Node2D = $SortableEntities
@onready var stranger: StaticBody2D = $SortableEntities/ElderlyStranger

var _fire_timer: float = 0.0


func _ready() -> void:
	if exit_area:
		exit_area.set_meta("interaction_label", "[E] Exit to Forest")


func _process(delta: float) -> void:
	_fire_timer += delta * 5.0

	# Cozy natural hearth flame flicker
	if hearth_fire:
		var flame_scale: float = 0.9 + sin(_fire_timer) * 0.12 + cos(_fire_timer * 2.3) * 0.06
		hearth_fire.scale = Vector2(flame_scale, flame_scale * 1.05)

	# Gentle breathing of hearth ambient warmth aura
	if hearth_aura:
		var aura_alpha: float = 0.08 + sin(_fire_timer * 0.7) * 0.02 + cos(_fire_timer * 1.7) * 0.015
		hearth_aura.color.a = aura_alpha

	# Subtle morning sunlight shimmer through the timber window
	if window_beam and window_beam.visible:
		var beam_alpha: float = 0.06 + sin(_fire_timer * 0.4) * 0.015
		window_beam.color.a = beam_alpha


func get_interaction_label() -> String:
	return "[E] Exit to Forest"


func get_interaction_priority() -> int:
	return 10


func can_interact() -> bool:
	return true


func interact(player: CharacterBody2D) -> void:
	exit_requested.emit(player)
