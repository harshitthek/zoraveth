@tool
class_name IsometricGround
extends Node2D

## Seamless painterly forest floor ground texture.
@export var ground_texture: Texture2D = preload("res://assets/environment/terrain_forest_floor.png"):
	set(value):
		ground_texture = value
		queue_redraw()

@export var world_size: Vector2 = Vector2(1800.0, 1000.0):
	set(value):
		world_size = value
		queue_redraw()

## Base tile dimensions (2:1 isometric coordinate reference).
@export var tile_width: float = 64.0
@export var tile_height: float = 32.0
@export var grid_origin: Vector2 = Vector2(720.0, 100.0)
@export var grid_size: Vector2i = Vector2i(28, 22)

# Continuous winding forest trail splines in world coordinates
var _main_trail: PackedVector2Array = PackedVector2Array([
	Vector2(320, 500), Vector2(400, 508), Vector2(520, 525),
	Vector2(680, 535), Vector2(850, 530), Vector2(1020, 515),
	Vector2(1160, 530), Vector2(1264, 545)
])

var _cabin_trail: PackedVector2Array = PackedVector2Array([
	Vector2(400, 508), Vector2(435, 445), Vector2(480, 385)
])

var _alcove_trail: PackedVector2Array = PackedVector2Array([
	Vector2(680, 535), Vector2(735, 590), Vector2(790, 640)
])

# Stepping stones and pebbles scattered along the beaten earth
var _trail_pebbles: Array[Vector3] = [
	Vector3(360, 506, 2.5), Vector3(450, 514, 3.2), Vector3(580, 528, 2.8),
	Vector3(720, 538, 3.5), Vector3(890, 526, 2.6), Vector3(1070, 518, 3.0),
	Vector3(1210, 536, 3.8), Vector3(440, 460, 2.4), Vector3(465, 410, 2.7),
	Vector3(710, 565, 2.6), Vector3(760, 615, 3.0)
]

# Scattered meadow grass blade tufts: Vector2 pos, float rot, Color
var _meadow_tufts: Array[Vector2] = [
	Vector2(300, 470), Vector2(340, 540), Vector2(420, 560), Vector2(500, 480),
	Vector2(620, 490), Vector2(760, 480), Vector2(940, 560), Vector2(1100, 570),
	Vector2(1200, 480), Vector2(1330, 520), Vector2(1280, 610), Vector2(740, 670)
]


func _draw() -> void:
	# 1. Continuous seamless painterly forest floor
	if ground_texture:
		draw_texture_rect(ground_texture, Rect2(Vector2.ZERO, world_size), true)
	else:
		draw_rect(Rect2(Vector2.ZERO, world_size), Color(0.14, 0.22, 0.16, 1.0))

	# 2. Atmospheric lighting zones
	# Northern canopy shade (deep forest shelter)
	var canopy_shadow: PackedVector2Array = PackedVector2Array([
		Vector2(0, 0), Vector2(world_size.x, 0),
		Vector2(world_size.x, 260), Vector2(0, 320)
	])
	draw_colored_polygon(canopy_shadow, Color(0.04, 0.08, 0.05, 0.40))

	# Entry meadow sunbeam (warm inviting glade)
	draw_circle(Vector2(380, 510), 120.0, Color(0.85, 0.78, 0.45, 0.07))
	# Cabin approach glade
	draw_circle(Vector2(480, 390), 85.0, Color(0.90, 0.75, 0.40, 0.08))
	# Ancient Grove subtle soul-teal shimmer
	draw_circle(Vector2(1264, 545), 110.0, Color(0.25, 0.75, 0.65, 0.07))

	# 3. Continuous winding dirt trails (multi-pass organic blending)
	_draw_continuous_path(_main_trail)
	_draw_continuous_path(_cabin_trail)
	_draw_continuous_path(_alcove_trail)

	# 4. Ancient Grove stone flagstone apron around the runestone
	var flagstones: PackedVector2Array = PackedVector2Array([
		Vector2(1220, 545), Vector2(1244, 530), Vector2(1284, 530),
		Vector2(1308, 545), Vector2(1284, 560), Vector2(1244, 560)
	])
	draw_colored_polygon(flagstones, Color(0.24, 0.29, 0.27, 0.85))
	draw_polyline(flagstones, Color(0.16, 0.20, 0.19, 0.95), 1.5, true)

	# 5. Embedded stepping stones & pebbles
	for p in _trail_pebbles:
		var pos: Vector2 = Vector2(p.x, p.y)
		var rad: float = p.z
		draw_circle(pos + Vector2(0.8, 1.2), rad, Color(0.12, 0.16, 0.12, 0.6))
		draw_circle(pos, rad, Color(0.42, 0.40, 0.32, 0.9))
		draw_circle(pos - Vector2(0.5, 0.5), rad * 0.45, Color(0.54, 0.51, 0.42, 0.8))

	# 6. Natural meadow grass tufts
	for t in _meadow_tufts:
		draw_line(t, t + Vector2(-3, -7), Color(0.28, 0.48, 0.30, 0.75), 1.5, true)
		draw_line(t + Vector2(1, 0), t + Vector2(2, -9), Color(0.35, 0.58, 0.36, 0.85), 1.5, true)
		draw_line(t + Vector2(3, 0), t + Vector2(5, -6), Color(0.25, 0.42, 0.26, 0.7), 1.2, true)


func _draw_continuous_path(points: PackedVector2Array) -> void:
	if points.size() < 2:
		return
	# Pass 1: Soft mossy transition border
	draw_polyline(points, Color(0.18, 0.24, 0.17, 0.75), 48.0, true)
	# Pass 2: Compacted beaten earth body
	draw_polyline(points, Color(0.33, 0.28, 0.19, 0.92), 32.0, true)
	# Pass 3: Central worn footway with subtle dry loam highlight
	draw_polyline(points, Color(0.40, 0.35, 0.24, 0.85), 16.0, true)


func grid_to_world(gx: float, gy: float) -> Vector2:
	return grid_origin + Vector2((gx - gy) * tile_width * 0.5, (gx + gy) * tile_height * 0.5)


func world_to_grid(world_pos: Vector2) -> Vector2:
	var rel: Vector2 = world_pos - grid_origin
	var half_w: float = tile_width * 0.5
	var half_h: float = tile_height * 0.5
	return Vector2(
		(rel.x / half_w + rel.y / half_h) * 0.5,
		(rel.y / half_h - rel.x / half_w) * 0.5
	)
