class_name ElderlyStranger
extends StaticBody2D

## Emitted when player requests dialogue with the stranger.
signal dialogue_requested(sequence: Array[Dictionary], player: CharacterBody2D)

@export var stranger_name: String = "Elderly Stranger"

var has_spoken: bool = false
var _elapsed_time: float = 0.0

@onready var visuals: Node2D = $Visuals
@onready var interaction_area: Area2D = $InteractionArea


func _process(delta: float) -> void:
	# Subtle ambient breathing idle
	_elapsed_time += delta
	if visuals:
		visuals.position.y = sin(_elapsed_time * 2.0) * 0.8


func get_interaction_label() -> String:
	return "[E] Speak with " + stranger_name


func get_interaction_priority() -> int:
	return 10


func can_interact() -> bool:
	return true


func interact(player: CharacterBody2D) -> void:
	var sequence: Array[Dictionary] = _build_dialogue_sequence()
	has_spoken = true
	dialogue_requested.emit(sequence, player)


func _build_dialogue_sequence() -> Array[Dictionary]:
	if has_spoken:
		return [
			{
				"speaker": stranger_name,
				"text": "Take all the time you need, friend. The hearth remains warm, and the forest trail will wait."
			}
		]

	return [
		{
			"speaker": stranger_name,
			"text": "Easy now, traveler. Take a steady breath. You gave me quite a fright when I found you out by the ancient woods."
		},
		{
			"speaker": stranger_name,
			"text": "Your strength is returning, but your thoughts still seem clouded. What do you recall?",
			"choices": [
				{
					"text": "What happened? I remember tremors... and then nothing.",
					"next": 2
				},
				{
					"text": "Thank you for taking me in. Where am I?",
					"next": 3
				}
			]
		},
		{
			"speaker": stranger_name,
			"text": "The sky broke with strange thunder before dawn, and the ground trembled deeper than mere storm. When it passed, I found you collapsed amidst the moss, untouched by beasts.",
			"next": 4
		},
		{
			"speaker": stranger_name,
			"text": "You are safe beneath my roof, at the edge of the woodland border. The woods can be unforgiving to those wandering in a haze.",
			"next": 4
		},
		{
			"speaker": stranger_name,
			"text": "Rest your limbs as long as you require. The hearth is warm, and the broth on the stove will mend your strength.",
			"next": 5
		},
		{
			"speaker": stranger_name,
			"text": "When your legs feel sound again, the trail outside leads through the forest. Just mind the deeper thickets—the ancient stones have been whispering lately."
		}
	]
