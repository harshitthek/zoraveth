extends SceneTree

var world: Node2D = null
var player: CharacterBody2D = null
var output_dir: String = "res://screenshots/"
var brain_dir: String = "C:/Users/user/.gemini/antigravity/brain/c4731d29-dcf2-4e4d-a125-ff1579949ab2/"

func _init() -> void:
	call_deferred("_run_capture")

func _run_capture() -> void:
	print("--- STARTING CABIN INTERIOR SCREENSHOT CAPTURE ---")
	var success: bool = true
	var world_packed = load("res://scenes/world.tscn")
	world = world_packed.instantiate()
	root.add_child(world)

	player = world.player

	# Allow initialization and shaders to warm up
	for i in range(12):
		await process_frame

	# Enter cabin interior
	print("Transitioning player into CabinInterior...")
	world._on_cabin_enter_requested(player)

	# Wait for transition fade to complete (0.25s fade out + 0.25s fade in + buffer)
	for i in range(40):
		await process_frame

	print("Player position in cabin:", player.position)

	# 1. Full Interior Overview (Camera centered on room)
	print("Capturing Cabin Interior Overview...")
	player.position = Vector2(360, 240)
	for i in range(10):
		await process_frame
	if not _save_screenshot("audit_cabin_interior_overview.png"):
		success = false

	# 2. Hearth & Bookshelf Nook
	print("Capturing Hearth & Bookshelf Nook...")
	player.position = Vector2(180, 210)
	for i in range(10):
		await process_frame
	if not _save_screenshot("audit_cabin_interior_hearth.png"):
		success = false

	# 3. Work Table & Elderly Stranger
	print("Capturing Work Table & Stranger...")
	player.position = Vector2(250, 230)
	for i in range(10):
		await process_frame
	if not _save_screenshot("audit_cabin_interior_stranger.png"):
		success = false

	# 4. Bed & Window Alcove
	print("Capturing Bed & Window Alcove...")
	player.position = Vector2(430, 240)
	for i in range(10):
		await process_frame
	if not _save_screenshot("audit_cabin_interior_bed_window.png"):
		success = false

	if not success:
		printerr("FAIL: One or more screenshots failed to save.")
		quit(1)
	else:
		print("--- CABIN INTERIOR SCREENSHOT CAPTURE COMPLETE ---")
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
