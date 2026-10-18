# Changelog

## Phase 5 — Art Direction, Asset Pipeline & Visual Overhaul (2026-10-19)
- Established Art Direction Guide in `docs/art-direction.md`:
  - Defined two atmospheric modes: Living World (rich forest greens, warm sunlight, weathered timber) and Forgotten World (ancient basalt, chipped stone, celestial cyan luminescence).
  - Codified 2:1 isometric diamond scale matrix ($64 \times 32\text{ px}$ tiles), foot-origin $(0, 0)$ anchor convention, and compact ground collision footprints.
  - Documented UI design system: deep charcoal backgrounds, warm amber headers, cyan accents, high WCAG 2.1 AA contrast.
- Built Handcrafted Asset Pipeline with 8 core PNG textures in `assets/`:
  - `assets/environment/tree_pine.png` ($100 \times 150$) with soft shadow and pine needle layers.
  - `assets/environment/tree_ancient.png` ($140 \times 180$) towering mossy broadleaf for key landmarks.
  - `assets/environment/rock_mossy.png` ($52 \times 40$) multi-faceted boulder with overgrown lichen.
  - `assets/environment/cabin_exterior.png` ($168 \times 136$) weathered logs, shingle roof, stone chimney, and warm doorway.
  - `assets/interactables/runestone_ancient.png` ($54 \times 96$) chipped basalt monolith with inscribed glyphs.
  - `assets/interactables/moonleaf_herb.png` ($32 \times 32$) glowing turquoise botanical specimen.
  - `assets/characters/elderly_stranger.png` ($38 \times 52$) sage cloak, wool tunic, silver beard, walking staff.
  - `assets/characters/player.png` ($32 \times 48$) traveler tunic, leather mantle, and boots.
- Recorded license entries in `docs/asset-licenses.md` under Apache License 2.0.
- Overhauled Terrain Renderer in `res://scripts/world/isometric_ground.gd`:
  - Upgraded to organic multi-toned grass palettes with deterministic hash variation.
  - Added soft blended path transitions and scattered micro-details (grass blade tufts, gravel specks).
  - Removed harsh polygon wireframe outlines while keeping code $<150\text{ LOC}$.
- Upgraded Environment & Gameplay Scenes:
  - `res://scenes/environment/tree.tscn`: Uses `tree_pine.png` with compact trunk collision.
  - `res://scenes/environment/tree_ancient.tscn`: New landmark tree with `tree_ancient.png`.
  - `res://scenes/environment/rock.tscn`: Uses `rock_mossy.png` with base contact collision.
  - `res://scenes/interactables/moonleaf_herb.tscn`: Uses `moonleaf_herb.png` with biological pulse and harvest shrink.
  - `res://scenes/interactables/ancient_runestone.tscn`: Uses `runestone_ancient.png` with glowing runes and `CPUParticles2D` soul motes.
  - `res://scenes/environment/cabin_exterior.tscn`: Uses `cabin_exterior.png` with active chimney smoke particles and doorway trigger.
  - `res://scenes/interior/cabin_interior.tscn`: Added fireplace ember particles (`CPUParticles2D`) and enhanced warm timber planking.
  - `res://scenes/npc/elderly_stranger.tscn`: Uses `elderly_stranger.png` with ambient breathing idle.
  - `res://scenes/player/player.tscn`: Uses `player.png` with directional sprite flipping (`flip_h`) on horizontal movement.
  - `res://scenes/world.tscn`: Integrated 4 ancient trees alongside 23 pine trees to create organic visual pacing.
- Verified with automated headless test suite (`test_phase5.gd`): verified all 8 textures, foot origins, player movement & directional flip, collisions, gathering, runestone discovery, cabin transitions, stranger dialogue, and world scene integration with 0 failures.
- Documented technical decision `T-017` in `docs/decisions.md`.

## Phase 4 — The Cabin, The Stranger & The First Encounter (2026-10-19)
- Created reusable isometric Cabin Exterior in `res://scenes/environment/cabin_exterior.tscn` and `res://scripts/environment/cabin_exterior.gd`:
  - Timber log walls, shingle/thatch roof, warm amber doorway glow, stone chimney with smoke particles (`CPUParticles2D`), and stacked firewood.
  - Solid wall collision polygon leaving the front doorway clear.
  - Placed in the Entry Clearing at `(480, 330)` with pine backdrop tree and unobstructed approach from the meadow.
  - Doorway interaction trigger (layer 4) with `enter_requested` signal and interaction priority 10.
- Created reusable isometric Cabin Interior in `res://scenes/interior/cabin_interior.tscn` and `res://scripts/interior/cabin_interior.gd`:
  - Cozy $600 \times 450$ interior layout with timber plank floor, dark timber walls, stone fireplace with animated hearth flame flicker, resting bed with quilt/pillow, wooden dining table with clay bowl, and practical bookshelf.
  - Perimeter collision boundaries and furniture collision preventing getting stuck.
  - Exit doorway interaction trigger prompting `[E] Exit to Forest` with `exit_requested` signal.
  - Safe spawn position `(230, 240)` inside doorway threshold.
