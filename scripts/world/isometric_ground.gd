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
@export var grid_size: Vector2i = Vector2i(28, 22):
	set(value):
		grid_size = value
		queue_redraw()

## Screen origin point where tile (0, 0) is centered.
@export var grid_origin: Vector2 = Vector2(720.0, 100.0):
	set(value):
		grid_origin = value
		queue_redraw()

## Base forest grass colors.
@export var tile_color_a: Color = Color(0.16, 0.24, 0.18, 1.0):
	set(value):
		tile_color_a = value
		queue_redraw()

@export var tile_color_b: Color = Color(0.19, 0.28, 0.21, 1.0):
	set(value):
		tile_color_b = value
		queue_redraw()

## Beaten earth and mossy path color for walkable routes.
@export var path_color_a: Color = Color(0.24, 0.25, 0.18, 1.0):
	set(value):
		path_color_a = value
		queue_redraw()

@export var path_color_b: Color = Color(0.26, 0.27, 0.19, 1.0):
	set(value):
		path_color_b = value
		queue_redraw()

## Fine grid outline color.
@export var grid_line_color: Color = Color(0.12, 0.18, 0.13, 0.45):
	set(value):
		grid_line_color = value
		queue_redraw()

# Key waypoints along the winding forest route in tile coordinates
var _path_waypoints: Array[Vector2] = [
	Vector2(6, 17),   # Entry clearing
	Vector2(10, 15),  # Clearing exit
	Vector2(13, 13),  # Woodland curve
	Vector2(16, 10),  # Central woodland passage
	Vector2(19, 8),   # Northward bend
	Vector2(23, 6)    # Ancient discovery grove
]


func _draw() -> void:
	var half_w: float = tile_width * 0.5
	var half_h: float = tile_height * 0.5

	for gy in range(grid_size.y):
		for gx in range(grid_size.x):
			var tile_coord: Vector2 = Vector2(gx, gy)
			var is_path_tile: bool = _is_near_path(tile_coord, 1.4)

			var cx: float = grid_origin.x + (float(gx) - float(gy)) * half_w
			var cy: float = grid_origin.y + (float(gx) + float(gy)) * half_h

			var top: Vector2 = Vector2(cx, cy - half_h)
			var right: Vector2 = Vector2(cx + half_w, cy)
			var bottom: Vector2 = Vector2(cx, cy + half_h)
			var left: Vector2 = Vector2(cx - half_w, cy)

			var poly: PackedVector2Array = PackedVector2Array([top, right, bottom, left])
			var is_even: bool = (gx + gy) % 2 == 0

			var fill_color: Color
			if is_path_tile:
				fill_color = path_color_a if is_even else path_color_b
			else:
				fill_color = tile_color_a if is_even else tile_color_b

			draw_colored_polygon(poly, fill_color)
			draw_polyline(PackedVector2Array([top, right, bottom, left, top]), grid_line_color, 1.0)


func _is_near_path(pt: Vector2, threshold: float) -> bool:
	for i in range(_path_waypoints.size() - 1):
		var p1: Vector2 = _path_waypoints[i]
		var p2: Vector2 = _path_waypoints[i + 1]
		if _dist_to_segment(pt, p1, p2) <= threshold:
			return true
	return false


func _dist_to_segment(p: Vector2, a: Vector2, b: Vector2) -> float:
	var ab: Vector2 = b - a
	var ab_len_sq: float = ab.length_squared()
	if ab_len_sq == 0.0:
		return p.distance_to(a)
	var t: float = clampf((p - a).dot(ab) / ab_len_sq, 0.0, 1.0)
	var proj: Vector2 = a + t * ab
	return p.distance_to(proj)
