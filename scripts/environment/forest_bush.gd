class_name ForestBush
extends Node2D

@export var sway_speed: float = 1.6
@export var sway_amount: float = 0.04

var _time_offset: float = 0.0

@onready var foliage: Node2D = $Foliage


func _ready() -> void:
	# Randomize phase offset so adjacent bushes do not sway identically
	_time_offset = randf_range(0.0, 6.28)


func _process(delta: float) -> void:
	if foliage:
		_time_offset += delta * sway_speed
		foliage.rotation = sin(_time_offset) * sway_amount