- Created Elderly Stranger NPC in `res://scenes/npc/elderly_stranger.tscn` and `res://scripts/npc/elderly_stranger.gd`:
  - Warm wool-sage cloak, tunic, silver-white beard/hair, carved walking staff, and subtle breathing idle movement.
  - Proximity interaction trigger prompting `[E] Speak with Elderly Stranger` with priority 10.
  - Full dialogue sequence acknowledging awakening, explaining rescue after strange thunder and tremors, providing warmth/rest, and giving advice for exploring the woods, with follow-up ambient dialogue.
  - Preserved 100% of protected story canon (stranger's identity, legendary battle mystery, cellar/hidden path reserved).
- Implemented dedicated Dialogue UI in `res://scenes/ui/dialogue_ui.tscn` and `res://scripts/ui/dialogue_ui.gd`:
  - CanvasLayer 10 with styled panel, amber speaker label, dialogue body text, continue prompt, and choice buttons.
  - Supports branching dialogue choices (inquiring about tremors vs thanking the stranger).
  - Automatically locks player physics movement (`is_movement_locked = true`) during active conversation, preventing accidental movement or conflicting inputs.
- Implemented robust scene transitions in `res://scripts/world/forest_world.gd`:
  - Additive subscene architecture with CanvasLayer 20 `TransitionOverlay` fade transitions.
  - Reparents player node cleanly into `CabinInterior.sortable_entities` on entry and back to forest `SortableEntities` on exit.
  - Switches camera limits dynamically between cabin bounds (`40, -20, 560, 380`) and forest bounds (`60, 80, 1600, 860`).
  - 100% preserves in-memory forest gathering node harvest states, runestone discovery status, and herb counters across repeated transitions.
- Added interaction priority weighting in `res://scripts/player/player.gd` so high-priority doorways and NPC interactions take precedence over gathering nodes.
- Validated via automated script test (`test_phase4.gd`): verified scene structure, pre-cabin gathering, cabin entry, interior camera framing, stranger dialogue progression, choice branching, player movement lock during conversation, cabin exit, exterior repositioning, and 100% preservation of forest session state.

## Phase 3 — First Forest Vertical Slice (2026-10-19)
- Expanded world environment in `res://scenes/world.tscn` to a continuous $28 \times 22$ isometric grid featuring 3 interconnected subregions:
  - **Entry Clearing (SW):** Sheltered starting copse surrounded by pine trees and faceted rocks.
  - **Woodland Route:** Winding beaten-earth trail with natural turns and a secluded herb alcove.
  - **Discovery Grove (NE):** Ancient ceremonial glade flanked by stone pillars, mossy boulders, and the Ancient Runestone.
- Upgraded `res://scripts/world/isometric_ground.gd` with parametric distance calculation for winding path waypoints, dynamically rendering beaten-earth and mossy path tiles (`path_color_a`, `path_color_b`) along the natural trail.
- Implemented gathering loop with Moonleaf Herb:
  - Created `res://scenes/interactables/moonleaf_herb.tscn` and `res://scripts/interactables/moonleaf_herb.gd` featuring biological pulse animations, interaction triggers (layer 4), visual harvest shrink revealing stem remnants, and single-collection state protection.
  - Placed 3 gatherable Moonleaf Herb nodes across the Entry Clearing, Woodland Route alcove, and Discovery Grove.
- Implemented discovery landmark with Ancient Inscribed Runestone:
  - Created `res://scenes/interactables/ancient_runestone.tscn` and `res://scripts/interactables/ancient_runestone.gd` featuring weathered monolith visuals, glowing celestial runes, floating soul motes (`CPUParticles2D`), and session discovery tracking.
  - Inscription provides atmospheric canon lore without prematurely resolving protected mysteries.
- Created reusable environmental assets:
  - `res://scenes/environment/rock.tscn`: Multi-faceted forest boulder with base collision footprint.
  - `res://scenes/environment/bush.tscn` and `res://scripts/environment/forest_bush.gd`: Multi-toned forest bush with randomized phase ambient sway.
- Upgraded player and interaction systems:
  - Added `interact` action (Key E) to Godot Input Map in `project.godot`.
  - Added `InteractionDetector` (`Area2D`, mask 4) in `res://scenes/player/player.tscn` and `res://scripts/player/player.gd`.
  - Implemented proximity focus targeting and decoupled signals: `interactable_focus_changed`, `resource_collected`, and `clue_discovered`.
  - Enabled smooth camera following on `Camera2D` with boundaries dynamically set by `res://scripts/world/forest_world.gd` (`limit_left = 60`, `limit_top = 80`, `limit_right = 1600`, `limit_bottom = 860`).
- Implemented minimal exploration HUD in `res://scenes/ui/exploration_ui.tscn` and `res://scripts/ui/exploration_ui.gd`:
  - Contextual interaction prompt pill (`[E] Gather Moonleaf Herb` / `[E] Inspect...`).
  - Compact herb collection counter (`Moonleaf Herbs: X / 3`).
  - Centered modal discovery card with tweened fade-in and automatic fade dismissal.
- Validated via automated script test (`test_phase3.gd`) verifying all 4 movement directions, diagonal normalization, herb gathering and duplicate prevention, runestone clue discovery, camera limits, and complete woodland route traversal from Entry Clearing to Discovery Grove.
- Passed mandatory CodeRabbit static review (`coderabbit review --agent --include-untracked --uncommitted`) with 0 findings.

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
