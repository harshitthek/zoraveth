class_name Player
extends CharacterBody2D

## Emitted when the currently targetable interactable prompt changes.
signal interactable_focus_changed(prompt_text: String)

## Emitted when an environmental resource is collected.
signal resource_collected(resource_name: String, current_count: int)

## Emitted when a lore clue or secret is discovered.
signal clue_discovered(title: String, description: String)

## Base movement speed in pixels per second.
@export var speed: float = 200.0

var is_movement_locked: bool = false
var collected_herbs: int = 0
var _nearby_interactables: Array[Node] = []
var _current_target: Node = null

@onready var interaction_detector: Area2D = $InteractionDetector


func _ready() -> void:
	if interaction_detector:
		interaction_detector.area_entered.connect(_on_interaction_area_entered)
		interaction_detector.area_exited.connect(_on_interaction_area_exited)


func _physics_process(_delta: float) -> void:
	if is_movement_locked:
		velocity = Vector2.ZERO
		_update_interactable_focus()
		return

	# Input.get_vector automatically normalizes diagonal input,
	# ensuring movement speed is consistent in all directions.
	var input_direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_direction * speed
	move_and_slide()
	_update_interactable_focus()


func _unhandled_input(event: InputEvent) -> void:
	if is_movement_locked:
		return

	if event.is_action_pressed("interact") and _current_target != null:
		if _current_target.has_method("can_interact") and _current_target.can_interact():
			_current_target.interact(self)
			_update_interactable_focus()


func register_resource_collection(resource_name: String) -> void:
	collected_herbs += 1
	resource_collected.emit(resource_name, collected_herbs)


func register_clue_discovery(title: String, description: String) -> void:
	clue_discovered.emit(title, description)


func _on_interaction_area_entered(area: Area2D) -> void:
	var target: Node = area.get_parent()
	if target and target.has_method("interact"):
		if not _nearby_interactables.has(target):
			_nearby_interactables.append(target)
			if target.has_signal("collected") and not target.is_connected("collected", _on_resource_signal):
				target.connect("collected", _on_resource_signal)
			elif target.has_signal("discovered") and not target.is_connected("discovered", _on_clue_signal):
				target.connect("discovered", _on_clue_signal)
			_update_interactable_focus()


func _on_interaction_area_exited(area: Area2D) -> void:
	var target: Node = area.get_parent()
	if target and _nearby_interactables.has(target):
		_nearby_interactables.erase(target)
		_update_interactable_focus()


func _on_resource_signal(node: Node) -> void:
	var res_name: String = node.get("herb_name") if "herb_name" in node else "Forest Resource"
	register_resource_collection(res_name)


func _on_clue_signal(title: String, description: String) -> void:
	register_clue_discovery(title, description)


func _update_interactable_focus() -> void:
	var best_target: Node = null
	var highest_priority: int = -1
	var min_dist_sq: float = INF

	var active_list: Array[Node] = []
	for obj in _nearby_interactables:
		if is_instance_valid(obj) and obj.has_method("can_interact") and obj.can_interact():
			active_list.append(obj)
			var priority: int = obj.get_interaction_priority() if obj.has_method("get_interaction_priority") else 0
			var dist_sq: float = global_position.distance_squared_to(obj.global_position)

			if priority > highest_priority or (priority == highest_priority and dist_sq < min_dist_sq):
				highest_priority = priority
				min_dist_sq = dist_sq
				best_target = obj

	_nearby_interactables = active_list

	if best_target != _current_target:
		_current_target = best_target
		if _current_target and _current_target.has_method("get_interaction_label"):
			interactable_focus_changed.emit(_current_target.get_interaction_label())
		else:
			interactable_focus_changed.emit("")
	elif _current_target and _current_target.has_method("get_interaction_label"):
		interactable_focus_changed.emit(_current_target.get_interaction_label())
