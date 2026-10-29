extends SceneTree

# Automated Test Suite for Cabin Bookshelf Inspection and Bed Resting Interactions

func _init() -> void:
	call_deferred("_run_tests")


func _run_tests() -> void:
	print("\n--- BEGIN CABIN INTERACTION TEST SUITE ---")
	var success: bool = true

	var world_packed = load("res://scenes/world.tscn")
	if not world_packed:
		printerr("FAIL: Could not load world.tscn")
		quit(1)
		return

	var world = world_packed.instantiate()
	root.add_child(world)

	for i in range(12):
		await process_frame

	var player: Player = world.player
	var cabin: CabinInterior = world.cabin_interior
	var dialogue_ui: DialogueUI = world.dialogue_ui

	# 1. Enter Cabin Interior
	print("[STEP 1] Transitioning player into CabinInterior...")
	world._on_cabin_enter_requested(player)
	await create_timer(0.6).timeout

	if not cabin.visible:
		printerr("FAIL: CabinInterior is not visible")
		success = false

	# 2. Test Bookshelf Interaction
	print("[STEP 2] Testing Bookshelf Interaction...")
	var bookshelf: CabinBookshelf = cabin.sortable_entities.get_node_or_null("Bookshelf")
	if not bookshelf:
		printerr("FAIL: Bookshelf node missing or not CabinBookshelf")
		success = false
	else:
		# Position player in front of Bookshelf on open floor
		player.position = Vector2(135, 225)
		for f in range(5):
			await physics_frame
		player._update_interactable_focus()

		var prompt: String = player._current_target.get_interaction_label() if player._current_target else ""
		if prompt != "[E] Inspect Bookshelf":
			printerr("FAIL: Expected prompt '[E] Inspect Bookshelf', got: '", prompt, "'")
			success = false
		else:
			print("  PASS: Detected prompt: ", prompt)

		# Trigger Bookshelf Inspection
		var dialogue_captured: Array[Dictionary] = []
		var clue_holder: Array[String] = []
		bookshelf.dialogue_requested.connect(func(seq: Array[Dictionary], _p: CharacterBody2D) -> void:
			dialogue_captured.append_array(seq)
		)
		bookshelf.discovered.connect(func(title: String, _desc: String) -> void:
			clue_holder.append(title)
		)

		bookshelf.interact(player)
		await process_frame

		if dialogue_captured.is_empty():
			printerr("FAIL: No dialogue sequence emitted from Bookshelf")
			success = false
		else:
			var first_text: String = dialogue_captured[0].get("text", "")
			if not first_text.begins_with("Interesting"):
				printerr("FAIL: Bookshelf dialogue does not begin with 'Interesting': ", first_text)
				success = false
			else:
				print("  PASS: Bookshelf says 'Interesting...': '", first_text, "'")

		if clue_holder.is_empty():
			printerr("FAIL: Bookshelf did not emit discovered clue signal")
			success = false
		else:
			print("  PASS: Clue discovered: '", clue_holder[0], "'")

		# Close dialogue if open
		if dialogue_ui and dialogue_ui._is_active:
			dialogue_ui.end_dialogue()
			await process_frame

	# 3. Test Bed Resting Interaction
	print("[STEP 3] Testing Bed Resting Interaction...")
	var bed: CabinBed = cabin.sortable_entities.get_node_or_null("Bed")
	if not bed:
		printerr("FAIL: Bed node missing or not CabinBed")
		success = false
	else:
		# Position player next to Bed
		player.position = Vector2(425, 265)
		for f in range(5):
			await physics_frame
		player._update_interactable_focus()

		var bed_prompt: String = player._current_target.get_interaction_label() if player._current_target else ""
		if bed_prompt != "[E] Rest in Bed":
			printerr("FAIL: Expected prompt '[E] Rest in Bed', got: '", bed_prompt, "'")
			success = false
		else:
			print("  PASS: Detected prompt: ", bed_prompt)

		# Lay Down in Bed
		print("  Laying down in bed...")
		bed.interact(player)
		# Wait for bed transition tween (0.35s + buffer)
		await create_timer(0.45).timeout

		if not bed.is_resting:
			printerr("FAIL: Bed is_resting is false after lay_down")
			success = false
		else:
			print("  PASS: Player is resting in bed")

		if player.position.distance_to(bed.rest_position) > 1.0:
			printerr("FAIL: Player position ", player.position, " not at rest_position ", bed.rest_position)
			success = false
		else:
			print("  PASS: Player positioned on bed mattress: ", player.position)

		var sprite: Sprite2D = player.get_node_or_null("Sprite2D")
		if not sprite or abs(sprite.rotation_degrees - (-60.0)) > 1.0:
			printerr("FAIL: Player sprite rotation not -60 degrees: ", sprite.rotation_degrees if sprite else null)
			success = false
		else:
			print("  PASS: Player sprite tilted to -60 degrees along bed axis")

		var shadow = player.get_node_or_null("Shadow")
		if shadow and shadow.visible:
			printerr("FAIL: Player shadow should be hidden while in bed")
			success = false
		else:
			print("  PASS: Player shadow hidden while resting")

		var col = player.get_node_or_null("CollisionShape2D")
		if col and not col.disabled:
			printerr("FAIL: Player collision should be disabled while resting")
			success = false
		else:
			print("  PASS: Player collision disabled while in bed")

		var prompt_in_bed: String = bed.get_interaction_label()
		if prompt_in_bed != "[E] Get Up":
			printerr("FAIL: Expected prompt '[E] Get Up', got: '", prompt_in_bed, "'")
			success = false
		else:
			print("  PASS: Interaction label while resting: ", prompt_in_bed)

		# Close dialogue if open
		if dialogue_ui and dialogue_ui._is_active:
			dialogue_ui.end_dialogue()
			await process_frame

		# 4. Test Getting Up from Bed
		print("[STEP 4] Getting up from bed...")
		bed.get_up()
		# Wait for get_up tween (0.3s + buffer)
		await create_timer(0.4).timeout

		if bed.is_resting:
			printerr("FAIL: Bed is_resting should be false after get_up")
			success = false
		else:
			print("  PASS: Bed is no longer occupied")

		if sprite and abs(sprite.rotation_degrees) > 0.01:
			printerr("FAIL: Player sprite rotation not reset to 0: ", sprite.rotation_degrees)
			success = false
		else:
			print("  PASS: Player sprite rotation reset to upright (0 degrees)")

		if shadow and not shadow.visible:
			printerr("FAIL: Player shadow should be restored")
			success = false
		else:
			print("  PASS: Player shadow restored")

		if col and col.disabled:
			printerr("FAIL: Player collision should be re-enabled")
			success = false
		else:
			print("  PASS: Player collision re-enabled")

		if player.is_movement_locked:
			printerr("FAIL: Player is_movement_locked should be false after getting up")
			success = false
		else:
			print("  PASS: Player movement unlocked: can move freely")

	world.queue_free()
	await process_frame

	print("\n--- SUMMARY ---")
	if success:
		print(">>> ALL CABIN INTERACTION TESTS PASSED PERFECTLY <<<")
		quit(0)
	else:
		printerr(">>> CABIN INTERACTION VALIDATION FAILED <<<")
		quit(1)
