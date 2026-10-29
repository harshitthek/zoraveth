class_name CabinBookshelf
extends StaticBody2D

## Emitted when player requests inspection dialogue.
signal dialogue_requested(sequence: Array[Dictionary], player: CharacterBody2D)

## Emitted to record an environmental clue discovery in Player/UI.
signal discovered(title: String, description: String)

@export var shelf_name: String = "Bookshelf"

var inspection_count: int = 0

@onready var interaction_area: Area2D = $InteractionArea


func get_interaction_label() -> String:
	return "[E] Inspect " + shelf_name


func get_interaction_priority() -> int:
	return 8


func can_interact() -> bool:
	return true


func interact(player: CharacterBody2D) -> void:
	inspection_count += 1
	var sequence: Array[Dictionary] = _build_inspection_dialogue()
	if inspection_count == 1:
		discovered.emit(
			"Elderly Stranger's Bookshelf",
			"Weathered tomes and star charts describing ancient conduits beneath the forest roots."
		)
	dialogue_requested.emit(sequence, player)


func _build_inspection_dialogue() -> Array[Dictionary]:
	if inspection_count == 1:
		return [
			{
				"speaker": "Traveler",
				"text": "Interesting... The weathered leather bindings hold notes on regional flora, celestial charting, and strange geological fissures."
			},
			{
				"speaker": "Traveler",
				"text": "Several hand-copied passages mention 'dormant runic conduits' slumbering beneath the ancient roots of the valley."
			},
			{
				"speaker": "Traveler",
				"text": "The margin notes are penned in the elderly stranger's careful, disciplined hand. He knows far more about this land than he lets on."
			}
		]
	else:
		return [
			{
				"speaker": "Traveler",
				"text": "Interesting... You study the celestial charts once more. An ink sketch depicts a deep cavern passage etched with ancient runic pillars."
			}
		]
