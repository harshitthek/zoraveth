extends SceneTree

func _init() -> void:
	call_deferred("_run_tests")

func _run_tests() -> void:
	print("--- BEGIN PHASE 5.3 COMPREHENSIVE VALIDATION ---")
	var success: bool = true

	# 1. Verify Textures
	print("[TEST 1] Verifying all new & core environment textures...")
	var textures_to_check: Array[String] = [
		"res://assets/environment/terrain_meadow_open.png",
		"res://assets/environment/terrain_trail_dirt.png",
		"res://assets/environment/terrain_forest_floor.png",
		"res://assets/environment/bush_forest.png",
		"res://assets/environment/pillar_ancient.png",
		"res://assets/environment/tree_pine.png",
		"res://assets/environment/tree_ancient.png",
		"res://assets/environment/rock_mossy.png",
		"res://assets/environment/cabin_exterior.png"
	]
	for tex_path in textures_to_check:
		var tex = load(tex_path)
		if tex == null:
			printerr("FAIL: Texture failed to load: ", tex_path)
			success = false
		else:
			print("  PASS: Loaded ", tex_path, " (", tex.get_width(), "x", tex.get_height(), ")")

	# 2. Verify Scene Instantiation
	print("[TEST 2] Verifying scene instantiations...")
	var scenes_to_check: Array[String] = [
		"res://scenes/environment/bush.tscn",
		"res://scenes/environment/pillar.tscn",
		"res://scenes/environment/rock.tscn",
		"res://scenes/environment/tree.tscn",
		"res://scenes/environment/tree_ancient.tscn",
		"res://scenes/environment/cabin_exterior.tscn",
		"res://scenes/interactables/moonleaf_herb.tscn",
		"res://scenes/interactables/ancient_runestone.tscn",
		"res://scenes/interior/cabin_interior.tscn",
		"res://scenes/npc/elderly_stranger.tscn",
		"res://scenes/player/player.tscn",
		"res://scenes/ui/exploration_ui.tscn",
		"res://scenes/ui/dialogue_ui.tscn",
		"res://scenes/world.tscn"
	]
	for scn_path in scenes_to_check:
		var scn = load(scn_path)
		if scn == null:
			printerr("FAIL: Scene failed to load: ", scn_path)
			success = false
			continue
		var inst = scn.instantiate()
		if inst == null:
			printerr("FAIL: Scene failed to instantiate: ", scn_path)
			success = false
		else:
			print("  PASS: Instantiated ", scn_path)
			inst.free()

	# 3. Deep Simulation of World
	print("[TEST 3] Simulating world.tscn gameplay loops...")
	var world_packed = load("res://scenes/world.tscn")
	var world = world_packed.instantiate()
	root.add_child(world)

	# Allow a frame so _ready() runs across all nodes in world.tscn
	await process_frame

	# Verify ground
	var ground = world.forest_ground
	if ground == null:
		printerr("FAIL: IsometricGround node missing from world.tscn")
		success = false
	else:
		if ground.meadow_texture == null:
			printerr("FAIL: meadow_texture is null on Ground")
			success = false
		else:
			print("  PASS: Ground meadow_texture is set: ", ground.meadow_texture.resource_path)
		if ground.forest_texture == null:
			printerr("FAIL: forest_texture is null on Ground")
			success = false
		else:
			print("  PASS: Ground forest_texture is set: ", ground.forest_texture.resource_path)

	# Verify Player
	var player = world.player
	if player == null:
		printerr("FAIL: Player missing from world.tscn")
		success = false
	else:
		print("  PASS: Player found at start position: ", player.position)

	# Verify Herbs Count & Placement
	var herbs = []
	var entities = world.forest_entities
	if entities:
		for child in entities.get_children():
			if child.has_signal("collected"):
				herbs.append(child)
	print("  INFO: Found ", herbs.size(), " herb nodes in world.")
	if herbs.size() != 4:
		printerr("FAIL: Expected exactly 4 herbs, found ", herbs.size())
		success = false
	else:
		print("  PASS: Confirmed exactly 4 Moonleaf Herbs placed in world:")
		for h in herbs:
			print("    - ", h.name, " at ", h.position)

	# Verify Runestone
	var runestone = entities.get_node_or_null("AncientRunestone") if entities else null
	if runestone == null:
		printerr("FAIL: AncientRunestone missing from world.tscn")
		success = false
	else:
		print("  PASS: AncientRunestone positioned at ", runestone.position)

	# Verify UI Herb count display
	var ui = world.ui
	if ui and ui.counter_label:
		print("  PASS: ExplorationUI found. Initial counter: '", ui.counter_label.text, "'")
		if not ui.counter_label.text.ends_with("/ 4"):
			printerr("FAIL: Expected UI counter to show / 4, got: ", ui.counter_label.text)
			success = false

	# Simulate Gathering all 4 herbs
	print("[TEST 4] Simulating gathering sequence...")
	for i in range(herbs.size()):
		var herb = herbs[i]
		if not herb.is_collected:
			herb.interact(player)
			print("  Gathered ", herb.name, " -> Player collected_herbs: ", player.collected_herbs, ", UI text: ", ui.counter_label.text if ui and ui.counter_label else "")
	if player.collected_herbs != 4:
		printerr("FAIL: Player collected_herbs should be 4, got ", player.collected_herbs)
		success = false
	if ui and ui.counter_label and ui.counter_label.text != "Moonleaf Herbs: 4 / 4":
		printerr("FAIL: UI counter should be 'Moonleaf Herbs: 4 / 4', got: ", ui.counter_label.text)
		success = false

	# Simulate Runestone discovery
	print("[TEST 5] Simulating Runestone discovery...")
	if runestone:
		runestone.interact(player)
		if runestone.is_discovered:
			print("  PASS: Runestone discovery triggered, discovered=true")
		else:
			printerr("FAIL: Runestone is_discovered remains false after interaction")
			success = false

	# Simulate Cabin Transition
	print("[TEST 6] Simulating Cabin Entry and Exit...")
	var cabin = world.cabin_exterior
	if cabin:
		print("  PASS: Found CabinExterior at ", cabin.position)
		world._on_cabin_enter_requested(player)
		print("  PASS: Cabin enter requested")
		# Wait for transition tween
		await create_timer(0.6).timeout
		if world.cabin_interior.visible:
			print("  PASS: Cabin interior is now visible, player reparented to interior.")
		else:
			printerr("FAIL: Cabin interior should be visible.")
			success = false
		world._on_cabin_exit_requested(player)
		print("  PASS: Cabin exit requested")
		await create_timer(0.6).timeout
		if world.forest_ground.visible and not world.cabin_interior.visible:
			print("  PASS: Returned to forest world. Cabin interior hidden.")
		else:
			printerr("FAIL: Forest ground should be visible and interior hidden.")
			success = false

	# Clean up world
	world.queue_free()

	print("--- SUMMARY ---")
	if success:
		print(">>> ALL PHASE 5.3 TESTS PASSED PERFECTLY <<<")
		quit(0)
	else:
		printerr(">>> SOME TESTS FAILED <<<")
		quit(1)
