class_name AncientRunestone
extends StaticBody2D

## Signal emitted when this ancient clue is first inspected.
signal discovered(title: String, description: String)

@export var clue_title: String = "Ancient Inscribed Runestone"
@export_multiline var clue_text: String = "Weathered glyphs depict a celestial eclipse and deep roots entwined with ancient stone. The script matches no modern scholarly records, yet beneath the moss, hairline fractures pulse faintly with dormant soul resonance."

var is_discovered: bool = false

@onready var interaction_area: Area2D = $InteractionArea
@onready var rune_glow: Polygon2D = $Visuals/Runes
@onready var soul_particles: CPUParticles2D = $Visuals/SoulParticles


func _ready() -> void:
	if rune_glow:
		rune_glow.modulate = Color(0.6, 0.85, 0.9, 0.4)


func get_interaction_label() -> String:
	if not is_discovered:
		return "[E] Inspect " + clue_title
	return "[E] Re-read Inscription"


func can_interact() -> bool:
	return true


func interact(_player: Node) -> void:
	if not is_discovered:
		is_discovered = true
		# First-time discovery visual brightening
		if rune_glow:
			var tween: Tween = create_tween()
			tween.tween_property(rune_glow, "modulate", Color(0.8, 1.0, 1.0, 0.95), 0.5)
			tween.tween_property(rune_glow, "modulate", Color(0.6, 0.9, 0.95, 0.7), 0.5)
		if soul_particles:
			soul_particles.amount = 16

	discovered.emit(clue_title, clue_text)
