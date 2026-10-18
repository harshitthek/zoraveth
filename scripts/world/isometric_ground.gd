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

# Key waypoints along the winding forest route and branches in tile coordinates
var _trail_routes: Array[PackedVector2Array] = [
	# Main forest route from Entry Meadow to Ancient Discovery Grove
	PackedVector2Array([
		Vector2(6, 18), Vector2(7, 16), Vector2(10, 15),
		Vector2(13, 13), Vector2(16, 11), Vector2(19, 8), Vector2(22, 6)
	]),
	# Cabin approach branch connecting meadow to cabin doorway
	PackedVector2Array([Vector2(7, 16), Vector2(6, 14), Vector2(5, 12)]),
	# Secluded alcove branch connecting woodland trail to herb grove
	PackedVector2Array([Vector2(13, 13), Vector2(15, 14), Vector2(17, 15)])
]


func _draw() -> void:
	var half_w: float = tile_width * 0.5
	var half_h: float = tile_height * 0.5

	for gy in range(grid_size.y):
		for gx in range(grid_size.x):
			var tile_coord: Vector2 = Vector2(gx, gy)
			var path_dist: float = _get_min_path_dist(tile_coord)

			var cx: float = grid_origin.x + (float(gx) - float(gy)) * half_w
			var cy: float = grid_origin.y + (float(gx) + float(gy)) * half_h

			var poly: PackedVector2Array = PackedVector2Array([
				Vector2(cx, cy - half_h), Vector2(cx + half_w, cy),
				Vector2(cx, cy + half_h), Vector2(cx - half_w, cy)
			])

			# Smooth harmonic spatial variation eliminates the checkerboard
			var harmonic: float = sin(gx * 0.28 + gy * 0.22) * 0.5 + cos(gx * 0.15 - gy * 0.3) * 0.5
			var base_grass: Color = tile_color_a.lerp(tile_color_b, clampf(harmonic + 0.5, 0.0, 1.0))
			if gx < 3 or gy < 3 or gx > grid_size.x - 4 or gy > grid_size.y - 4:
				base_grass = base_grass.darkened(0.12)

			# Soft transitional path blending
			var fill_color: Color
			if path_dist <= 0.8:
				fill_color = path_color_a.lerp(path_color_b, 0.5 + sin(gx * 0.8 + gy * 0.5) * 0.3)
			elif path_dist <= 1.45:
				var t: float = (path_dist - 0.8) / 0.65
				fill_color = path_color_b.darkened(0.05).lerp(base_grass, t)
			else:
				fill_color = base_grass

			draw_colored_polygon(poly, fill_color)

			# Subtle painterly micro-details
			var seed_val: int = (gx * 17 + gy * 31) ^ (gx * 7)
			if path_dist <= 0.8 and (seed_val % 4 == 0):
				draw_circle(Vector2(cx + 1.0, cy - 1.0), 1.5, Color(0.38, 0.35, 0.26, 0.7))
			elif path_dist > 1.45 and (seed_val % 5 == 0):
				draw_line(Vector2(cx - 2.0, cy), Vector2(cx - 3.0, cy - 3.5), Color(0.28, 0.42, 0.30, 0.6), 1.0)
				draw_line(Vector2(cx + 1.0, cy), Vector2(cx + 3.0, cy - 4.0), Color(0.25, 0.38, 0.27, 0.6), 1.0)


func _get_min_path_dist(pt: Vector2) -> float:
	var min_d: float = INF
	for route in _trail_routes:
		for i in range(route.size() - 1):
			var d: float = _dist_to_segment(pt, route[i], route[i + 1])
			if d < min_d:
				min_d = d
	return min_d


func _dist_to_segment(p: Vector2, a: Vector2, b: Vector2) -> float:
	var ab: Vector2 = b - a
	var len_sq: float = ab.length_squared()
	if len_sq == 0.0:
		return p.distance_to(a)
	var t: float = clampf((p - a).dot(ab) / len_sq, 0.0, 1.0)
	return p.distance_to(a + t * ab)
