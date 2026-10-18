class_name ExplorationUI
extends CanvasLayer

@onready var prompt_container: PanelContainer = $PromptContainer
@onready var prompt_label: Label = $PromptContainer/Margin/PromptLabel
@onready var counter_label: Label = $CounterBadge/Margin/CounterLabel
@onready var discovery_panel: PanelContainer = $DiscoveryCard
@onready var discovery_title: Label = $DiscoveryCard/Margin/VBox/TitleLabel
@onready var discovery_text: Label = $DiscoveryCard/Margin/VBox/DescriptionLabel

var _current_herb_count: int = 0
var _total_herbs: int = 3
var _discovery_dismiss_timer: float = 0.0
var _discovery_tween: Tween = null
var _is_hiding_discovery: bool = false


func _ready() -> void:
	if prompt_container:
		prompt_container.visible = false
	if discovery_panel:
		discovery_panel.visible = false
	_update_counter_display()


func _process(delta: float) -> void:
	if discovery_panel and discovery_panel.visible and not _is_hiding_discovery:
		_discovery_dismiss_timer -= delta
		if _discovery_dismiss_timer <= 0.0:
			hide_discovery()


func set_player(player: CharacterBody2D) -> void:
	if not player:
		return
	player.interactable_focus_changed.connect(_on_interactable_focus_changed)
	player.resource_collected.connect(_on_resource_collected)
	player.clue_discovered.connect(_on_clue_discovered)


func set_total_herbs(total: int) -> void:
	_total_herbs = total
	_update_counter_display()


func _on_interactable_focus_changed(prompt_text: String) -> void:
	if not prompt_container or not prompt_label:
		return
	if prompt_text.is_empty():
		prompt_container.visible = false
	else:
		prompt_label.text = prompt_text
		prompt_container.visible = true


func _on_resource_collected(_resource_name: String, current_count: int) -> void:
	_current_herb_count = current_count
	_update_counter_display()


func _on_clue_discovered(title: String, description: String) -> void:
	show_discovery(title, description)


func show_discovery(title: String, description: String) -> void:
	if _discovery_tween and _discovery_tween.is_valid():
		_discovery_tween.kill()
	_is_hiding_discovery = false
	if discovery_title:
		discovery_title.text = title
	if discovery_text:
		discovery_text.text = description
	discovery_panel.visible = true
	discovery_panel.modulate.a = 0.0
	_discovery_tween = create_tween()
	_discovery_tween.tween_property(discovery_panel, "modulate:a", 1.0, 0.3)
	_discovery_dismiss_timer = 7.0


func hide_discovery() -> void:
	if not discovery_panel or not discovery_panel.visible or _is_hiding_discovery:
		return
	_is_hiding_discovery = true
	if _discovery_tween and _discovery_tween.is_valid():
		_discovery_tween.kill()
	_discovery_tween = create_tween()
	_discovery_tween.tween_property(discovery_panel, "modulate:a", 0.0, 0.3)
	_discovery_tween.tween_callback(func():
		discovery_panel.visible = false
		_is_hiding_discovery = false
	)


func _update_counter_display() -> void:
	if counter_label:
		counter_label.text = "Moonleaf Herbs: %d / %d" % [_current_herb_count, _total_herbs]
