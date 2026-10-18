class_name ForestWorld
extends Node2D

@onready var player: CharacterBody2D = $SortableEntities/Player
@onready var ui: CanvasLayer = $ExplorationUI


func _ready() -> void:
	if player and ui and ui.has_method("set_player"):
		ui.set_player(player)

		# Count all gatherable herb nodes in the scene
		var herb_count: int = 0
		for child in $SortableEntities.get_children():
			if child.has_signal("collected"):
				herb_count += 1
		if ui.has_method("set_total_herbs"):
			ui.set_total_herbs(herb_count)

		# Configure player camera bounds to keep exploration framed within the forest
		var camera: Camera2D = player.get_node_or_null("Camera2D")
		if camera:
			camera.limit_left = 60
			camera.limit_top = 80
			camera.limit_right = 1600
			camera.limit_bottom = 860
