class_name ForestWorld
extends Node2D

@export var cabin_exterior_door_pos: Vector2 = Vector2(480, 365)

@onready var forest_ground: Node2D = $IsometricGround
@onready var forest_entities: Node2D = $SortableEntities
@onready var player: CharacterBody2D = $SortableEntities/Player
@onready var ui: CanvasLayer = $ExplorationUI
@onready var dialogue_ui: CanvasLayer = $DialogueUI
@onready var cabin_exterior: StaticBody2D = $SortableEntities/CabinExterior
@onready var cabin_interior: Node2D = $CabinInterior
@onready var transition_rect: ColorRect = $TransitionOverlay/ColorRect

var _is_transitioning: bool = false


func _ready() -> void:
	if transition_rect:
		transition_rect.visible = false

	if player and ui and ui.has_method("set_player"):
		ui.set_player(player)

	# Count all gatherable herb nodes in the forest scene
	var herb_count: int = 0
	for child in forest_entities.get_children():
		if child.has_signal("collected"):
			herb_count += 1
	if ui and ui.has_method("set_total_herbs"):
		ui.set_total_herbs(herb_count)

	# Wire cabin exterior and interior interaction signals
	if cabin_exterior:
		cabin_exterior.enter_requested.connect(_on_cabin_enter_requested)

	if cabin_interior:
		cabin_interior.visible = false
		cabin_interior.process_mode = Node.PROCESS_MODE_DISABLED
		cabin_interior.exit_requested.connect(_on_cabin_exit_requested)
		if cabin_interior.stranger:
			cabin_interior.stranger.dialogue_requested.connect(_on_stranger_dialogue_requested)

	_apply_forest_camera_limits()


func _on_cabin_enter_requested(_p: CharacterBody2D) -> void:
	if _is_transitioning:
		return
	_is_transitioning = true
	_fade_transition(func():
		forest_ground.visible = false
		forest_ground.process_mode = Node.PROCESS_MODE_DISABLED
		forest_entities.visible = false
		forest_entities.process_mode = Node.PROCESS_MODE_DISABLED

		cabin_interior.visible = true
		cabin_interior.process_mode = Node.PROCESS_MODE_INHERIT

		player.reparent(cabin_interior.sortable_entities)
		player.position = cabin_interior.spawn_position
		_apply_cabin_camera_limits()
	)


func _on_cabin_exit_requested(_p: CharacterBody2D) -> void:
	if _is_transitioning:
		return
	_is_transitioning = true
	_fade_transition(func():
		cabin_interior.visible = false
		cabin_interior.process_mode = Node.PROCESS_MODE_DISABLED

		forest_ground.visible = true
		forest_ground.process_mode = Node.PROCESS_MODE_INHERIT
		forest_entities.visible = true
		forest_entities.process_mode = Node.PROCESS_MODE_INHERIT

		player.reparent(forest_entities)
		player.position = cabin_exterior_door_pos
		_apply_forest_camera_limits()
	)


func _on_stranger_dialogue_requested(sequence: Array[Dictionary], p: CharacterBody2D) -> void:
	if dialogue_ui:
		dialogue_ui.start_dialogue(sequence, p)


func _fade_transition(midpoint_action: Callable) -> void:
	if not transition_rect:
		midpoint_action.call()
		_is_transitioning = false
		return

	player.is_movement_locked = true
	transition_rect.visible = true
	transition_rect.modulate.a = 0.0

	var tween: Tween = create_tween()
	tween.tween_property(transition_rect, "modulate:a", 1.0, 0.25)
	tween.tween_callback(func():
		midpoint_action.call()
	)
	tween.tween_property(transition_rect, "modulate:a", 0.0, 0.25)
	tween.tween_callback(func():
		transition_rect.visible = false
		player.is_movement_locked = false
		_is_transitioning = false
	)


func _apply_forest_camera_limits() -> void:
	var camera: Camera2D = player.get_node_or_null("Camera2D")
	if camera:
		camera.limit_left = 60
		camera.limit_top = 80
		camera.limit_right = 1600
		camera.limit_bottom = 860


func _apply_cabin_camera_limits() -> void:
	var camera: Camera2D = player.get_node_or_null("Camera2D")
	if camera:
		camera.limit_left = 40
		camera.limit_top = -20
		camera.limit_right = 560
		camera.limit_bottom = 380
