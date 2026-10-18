# Decision Log

These are established working decisions, not a claim that all systems are implemented. If a decision changes, append the new decision and explain the reason.

## Product and world
- **D-001 World name:** Zoraveth is the fantasy world's name; game title is undecided.
- **D-002 Genre:** Original isometric 2D fantasy action-RPG with a long-term MMORPG ambition.
- **D-003 Art:** Detailed pixel art; vibrant enchanted wilderness contrasts with atmospheric ruins and dangerous frontier.
- **D-004 Core experience:** Discovery, belonging in a living world, and personal mastery are equally important.
- **D-005 World pillars:** Living ecology, forgotten civilizations, mysterious magic, and unexplored frontier are interconnected.
- **D-006 Historical knowledge:** Folklore for ordinary people; competing scholarly interpretations; powerful groups know more; nobody knows the full truth.
- **D-007 Central mystery:** Its exact question and answer remain undecided.
- **D-008 Opening:** Legendary battle, unexplained event, waking in a cabin, kind elderly stranger; identity and connection unresolved.
- **D-009 First region:** Large-feeling forest with subregions, enemy territories, ruins, gathering and systemic variation; first implementation remains bounded.
- **D-010 Stranger:** Warm and genuinely kind, apparently ordinary, with subtle signs of deeper knowledge.
- **D-011 Magic:** Nature, ancient civilization and soul powers are connected somehow; final explanation unknown.
- **D-012 First class:** Spellblade: elemental sword magic, tactical runes and evolving personal soul powers.
- **D-013 First milestone:** Complete mini-adventure with exploration, NPC interaction, creature combat, gathering and one discovery.
- **D-014 Development:** Open-source project with staged public development.
- **D-015 Release sequence:** Movement demo → exploration prototype → complete adventure → multiplayer testing.

## Gameplay
- **D-016 Power:** Multiple meaningful sources: level, weapon mastery, gear, class progression, soul powers and discoveries.
- **D-017 Combat:** Real-time movement/dodging, target assistance, cooldowns, weapon combos and flexible party roles.
- **D-018 Skill:** Preparation, mastery and tactics can let lower-level players overcome stronger enemies.
- **D-019 Ecology:** Creatures hunt, flee, defend, gather and react to time, weather and threats, within practical simulation limits.
- **D-020 Discovery:** Secrets use clues, experimentation, rumours and research; avoid arbitrary guesswork.
- **D-021 World change:** Major milestones can affect shared history, with safeguards for continued content access.
- **D-022 Economy:** Player-driven trade for ordinary resources/crafted equipment; safeguards against monopoly over exclusive discoveries.
- **D-023 Classes:** Choose a core class at creation; advanced paths and personal mastery create variation. First prototype uses one class.
- **D-024 Class roster direction:** Roughly 8–10 eventual core classes; concepts may include Soul Weaver, Beast Caller, Rune Knight, Spellblade and Shadow Dancer.
- **D-025 PvP:** Optional arenas/duels and safeguarded contested regions; ordinary areas protected.
- **D-026 Monetization direction:** Free-to-play, cosmetic-only; no pay-to-win or selling rare discoveries.
- **D-027 Camera:** Stable isometric view, adjustable zoom, limited contextual rotation and occasional cinematic framing.
- **D-028 Movement:** Grounded basics; advanced mobility/traversal earned through class progression or discovery.
- **D-029 Time:** Shared clock/weather in the intended online world; time can affect ambience, creatures, plants and discoveries.
- **D-030 Fairness:** Major secrets can be difficult, but important progression should not be permanently monopolized.

## Technical
- **T-001 Engine:** Godot 4.7.2 selected for now; re-evaluate only if a concrete limitation appears.
- **T-002 Language:** GDScript.
- **T-003 Renderer:** Compatibility.
- **T-004 Platform:** Windows-first development; avoid unnecessary platform-specific coupling.
- **T-005 Version control:** Git.
- **T-006 First scope:** Local single-player prototype; no online infrastructure until the vertical slice works.
- **T-007 Art pipeline:** Programmer art first; use original or properly licensed art later.
- **T-008 Architecture:** Modular when needed, simple at first; avoid premature general frameworks.
- **T-009 Validation:** Never claim a feature works without testing or clearly stating it remains unverified.
- **T-010 Licensing:** Code is licensed under Apache License 2.0 (see LICENSE); asset licensing is recorded in `docs/asset-licenses.md`.
- **T-011 Coordinate & physics model:** The initial prototype uses standard Cartesian 2D physics with isometric visuals and depth sorting (CanvasItem Y-sorting).
- **T-012 State architecture separation:** Character progression (attributes, mastery, inventory, soul powers) and world-specific state (regional flags, discoveries, unlocked shortcuts) must remain conceptually separate when save systems are introduced.
- **T-013 Presentation baselines:** Final pixel-art viewport resolution and texture filtering settings remain provisional until tested in a small visual scene.
- **T-014 Tile convention and visual sorting:** Standard 2:1 isometric diamond projection with 64x32 pixel tiles (`tile_width = 64`, `tile_height = 32`). Entities use foot-origin `(0, 0)` ground contact points, separating visual height from compact ground collision footprints. Visual depth sorting is managed by `CanvasItem.y_sort_enabled = true` on parent container nodes.
- **T-015 Interaction and discovery signal architecture:** Environmental interactables utilize `Area2D` on collision layer 4 with dedicated trigger shapes. Player detects proximity via `InteractionDetector` (`Area2D`, mask 4) and emits decoupled signals (`interactable_focus_changed`, `resource_collected`, `clue_discovered`) to decouple gameplay/input from HUD presentation (`ExplorationUI`). Discovery states are session-tracked on landmark entities without premature persistent save frameworks.
- **T-016 Additive interior subscene transition and dialogue state management:** Transitions between forest and interior environments use an additive subscene model in `ForestWorld` without tree reloads or global singletons. Entering the cabin disables forest processing/visibility, reparents the player into the interior sortable hierarchy, updates camera limits, and performs a screen fade; exiting restores the forest and positions the player outside the doorway, preserving 100% of in-memory gathering and discovery state. Dialogue operates through `DialogueUI` on layer 10, temporarily locking player physics processing (`is_movement_locked = true`) and offering branching choices without interrupting exploration systems.
