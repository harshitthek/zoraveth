@tool
class_name IsometricGround
extends Node2D

@export var meadow_texture: Texture2D = preload("res://assets/environment/terrain_meadow_open.png"):
	set(v): meadow_texture = v; queue_redraw()
@export var forest_texture: Texture2D = preload("res://assets/environment/terrain_forest_floor.png"):
	set(v): forest_texture = v; queue_redraw()
@export var trail_texture: Texture2D = preload("res://assets/environment/terrain_trail_dirt.png"):
	set(v): trail_texture = v; queue_redraw()
@export var world_size: Vector2 = Vector2(1800.0, 1000.0):
	set(v): world_size = v; queue_redraw()

@export var tile_width: float = 64.0
@export var tile_height: float = 32.0
@export var grid_origin: Vector2 = Vector2(720.0, 100.0)
@export var grid_size: Vector2i = Vector2i(28, 22)

var _main_trail: PackedVector2Array = PackedVector2Array([
	Vector2(320, 500), Vector2(410, 506), Vector2(530, 520),
	Vector2(680, 528), Vector2(850, 524), Vector2(1020, 518),
	Vector2(1160, 532), Vector2(1264, 545)
])
var _cabin_trail: PackedVector2Array = PackedVector2Array([
	Vector2(410, 506), Vector2(440, 445), Vector2(480, 385)
])
var _alcove_trail: PackedVector2Array = PackedVector2Array([
	Vector2(680, 528), Vector2(735, 585), Vector2(790, 640)
])

# Embedded river pebbles (x, y, radius)
var _trail_pebbles: Array[Vector3] = [
	Vector3(360, 504, 2.4), Vector3(460, 512, 2.8), Vector3(580, 522, 2.5),
	Vector3(730, 530, 3.0), Vector3(890, 522, 2.6), Vector3(1060, 520, 2.8),
	Vector3(1200, 536, 3.2), Vector3(435, 465, 2.2), Vector3(465, 415, 2.5),
	Vector3(715, 560, 2.4), Vector3(765, 610, 2.8)
]

# Woodland tree cluster undergrowth glades: Vector4(center_x, center_y, radius_x, radius_y)
var _forest_glades: Array[Vector4] = [
	Vector4(310, 230, 180, 75), Vector4(530, 190, 150, 55),
	Vector4(780, 245, 180, 70), Vector4(1220, 245, 190, 75),
	Vector4(1550, 480, 160, 180), Vector4(790, 660, 150, 90),
	Vector4(220, 680, 160, 80), Vector4(620, 760, 140, 70)
]


func _ready() -> void:
	texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED


func _draw() -> void:
	# 1. ZONE A — Calm Open Meadow Turf Base (Entire World)
	if meadow_texture:
		draw_texture_rect(meadow_texture, Rect2(Vector2.ZERO, world_size), true)

	# 2. ZONE C & B — Dense Woodland Undergrowth & Shadow Glades under Tree Clusters
	for g in _forest_glades:
		_draw_textured_glade(Vector2(g.x, g.y), Vector2(g.z, g.w), 0.65)

	# 3. Glade Sunlit Accents
	draw_circle(Vector2(380, 505), 110.0, Color(0.88, 0.82, 0.50, 0.06))
	draw_circle(Vector2(480, 385), 80.0, Color(0.92, 0.80, 0.45, 0.07))
	draw_circle(Vector2(1264, 545), 95.0, Color(0.20, 0.70, 0.60, 0.06))

	# 4. Embedded Natural Worn Earth Trails
	_draw_embedded_path(_main_trail, 22.0)
	_draw_embedded_path(_cabin_trail, 18.0)
	_draw_embedded_path(_alcove_trail, 16.0)

	# 5. Weathered Ancient Flagstone Apron (at Runestone)
	var flagstones: PackedVector2Array = PackedVector2Array([
		Vector2(1226, 545), Vector2(1246, 532), Vector2(1282, 532),
		Vector2(1302, 545), Vector2(1282, 558), Vector2(1246, 558)
	])
	draw_colored_polygon(flagstones, Color(0.26, 0.30, 0.28, 0.78))
	draw_polyline(flagstones, Color(0.18, 0.22, 0.20, 0.85), 1.2, true)

	# 6. Embedded River Stones & Subtle Trail Edge Dressing
	for p in _trail_pebbles:
		var pos: Vector2 = Vector2(p.x, p.y)
		draw_circle(pos + Vector2(0.5, 0.8), p.z, Color(0.12, 0.16, 0.12, 0.45))
		draw_circle(pos, p.z, Color(0.38, 0.36, 0.30, 0.85))


