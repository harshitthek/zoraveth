class_name Player
extends CharacterBody2D

## Base movement speed in pixels per second.
@export var speed: float = 200.0


func _physics_process(_delta: float) -> void:
	# Input.get_vector automatically normalizes diagonal input,
	# ensuring movement speed is consistent in all directions.
	var input_direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_direction * speed
	move_and_slide()
