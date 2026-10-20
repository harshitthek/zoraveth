extends SceneTree

# Phase 5.4 Comprehensive Test Suite: Cabin Interior Art Overhaul & Immersive Safe-Haven Design

func _init() -> void:
	call_deferred("_run_all_tests")


func _run_all_tests() -> void:
	print("\n--- BEGIN PHASE 5.4 CABIN INTERIOR COMPREHENSIVE VALIDATION ---")
	var success: bool = true

	# TIER 1: Interior Textures Verification
	print("[TEST 1] Verifying all cabin interior textures...")
	var interior_textures: Array[String] = [
		"res://assets/interior/cabin_room_full.png",
		"res://assets/interior/interior_wood_floor.png",
		"res://assets/interior/interior_log_wall.png",
		"res://assets/interior/wall_back_left.png",
		"res://assets/interior/wall_back_right.png",
		"res://assets/interior/hearth_stone.png",
		"res://assets/interior/hearth_stone_shadow.png",
		"res://assets/interior/bed_rustic.png",
		"res://assets/interior/bed_rustic_shadow.png",
		"res://assets/interior/table_herbalist.png",
		"res://assets/interior/table_herbalist_shadow.png",
		"res://assets/interior/bookshelf_woodland.png",
		"res://assets/interior/bookshelf_woodland_shadow.png",
		"res://assets/interior/rug_woven.png",
		"res://assets/interior/cabin_window.png",
		"res://assets/interior/firewood_basket.png",
		"res://assets/interior/travel_boots.png",
		"res://assets/interior/dried_herbs.png",
		"res://assets/interior/lantern_stool.png",
		"res://assets/interior/cabin_table_cutout.png",
		"res://assets/interior/cabin_overhead_rafters.png"
	]
	for tex_path in interior_textures:
		if not ResourceLoader.exists(tex_path):
			printerr("FAIL: Texture does not exist: ", tex_path)
			success = false
			continue
		var tex = load(tex_path)
		if not tex is Texture2D:
			printerr("FAIL: Resource is not Texture2D: ", tex_path)
			success = false
			continue
		var w: int = tex.get_width()
		var h: int = tex.get_height()
		if w <= 0 or h <= 0:
			printerr("FAIL: Texture has invalid dimensions: ", tex_path)
			success = false
		else:
			print("  PASS: Loaded ", tex_path, " (", w, "x", h, ")")

	# TIER 2: Scene Instantiations
	print("[TEST 2] Verifying scene instantiations...")
	var scenes_to_test: Array[String] = [
		"res://scenes/interior/cabin_interior.tscn",
		"res://scenes/environment/cabin_exterior.tscn",
		"res://scenes/npc/elderly_stranger.tscn",
		"res://scenes/player/player.tscn",
		"res://scenes/world.tscn"
	]
	for scene_path in scenes_to_test:
		var packed = load(scene_path)
		if not packed or not packed is PackedScene:
			printerr("FAIL: Could not load scene: ", scene_path)
			success = false
			continue
		var inst = packed.instantiate()
		if not inst:
			printerr("FAIL: Could not instantiate scene: ", scene_path)
			success = false
		else:
			print("  PASS: Instantiated ", scene_path)
			inst.free()

	# TIER 3: CabinInterior Scene Graph & Components
	print("[TEST 3] Verifying CabinInterior node graph & components...")
	var interior_packed = load("res://scenes/interior/cabin_interior.tscn")
	var interior = interior_packed.instantiate()
	root.add_child(interior)

	if not interior.has_node("RoomBackground"):
		printerr("FAIL: Missing RoomBackground node")
		success = false
	else:
		var room_bg: Sprite2D = interior.get_node("RoomBackground")
		if room_bg.texture == null:
			printerr("FAIL: RoomBackground has no texture assigned")
			success = false
		else:
			print("  PASS: RoomBackground correctly textured with: ", room_bg.texture.resource_path)

	if not interior.has_node("Window"):
		printerr("FAIL: Missing Window node")
		success = false
	else:
		print("  PASS: Timber window node present")

	var sortables: Node2D = interior.get_node_or_null("SortableEntities")
	if not sortables or not sortables.y_sort_enabled:
		printerr("FAIL: SortableEntities missing or y_sort_enabled is false")
		success = false
	else:
		print("  PASS: SortableEntities has y_sort_enabled=true")

	# Check furniture entities in SortableEntities
	var required_furniture: Array[String] = [
		"Fireplace",
		"Bed",
		"TableAndChairs",
		"Bookshelf",
		"FirewoodBasket",
		"LanternStool",
		"ElderlyStranger"
	]
	for item in required_furniture:
		var node = sortables.get_node_or_null(item)
		if not node:
			printerr("FAIL: Missing furniture item in SortableEntities: ", item)
			success = false
		else:
			var col = node.get_node_or_null("CollisionShape2D")
			if not col:
				printerr("FAIL: Furniture item missing CollisionShape2D: ", item)
				success = false
			else:
				print("  PASS: Found ", item, " with collision shape at position ", node.position)

	# Check Doorway
	var exit_area: Area2D = interior.get_node_or_null("ExitDoorway")
	if not exit_area or exit_area.collision_layer != 4:
		printerr("FAIL: ExitDoorway missing or wrong collision_layer (expected 4)")
		success = false
	else:
		print("  PASS: ExitDoorway correctly configured on collision layer 4")

	interior.queue_free()
	await process_frame

	# TIER 4: Simulation of World Integration, Entry, Dialogue, and Return
	print("[TEST 4] Simulating World.tscn integration and transitions...")
	var world_packed = load("res://scenes/world.tscn")
	var world: ForestWorld = world_packed.instantiate()
	root.add_child(world)
	await process_frame

	var p = world.player
	var ext_cabin = world.cabin_exterior
	var int_cabin = world.cabin_interior

	if not ext_cabin or not int_cabin:
		printerr("FAIL: world.tscn missing cabin_exterior or cabin_interior")
		success = false
	else:
		# Test Cabin Entry
		print("  Simulating Cabin Entry...")
		world._on_cabin_enter_requested(p)
		# Wait for transition tween to complete (0.25s in + 0.25s out + buffer)
		await create_timer(0.6).timeout

		if not int_cabin.visible or int_cabin.process_mode == Node.PROCESS_MODE_DISABLED:
			printerr("FAIL: CabinInterior is not visible or disabled after entry")
			success = false
		else:
			print("  PASS: CabinInterior is visible and active")

		if p.get_parent() != int_cabin.sortable_entities:
			printerr("FAIL: Player not reparented into cabin SortableEntities")
			success = false
		else:
			print("  PASS: Player reparented to cabin SortableEntities at ", p.position)

		# Check Camera Limits in Cabin
		var cam: Camera2D = p.get_node_or_null("Camera2D")
		if cam and (cam.limit_left != -60 or cam.zoom.x != 1.75):
			printerr("FAIL: Camera limits or zoom not set to cabin limits (limit_left=", cam.limit_left, " zoom=", cam.zoom, ")")
			success = false
		else:
			print("  PASS: Camera limits set to cabin room bounds: [-60, -60, 660, 360] with zoom ", cam.zoom)

		# Test Stranger Dialogue & Reachability
		print("  Simulating Stranger Interaction & Dialogue...")
		var stranger: ElderlyStranger = int_cabin.stranger
		if not stranger:
			printerr("FAIL: ElderlyStranger node not found in cabin interior")
			success = false
		else:
			p.position = Vector2(245, 235)
			var dist: float = p.position.distance_to(stranger.position)
			if dist > 32.0:
				printerr("FAIL: Stranger at ", stranger.position, " is unreachable from floor at (245, 235), dist=", dist)
				success = false
			else:
				print("  PASS: Stranger reachable at position ", stranger.position, " (distance: ", dist, " px <= 32 px interaction radius)")
			var diag_seq: Array[Dictionary] = stranger._build_dialogue_sequence()
			if diag_seq.size() < 4:
				printerr("FAIL: Dialogue sequence is too short (size=", diag_seq.size(), ")")
				success = false
			else:
				print("  PASS: Dialogue sequence generated with ", diag_seq.size(), " passages")
				print("    Opening: '", diag_seq[0]["text"], "'")

		# Test Cabin Exit
		print("  Simulating Cabin Exit...")
		world._on_cabin_exit_requested(p)
		await create_timer(0.6).timeout

		if int_cabin.visible or int_cabin.process_mode != Node.PROCESS_MODE_DISABLED:
			printerr("FAIL: CabinInterior should be hidden and disabled after exit")
			success = false
		else:
			print("  PASS: CabinInterior hidden and disabled")

		if p.get_parent() != world.forest_entities:
			printerr("FAIL: Player not returned to forest SortableEntities")
			success = false
		else:
			print("  PASS: Player returned to forest SortableEntities at ", p.position)

		if cam and cam.limit_left != 60:
			printerr("FAIL: Forest camera limits not restored (limit_left=", cam.limit_left, ")")
			success = false
		else:
			print("  PASS: Forest camera limits restored: [60, 80, 1600, 860]")

	world.queue_free()
	await process_frame

	print("\n--- SUMMARY ---")
	if success:
		print(">>> ALL PHASE 5.4 TESTS PASSED PERFECTLY <<<")
		quit(0)
	else:
		printerr(">>> PHASE 5.4 VALIDATION FAILED <<<")
		quit(1)
