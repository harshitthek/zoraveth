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
- [ ] Establish tile/world scale, sorting, collision footprints and zoom limits.
- [ ] Add placeholder ground, trees, rocks and obstacles.
- [ ] Validate occlusion and readability.
**Done when:** character/environment overlap predictably and the scene runs stably on target hardware.

## Phase 3 — First forest
- [ ] Build a bounded but exploratory continuous forest with natural routes.
- [ ] Add a few subregions and memorable landmarks.
- [ ] Add gathering placeholders and one hidden clue.
- [ ] Add day/night ambience only if it does not block core play.
**Done when:** exploration is legible and one optional discovery exists.

## Phase 4 — Cabin and NPC
- [ ] Create cabin and clearing.
- [ ] Add interactable elderly stranger and basic dialogue.
- [ ] Establish kindness and subtle unexplained details.
- [ ] Preserve the stranger's identity and the underground revelation.
**Done when:** player can approach and interact and the atmosphere works.

## Phase 5 — Complete mini-adventure
- [ ] Add one creature encounter and minimal combat.
- [ ] Add one gatherable resource and inventory feedback.
- [ ] Add one meaningful, clue-supported discovery.
- [ ] Provide a short start-to-finish path.
**Done when:** a new player can explore, interact, fight, gather and discover something.

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
