class_name DialogueUI
extends CanvasLayer

## Emitted when dialogue opens and locks input.
signal dialogue_started

## Emitted when dialogue sequence terminates and releases input.
signal dialogue_finished

@onready var panel: PanelContainer = $PanelContainer
@onready var speaker_label: Label = $PanelContainer/Margin/VBox/SpeakerLabel
@onready var text_label: Label = $PanelContainer/Margin/VBox/TextLabel
@onready var choices_container: HBoxContainer = $PanelContainer/Margin/VBox/ChoicesContainer
@onready var choice_a_btn: Button = $PanelContainer/Margin/VBox/ChoicesContainer/ChoiceA
@onready var choice_b_btn: Button = $PanelContainer/Margin/VBox/ChoicesContainer/ChoiceB
@onready var hint_label: Label = $PanelContainer/Margin/VBox/HintLabel

var _dialogue_nodes: Array[Dictionary] = []
var _current_index: int = 0
var _is_active: bool = false
var _player: CharacterBody2D = null


func _ready() -> void:
	panel.visible = false
	choice_a_btn.pressed.connect(_on_choice_a_selected)
	choice_b_btn.pressed.connect(_on_choice_b_selected)


func _unhandled_input(event: InputEvent) -> void:
	if not _is_active:
		return
	if choices_container.visible:
		return

	if event.is_action_pressed("interact") or event.is_action_pressed("ui_accept"):
		get_viewport().set_input_as_handled()
		_advance_dialogue()


func start_dialogue(sequence: Array[Dictionary], player: CharacterBody2D = null) -> void:
	if sequence.is_empty():
		return

	_dialogue_nodes = sequence
	_current_index = 0
	_player = player
	_is_active = true

	if _player and "is_movement_locked" in _player:
		_player.is_movement_locked = true

	panel.visible = true
	panel.modulate.a = 0.0
	var tween: Tween = create_tween()
	tween.tween_property(panel, "modulate:a", 1.0, 0.2)

	dialogue_started.emit()
	_render_current_node()


func end_dialogue() -> void:
	if not _is_active:
		return

	_is_active = false
	if _player and "is_movement_locked" in _player:
		_player.is_movement_locked = false

	var tween: Tween = create_tween()
	tween.tween_property(panel, "modulate:a", 0.0, 0.2)
	tween.tween_callback(func():
		panel.visible = false
		dialogue_finished.emit()
	)


func _render_current_node() -> void:
	if _current_index >= _dialogue_nodes.size():
		end_dialogue()
		return

	var node: Dictionary = _dialogue_nodes[_current_index]
	speaker_label.text = node.get("speaker", "Stranger")
	text_label.text = node.get("text", "")

	if node.has("choices") and node["choices"].size() >= 2:
		choices_container.visible = true
		hint_label.visible = false
		var choices: Array = node["choices"]
		choice_a_btn.text = choices[0].get("text", "Option 1")
		choice_b_btn.text = choices[1].get("text", "Option 2")
		choice_a_btn.grab_focus()
	else:
		choices_container.visible = false
		hint_label.visible = true


func _advance_dialogue() -> void:
	var node: Dictionary = _dialogue_nodes[_current_index]
	var next_idx: int = node.get("next", _current_index + 1)
	_current_index = next_idx
	_render_current_node()


func _on_choice_a_selected() -> void:
	if not _is_active or _current_index >= _dialogue_nodes.size():
		return
	var node: Dictionary = _dialogue_nodes[_current_index]
	var choices: Array = node.get("choices", [])
	if choices.size() > 0:
		_current_index = choices[0].get("next", _current_index + 1)
		_render_current_node()


func _on_choice_b_selected() -> void:
	if not _is_active or _current_index >= _dialogue_nodes.size():
		return
	var node: Dictionary = _dialogue_nodes[_current_index]
	var choices: Array = node.get("choices", [])
	if choices.size() > 1:
		_current_index = choices[1].get("next", _current_index + 1)
		_render_current_node()
