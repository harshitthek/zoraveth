extends SceneTree

# Capture screenshots for cabin bookshelf inspection and bed resting

var world: Node2D = null
var player: CharacterBody2D = null
var output_dir: String = "res://screenshots/"
var brain_dir: String = "C:/Users/user/.gemini/antigravity/brain/c4731d29-dcf2-4e4d-a125-ff1579949ab2/"

func _init() -> void:
	call_deferred("_run_capture")

func _run_capture() -> void:
	print("--- STARTING CABIN INTERACTIONS SCREENSHOT CAPTURE ---")
	var success: bool = true
	var world_packed = load("res://scenes/world.tscn")
	world = world_packed.instantiate()
	root.add_child(world)

	player = world.player
	var cabin: CabinInterior = world.cabin_interior
	var dialogue_ui: DialogueUI = world.dialogue_ui

	# Allow initialization
	for i in range(12):
		await process_frame

	# Enter cabin interior
	print("Transitioning player into CabinInterior...")
	world._on_cabin_enter_requested(player)
	await create_timer(0.6).timeout

	var bookshelf: CabinBookshelf = cabin.sortable_entities.get_node_or_null("Bookshelf")
	var bed: CabinBed = cabin.sortable_entities.get_node_or_null("Bed")

	# 1. Bookshelf prompt
	print("Capturing Bookshelf Prompt...")
	player.position = Vector2(135, 225)
	for f in range(5):
		await physics_frame
	player._update_interactable_focus()
	for i in range(10):
		await process_frame
	if not _save_screenshot("audit_cabin_bookshelf_prompt.png"):
		success = false

	# 2. Bookshelf inspection dialogue
	print("Capturing Bookshelf Dialogue...")
	if bookshelf:
		bookshelf.interact(player)
		for i in range(15):
			await process_frame
		if not _save_screenshot("audit_cabin_bookshelf_dialogue.png"):
			success = false
		if dialogue_ui and dialogue_ui._is_active:
			dialogue_ui.end_dialogue()
			await process_frame

	# Wait for clue notification to fade
	await create_timer(3.6).timeout

	# 3. Bed prompt
	print("Capturing Bed Prompt...")
	player.position = Vector2(425, 265)
	for f in range(5):
		await physics_frame
	player._update_interactable_focus()
	for i in range(10):
		await process_frame
	if not _save_screenshot("audit_cabin_bed_prompt.png"):
		success = false

	# 4. Bed resting with dialogue
	print("Capturing Bed Resting Dialogue...")
	if bed:
		bed.interact(player)
		await create_timer(0.5).timeout
		player._update_interactable_focus()
		for i in range(15):
			await process_frame
		if not _save_screenshot("audit_cabin_bed_resting_dialogue.png"):
			success = false

		# 5. Dismiss dialogue to show [E] Get Up prompt while resting
		if dialogue_ui and dialogue_ui._is_active:
			dialogue_ui.end_dialogue()
			await create_timer(0.35).timeout
		for f in range(5):
			await physics_frame
		player._update_interactable_focus()
		for i in range(10):
			await process_frame
		if not _save_screenshot("audit_cabin_bed_resting_prompt.png"):
			success = false

	if not success:
		printerr("FAIL: One or more screenshots failed to save.")
		quit(1)
	else:
		print("--- CABIN INTERACTIONS SCREENSHOT CAPTURE COMPLETE ---")
		quit(0)

func _save_screenshot(filename: String) -> bool:
	var img = root.get_viewport().get_texture().get_image()
	if img == null:
		printerr("FAIL: Viewport texture image is null for ", filename)
		return false
	var global_dir: String = ProjectSettings.globalize_path(output_dir)
	DirAccess.make_dir_recursive_absolute(global_dir)
	var target_path: String = global_dir.path_join(filename)
	var err: Error = img.save_png(target_path)
	if err != OK:
		printerr("FAIL: Error saving screenshot to ", target_path, " code: ", err)
		return false
	print("Saved screenshot: ", target_path, " (result: OK)")

	if DirAccess.dir_exists_absolute(brain_dir):
		var brain_path: String = brain_dir.path_join(filename)
		img.save_png(brain_path)
	return true
