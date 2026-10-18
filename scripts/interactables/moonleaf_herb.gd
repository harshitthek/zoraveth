class_name MoonleafHerb
extends Node2D

## Signal emitted when this herb is successfully collected.
signal collected(herb: MoonleafHerb)

@export var herb_name: String = "Moonleaf Herb"

var is_collected: bool = false
var _elapsed_time: float = 0.0

@onready var interaction_area: Area2D = $InteractionArea
@onready var petals: Node2D = $Visuals/Petals
@onready var harvested_remnant: Node2D = $Visuals/HarvestedRemnant


func _ready() -> void:
	if harvested_remnant:
		harvested_remnant.visible = false


func _process(delta: float) -> void:
	if is_collected:
		return
	# Gentle ambient biological pulse
	_elapsed_time += delta
	if petals:
		var pulse: float = 1.0 + sin(_elapsed_time * 2.5) * 0.06
		petals.scale = Vector2(pulse, pulse)


func get_interaction_label() -> String:
	return "[E] Gather " + herb_name


func can_interact() -> bool:
	return not is_collected


func interact(player: Node) -> void:
	if is_collected:
		return

	is_collected = true
	if interaction_area:
		interaction_area.set_deferred("monitoring", false)
		interaction_area.set_deferred("monitorable", false)

	# Notify listeners
	collected.emit(self)

	# Visual collection feedback: shrink petals and reveal harvested base
	if petals:
		var tween: Tween = create_tween()
		tween.tween_property(petals, "scale", Vector2.ZERO, 0.25).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
		tween.parallel().tween_property(petals, "modulate:a", 0.0, 0.25)
		tween.tween_callback(func():
			petals.visible = false
			if harvested_remnant:
				harvested_remnant.visible = true
		)
