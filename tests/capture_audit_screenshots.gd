extends SceneTree

var world: Node2D = null
var player: CharacterBody2D = null
var output_dir: String = "res://screenshots/"
var brain_dir: String = "C:/Users/user/.gemini/antigravity/brain/c4731d29-dcf2-4e4d-a125-ff1579949ab2/"

func _init() -> void:
	call_deferred("_run_capture")

func _run_capture() -> void:
	print("--- STARTING GRAPHICAL SCREENSHOT CAPTURE ---")
	var success: bool = true
	var world_packed = load("res://scenes/world.tscn")
	world = world_packed.instantiate()
	root.add_child(world)

	player = world.player

	# Allow initialization and shaders to warm up
	for i in range(10):
		await process_frame

	# 1. Entry Area
	print("Capturing Entry Area...")
	player.position = Vector2(368, 480)
	for i in range(6):
		await process_frame
	if not _save_screenshot("audit_entry_area.png"):
		success = false

	# 2. Cabin Approach
	print("Capturing Cabin Approach...")
	player.position = Vector2(460, 420)
	for i in range(6):
		await process_frame
	if not _save_screenshot("audit_cabin_approach.png"):
		success = false

	# 3. Woodland Route
	print("Capturing Woodland Route...")
	player.position = Vector2(750, 520)
	for i in range(6):
		await process_frame
	if not _save_screenshot("audit_woodland_route.png"):
		success = false

	# 4. Discovery Grove
	print("Capturing Discovery Grove...")
	player.position = Vector2(1240, 540)
	for i in range(6):
		await process_frame
	if not _save_screenshot("audit_discovery_grove.png"):
		success = false

	if not success:
		printerr("FAIL: One or more screenshots failed to save.")
		quit(1)
	else:
		print("--- SCREENSHOT CAPTURE COMPLETE ---")
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