func _draw_textured_glade(center: Vector2, rad: Vector2, alpha: float) -> void:
	if not forest_texture:
		return
	_draw_glade_poly(center, rad * 1.05, 0.18, true)
	_draw_glade_poly(center, rad * 1.10, alpha * 0.28, false)
	_draw_glade_poly(center, rad * 0.90, alpha * 0.45, false)


func _draw_glade_poly(center: Vector2, rad: Vector2, alpha: float, is_shadow: bool = false) -> void:
	var pts: PackedVector2Array = PackedVector2Array()
	var uvs: PackedVector2Array = PackedVector2Array()
	for i in range(16):
		var angle: float = float(i) * TAU / 16.0
		var p: Vector2 = center + Vector2(cos(angle) * rad.x, sin(angle) * rad.y)
		pts.append(p)
		if not is_shadow:
			uvs.append(p / 512.0)
	if is_shadow:
		draw_colored_polygon(pts, Color(0.04, 0.08, 0.05, alpha))
	else:
		draw_polygon(pts, PackedColorArray([Color(1, 1, 1, alpha)]), uvs, forest_texture)


func _draw_embedded_path(waypoints: PackedVector2Array, base_width: float) -> void:
	if waypoints.size() < 2:
		return
	for i in range(waypoints.size() - 1):
		var p0: Vector2 = waypoints[max(0, i - 1)]
		var p1: Vector2 = waypoints[i]
		var p2: Vector2 = waypoints[i + 1]
		var p3: Vector2 = waypoints[min(waypoints.size() - 1, i + 2)]
		var steps: int = int(max(4.0, p1.distance_to(p2) / 6.0))

		for s in range(steps):
			var t: float = float(s) / float(steps)
			var pt: Vector2 = p1.cubic_interpolate(p2, p0, p3, t)
			var w: float = base_width + sin(pt.x * 0.05 + pt.y * 0.06) * 3.5

			# Pass 1: Feathered warm earth stain (soft halo into meadow turf)
			draw_circle(pt, w * 0.95, Color(0.38, 0.35, 0.25, 0.09))
			# Pass 2: Natural compacted loam soil body
			draw_circle(pt, w * 0.65, Color(0.48, 0.42, 0.30, 0.13))
			# Pass 3: Sunlit central worn treadway
			draw_circle(pt, w * 0.35, Color(0.56, 0.50, 0.36, 0.16))

			# Natural encroaching grass blades along margins
			if (int(pt.x + pt.y) % 23 == 0):
				var norm: Vector2 = (p2 - p1).normalized().orthogonal()
				var blade_pos: Vector2 = pt + norm * (w * 0.7)
				draw_line(blade_pos, blade_pos + Vector2(-1, -4), Color(0.24, 0.38, 0.25, 0.6), 1.0)


func grid_to_world(gx: float, gy: float) -> Vector2:
	return grid_origin + Vector2((gx - gy) * tile_width * 0.5, (gx + gy) * tile_height * 0.5)


func world_to_grid(world_pos: Vector2) -> Vector2:
	var rel: Vector2 = world_pos - grid_origin
	return Vector2(
		(rel.x / (tile_width * 0.5) + rel.y / (tile_height * 0.5)) * 0.5,
		(rel.y / (tile_height * 0.5) - rel.x / (tile_width * 0.5)) * 0.5
	)
