class_name CabinBed
extends StaticBody2D

## Emitted when player rests and triggers narrative thought dialogue.
signal dialogue_requested(sequence: Array[Dictionary], player: CharacterBody2D)

@export var bed_name: String = "Rustic Bed"
@export var rest_position: Vector2 = Vector2(530, 240)
@export var bedside_position: Vector2 = Vector2(425, 265)

var is_resting: bool = false
var is_transitioning: bool = false
var rest_count: int = 0
var current_player: CharacterBody2D = null
var _original_player_pos: Vector2 = Vector2.ZERO
var _original_sprite_pos: Vector2 = Vector2(0, -24)
var _original_sprite_rot: float = 0.0
var _rest_timer: float = 0.0

@onready var interaction_area: Area2D = $InteractionArea


func _process(delta: float) -> void:
	if is_resting and current_player and not is_transitioning:
		# Subtle resting breath motion on the bed
		_rest_timer += delta * 2.5
		var sprite: Sprite2D = current_player.get_node_or_null("Sprite2D")
		if sprite:
			sprite.position.y = -12.0 + sin(_rest_timer) * 1.2
		# Ensure player movement stays locked while resting
		current_player.is_movement_locked = true
		current_player.velocity = Vector2.ZERO


func _is_dialogue_open() -> bool:
	var tree: SceneTree = get_tree()
	if not tree or not tree.root:
		return false
	var dialogue_ui: DialogueUI = tree.root.find_child("DialogueUI", true, false) as DialogueUI
	return dialogue_ui != null and dialogue_ui.is_active()


func _unhandled_input(event: InputEvent) -> void:
	if not is_resting or is_transitioning or _is_dialogue_open():
		return

	if event.is_action_pressed("interact") or event.is_action_pressed("ui_accept") \
		or event.is_action_pressed("move_left") or event.is_action_pressed("move_right") \
		or event.is_action_pressed("move_up") or event.is_action_pressed("move_down"):
		get_viewport().set_input_as_handled()
		get_up()


func get_interaction_label() -> String:
	if is_resting:
		return "[E] Get Up"
	return "[E] Rest in Bed"


func get_interaction_priority() -> int:
	if is_resting:
		return 15
	return 8


func can_interact() -> bool:
	return not is_transitioning


func interact(player: CharacterBody2D) -> void:
	if is_resting:
		if not _is_dialogue_open():
			get_up()
	else:
		lay_down(player)


func lay_down(player: CharacterBody2D) -> void:
	if is_resting or is_transitioning or not player:
		return

	current_player = player
	is_resting = true
	is_transitioning = true
	rest_count += 1
	_original_player_pos = player.position

	player.is_movement_locked = true
	player.velocity = Vector2.ZERO

	var shadow: Node2D = player.get_node_or_null("Shadow")
	if shadow:
		shadow.visible = false

	var col: CollisionShape2D = player.get_node_or_null("CollisionShape2D")
	if col:
		col.set_deferred("disabled", true)

	var sprite: Sprite2D = player.get_node_or_null("Sprite2D")

	var tween: Tween = create_tween().set_parallel(true)
	tween.tween_property(player, "position", rest_position, 0.35).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	if sprite:
		_original_sprite_pos = sprite.position
		_original_sprite_rot = sprite.rotation_degrees
		tween.tween_property(sprite, "rotation_degrees", -60.0, 0.35).set_trans(Tween.TRANS_SINE)
		tween.tween_property(sprite, "position", Vector2(0, -12), 0.35)

	tween.chain().tween_callback(func():
		is_transitioning = false
		var sequence: Array[Dictionary] = _build_resting_dialogue()
		dialogue_requested.emit(sequence, current_player)
	)


func get_up() -> void:
	if not is_resting or is_transitioning or not current_player:
		return

	is_transitioning = true
	var p: CharacterBody2D = current_player
	var sprite: Sprite2D = p.get_node_or_null("Sprite2D")
	var target_pos: Vector2 = _original_player_pos if _original_player_pos != Vector2.ZERO else bedside_position

	var tween: Tween = create_tween().set_parallel(true)
	tween.tween_property(p, "position", target_pos, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	if sprite:
		tween.tween_property(sprite, "rotation_degrees", _original_sprite_rot, 0.3).set_trans(Tween.TRANS_SINE)
		tween.tween_property(sprite, "position", _original_sprite_pos, 0.3)

	tween.chain().tween_callback(func():
		var shadow: Node2D = p.get_node_or_null("Shadow")
		if shadow:
			shadow.visible = true

		var col: CollisionShape2D = p.get_node_or_null("CollisionShape2D")
		if col:
			col.disabled = false

		p.is_movement_locked = false
		is_resting = false
		is_transitioning = false
		current_player = null
	)


func _build_resting_dialogue() -> Array[Dictionary]:
	if rest_count == 1:
		return [
			{
				"speaker": "Traveler",
				"text": "You lay down on the soft patchwork quilt. The radiant warmth of the stone hearth soothes your tired limbs."
			},
			{
				"speaker": "Traveler",
				"text": "The memory of the celestial tremor fades into quiet calm. You feel refreshed and steady once more."
			}
		]
	else:
		return [
			{
				"speaker": "Traveler",
				"text": "You rest peacefully for a while, listening to the crackle of the embers and the pine boughs swaying outside."
			}
		]
