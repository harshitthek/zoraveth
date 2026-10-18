# Development Phases

No fixed dates. Complete and validate each phase before expanding scope.

## Phase 0 — Project foundation
- [x] Inspect existing project and Git status.
- [x] Create a clean folder structure only as needed.
- [x] Create `res://scenes/world.tscn` with `Node2D` root named `World`.
- [x] Configure main scene and verify F5 launches it.
- [x] Validate project opens without unexplained errors.
**Done when:** the project opens and runs its main scene; diff is reviewed.

## Phase 1 — Movement sandbox
- [x] Define input actions.
- [x] Add player scene, likely `CharacterBody2D`.
- [x] Implement responsive movement and collision.
- [x] Add temporary visual representation and following camera.
- [x] Decide/test the 2D isometric coordinate convention.
**Done when:** player moves consistently, collides with obstacles, remains visible and controls are documented.

## Phase 2 — Isometric visual test
- [x] Establish tile/world scale, sorting, collision footprints and zoom limits.
- [x] Add placeholder ground, trees, rocks and obstacles.
- [x] Validate occlusion and readability.
**Done when:** character/environment overlap predictably and the scene runs stably on target hardware.

## Phase 3 — First forest
- [x] Build a bounded but exploratory continuous forest with natural routes.
- [x] Add a few subregions and memorable landmarks.
- [x] Add gathering placeholders and one hidden clue.
- [x] Add day/night ambience only if it does not block core play (ambient swaying bushes, soul motes, terrain transitions).
**Done when:** exploration is legible and one optional discovery exists. (Completed and validated).

## Phase 4 — Cabin and NPC
- [x] Create cabin and clearing (isometric cabin exterior with smoke chimney and clear approach in Entry Clearing).
- [x] Add interactable elderly stranger and basic dialogue (DialogueUI with choices, movement locking, warm hearth interior).
- [x] Establish kindness and subtle unexplained details (rest, warmth, strange thunder, distant tremors).
- [x] Preserve the stranger's identity and the underground revelation (cellar/hidden path untouched, identity unresolved).
**Done when:** player can approach and interact and the atmosphere works. (Completed and validated).

## Phase 5 — Art direction, asset pipeline & visual overhaul
- [x] Establish comprehensive art direction guide (`docs/art-direction.md`) with Living World and Forgotten World atmospheric palettes.
- [x] Implement asset pipeline and integrate 8 handcrafted transparent PNG assets for pine trees, ancient trees, mossy rocks, cabin exterior, ancient runestone, moonleaf herbs, elderly stranger, and player adventurer.
- [x] Update asset licensing catalog in `docs/asset-licenses.md` under Apache 2.0.
- [x] Upgrade terrain renderer to multi-toned deterministic organic grass, soft path transitions, and micro-details, eliminating geometric wireframes.
- [x] Implement foot-origin `(0, 0)` anchor conventions across all sprites with pass-behind canopy sorting and compact collision footprints.
- [x] Add directional sprite flipping to Player based on velocity.
- [x] Add ambient particle effects (runestone soul motes, cabin chimney smoke, fireplace embers).
- [x] Verify visual overhaul with automated headless test suite (`test_phase5.gd`).
**Done when:** prototype looks cohesive, painterly, and atmospheric without breaking existing mechanics. (Completed and validated).

## Phase 5.1 — Environment art integration & world polish
- [x] Eliminate the checkerboard appearance in `isometric_ground.gd` via harmonic low-frequency spatial clustering, broad meadow transitions, and edge darkening.
- [x] Create a natural, winding branched trail with soft mossy borders connecting Entry Meadow, Cabin Doorstep, Woodland Trail, Secluded Herb Alcove, and Ancient Discovery Grove.
- [x] Fix pale fringe/cutout halos around tree roots, rocks, and runestone in source textures.
- [x] Replace geometric vector bushes and pillars with handcrafted painterly sprites (`bush_forest.png`, `pillar_ancient.png`).
- [x] Recompose trees and props in `scenes/world.tscn` into natural woodland clusters, open clearings, and focal sightlines.
- [x] Refine ExplorationUI with sleek, discreet badges, high-contrast typography, and tactile interaction prompt pills.
- [x] Validate via automated test suite (`test_phase5_1.gd`) with 0 failures.
**Done when:** the forest feels like a unified, handcrafted fantasy RPG environment with readable paths, organic composition, and no checkerboard grid. (Completed and validated).

## Phase 5.2 — Terrain rework & environment composition
- [x] Replace discrete diamond tile polygons with continuous seamless painterly forest floor canvas (`terrain_forest_floor.png`, 512x512) covering the entire world.
- [x] Rebuild dirt trails as continuous, smooth multi-pass organic ribbons (transition border, compacted earth, worn footway) with embedded stepping stones and edge grass tufts.
- [x] Eliminate circular miniature tabletop pedestal disc from `tree_pine.png`, giving authentic root flares meeting the ground naturally.
- [x] Generate high-resolution handcrafted painterly assets for `bush_forest.png` ($64 \times 52$) and `pillar_ancient.png` ($44 \times 88$) with transparent backgrounds and organic ground contact.
- [x] Remove obsolete primitive rune polygon from `ancient_runestone.tscn` and soften contact shadows across all environmental props.
- [x] Recompose entire forest scene (`scenes/world.tscn`) into deliberate foreground, middle ground, and background canopy layers with clear sightlines and asymmetric clusters.
- [x] Full simulation test suite passed with 0 errors (`test_phase5_2_full.gd`).
**Done when:** the forest environment is naturally composed with seamless terrain, continuous winding dirt paths, and cohesive painterly assets. (Completed and validated).

## Phase 6 — Spellblade foundation
- [ ] Basic weapon attack.
- [ ] One elemental sword technique.
- [ ] One tactical rune/ability.
- [ ] Cooldown/resource conventions.
- [ ] Dodge and readable enemy telegraphs.
**Done when:** the class has a distinct, enjoyable core loop.

## Phase 7 — Local persistence
- [ ] Save/load a small progression record.
- [ ] Persist one discovered clue and one progression value.
- [ ] Separate character state from world-specific discovery state.
- [ ] Handle invalid/missing/older save data.
**Done when:** progress survives restart and failure does not silently corrupt the only save.

## Phase 8 — Vertical slice
- [ ] Replace selected placeholders with original/licensed pixel art.
- [ ] Add basic audio and improve UI/feedback/onboarding.
- [ ] Add an optional route/lore fragment and another encounter variation.
- [ ] Profile and fix important performance issues.
**Done when:** the short adventure is compelling enough for external feedback.

## Phase 9 — Multiplayer feasibility
Only after the vertical slice is stable:
- [ ] Design authority/security model.
- [ ] Prototype two players in a small test scene.
- [ ] Test latency, disconnect/reconnect and world-state handling.
- [ ] Evaluate personal-world hosting versus dedicated shared-world servers.
- [ ] Estimate operational cost and scale with measurements.
**Done when:** feasibility is documented; this does not imply MMO scale is solved.

## Phase 10 — Broader world
Expand regions, professions, factions, ecology, quests, group encounters, guilds and discovery systems in staged releases with acceptance criteria.

## Release order
Movement demo → exploration prototype → complete first adventure → expanded vertical slice → multiplayer testing → broader open-development releases.
