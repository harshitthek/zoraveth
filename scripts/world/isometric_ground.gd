@tool
class_name IsometricGround
extends Node2D

## Isometric diamond tile width in pixels (2:1 projection).
@export var tile_width: float = 64.0:
	set(value):
		tile_width = value
		queue_redraw()

## Isometric diamond tile height in pixels (2:1 projection).
@export var tile_height: float = 32.0:
	set(value):
		tile_height = value
		queue_redraw()

## Dimensions of the isometric grid in tile coordinates.
@export var grid_size: Vector2i = Vector2i(14, 14):
	set(value):
		grid_size = value
		queue_redraw()

## Screen origin point where tile (0, 0) is centered.
@export var grid_origin: Vector2 = Vector2(576.0, 120.0):
	set(value):
		grid_origin = value
		queue_redraw()

## Alternating tile colors for visual readability.
@export var tile_color_a: Color = Color(0.17, 0.25, 0.19, 1.0):
	set(value):
		tile_color_a = value
		queue_redraw()

@export var tile_color_b: Color = Color(0.20, 0.29, 0.22, 1.0):
	set(value):
		tile_color_b = value
		queue_redraw()

@export var grid_line_color: Color = Color(0.13, 0.19, 0.14, 0.5):
	set(value):
		grid_line_color = value
		queue_redraw()


func _draw() -> void:
	var half_w: float = tile_width * 0.5
	var half_h: float = tile_height * 0.5

	for gy in range(grid_size.y):
		for gx in range(grid_size.x):
			var cx: float = grid_origin.x + (float(gx) - float(gy)) * half_w
			var cy: float = grid_origin.y + (float(gx) + float(gy)) * half_h

			var top: Vector2 = Vector2(cx, cy - half_h)
			var right: Vector2 = Vector2(cx + half_w, cy)
			var bottom: Vector2 = Vector2(cx, cy + half_h)
			var left: Vector2 = Vector2(cx - half_w, cy)

			var poly: PackedVector2Array = PackedVector2Array([top, right, bottom, left])
			var fill_color: Color = tile_color_a if (gx + gy) % 2 == 0 else tile_color_b

			draw_colored_polygon(poly, fill_color)
			draw_polyline(PackedVector2Array([top, right, bottom, left, top]), grid_line_color, 1.0)
