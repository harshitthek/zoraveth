# Changelog

## Phase 2 — Isometric Visual Test (2026-10-19)
- Established 2:1 isometric diamond projection convention with 64x32 pixel tiles (`tile_width = 64.0`, `tile_height = 32.0`).
- Implemented `res://scripts/world/isometric_ground.gd` drawing a 14x14 isometric diamond clearing with alternating forest terrain palette.
- Created reusable environmental scenes:
  - `res://scenes/environment/tree.tscn`: Multi-tiered pine canopy with compact base trunk collision, allowing full character occlusion and free movement behind foliage.
  - `res://scenes/environment/pillar.tscn`: Faceted stone pillar with top cap and base footprint collision.
- Refactored `res://scenes/player/player.tscn` to use foot-origin `(0, 0)` ground contact point, visual body/head offsets, ground shadow, and compact feet collision box.
- Structured `res://scenes/world.tscn` using a `SortableEntities` container (`y_sort_enabled = true`) to enable depth sorting between the player and environmental objects.
- Validated via automated script test (`test_phase2.gd`): verified 64x32 tile ratio, `y_sort_enabled` hierarchy, 4-direction Cartesian movement and diagonal velocity normalization, obstacle footprint collision, and depth sorting (tree renders in front when player is above; player renders in front when below).

## Phase 1 — Movement Sandbox (2026-10-19)
- Configured Godot Input Map actions (`move_up`, `move_down`, `move_left`, `move_right`) for WASD and Arrow Keys via `project.godot`.
- Created reusable player scene `res://scenes/player/player.tscn` using `CharacterBody2D`, `CollisionShape2D`, `Camera2D`, and placeholder visual `ColorRect`.
- Implemented `res://scripts/player/player.gd` providing normalized 4-direction movement (`Input.get_vector()`), velocity calculation with exported `speed` property, and `move_and_slide()`.
- Built movement sandbox environment in `res://scenes/world.tscn` with player instance, boundary collision walls (`StaticBody2D`), obstacle pillar, and on-screen control guide.
- Validated via automated script test and engine launch: verified all 4 movement directions, diagonal velocity normalization ($|\vec{v}| = \text{speed}$), and wall collision stopping without penetration.

## Phase 0 — Project Foundation (2026-10-19)
- Initialized local Git repository.
- Normalized project documentation into `docs/` and established top-level `AGENTS.md` and `README.md`.
- Created `docs/asset-licenses.md` to track asset provenance and licensing.
- Recorded architecture decisions for Cartesian 2D physics with isometric visuals (`CanvasItem` Y-sorting), decoupled save state architecture, and provisional presentation settings.
- Created `res://scenes/world.tscn` with a `Node2D` root named `World` and configured it as `run/main_scene` in `project.godot`.
- Updated root `.gitignore` to exclude Godot editor caches, exports, OS files, logs, and secrets.
- Validated project loading and headless main scene execution via Godot 4.7.2 (`--headless --quit-after 10`).

## Documentation baseline
- Created initial project vision, agent instructions, design decisions, lore bible, technical architecture, development phases and open questions.
- Expanded the design reference to cover combat/progression, world simulation, multiplayer, economy/professions, social/endgame, content design, presentation, technical requirements and traceability.
- Project implementation status must be verified against the actual Godot project before marking any phase complete.

## Policy
Record meaningful completed work, not planned work. Include validation results when describing implementation milestones.
