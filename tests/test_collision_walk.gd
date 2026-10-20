extends SceneTree

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var world_packed = load("res://scenes/world.tscn")
	var world = world_packed.instantiate()
	root.add_child(world)

	for i in range(10):
		await process_frame

	var p: CharacterBody2D = world.player
	world._on_cabin_enter_requested(p)

	for i in range(40):
		await process_frame

	print("Player initial pos: ", p.position)

	# Try walking UP towards fireplace (from 380, 280 up towards 185, 175)
	print("--- Walking UP-LEFT towards fireplace ---")
	p.velocity = Vector2(-200, -200).normalized() * 200.0
	for i in range(60):
		p.move_and_slide()
	print("Pos after moving up-left: ", p.position)

	# Try walking UP into north wall (towards Y = 0)
	print("--- Walking UP into north wall ---")
	p.velocity = Vector2(0, -200)
	for i in range(60):
		p.move_and_slide()
	print("Pos after moving up: ", p.position)

	# Try walking LEFT into west wall / bookshelf (towards X = -100)
	print("--- Walking LEFT into bookshelf / west wall ---")
	p.velocity = Vector2(-200, 0)
	for i in range(60):
		p.move_and_slide()
	print("Pos after moving left: ", p.position)

	# Try walking DOWN-LEFT into table
	print("--- Reset to (185, 250) and walk DOWN into table ---")
	p.position = Vector2(185, 250)
	p.velocity = Vector2(0, 200)
	for i in range(60):
		p.move_and_slide()
	print("Pos after moving down into table: ", p.position)

	world.queue_free()
	quit(0)
