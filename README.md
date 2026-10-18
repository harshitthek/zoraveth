# Zoraveth

**Zoraveth** is an original fantasy world created for an open-source isometric 2D fantasy action-RPG, developed in Godot 4.7.2 with GDScript.

> **Scope rule:** Build a small, polished, complete single-player adventure first. Defer multiplayer and MMO architecture until the core local gameplay loop is proven and stable.

## Current State

- **Engine:** Godot 4.7.2 (Official Stable).
- **Renderer:** Compatibility (`gl_compatibility`).
- **Main Scene:** `res://scenes/world.tscn`.
- **Phase:** Phase 5.1 (Environment Art Integration & World Polish) validated.

## Project Structure

```text
zoraveth/
├── AGENTS.md                  # Instructions and guardrails for AI agents
├── README.md                  # Project overview and navigation
├── LICENSE                    # Apache 2.0 open-source license
├── project.godot              # Godot 4.7 engine configuration
├── assets/                    # Handcrafted 2D sprite textures (PNG)
│   ├── characters/            # Player and Elderly Stranger sprites
│   ├── environment/           # Trees, rocks, bushes, pillars, cabin exterior
│   └── interactables/         # Moonleaf herbs and ancient runestone
├── docs/                      # World lore, design docs, art direction & decisions
├── scenes/
│   ├── world.tscn             # Project main scene (First Forest & Cabin encounter)
│   ├── player/
│   │   └── player.tscn        # Reusable Player CharacterBody2D scene
│   ├── environment/
│   │   ├── cabin_exterior.tscn# Sortable CabinExterior scene with smoke chimney
│   │   ├── tree.tscn          # Sortable IsometricTree scene (Pine)
│   │   ├── tree_ancient.tscn  # Sortable Ancient Tree scene (Landmark)
│   │   ├── pillar.tscn        # Sortable IsometricPillar scene
│   │   ├── rock.tscn          # Sortable ForestRock scene (Mossy)
│   │   └── bush.tscn          # Ambient swaying ForestBush scene
│   ├── interior/
│   │   └── cabin_interior.tscn# Cozy isometric cabin interior with fireplace & bed
│   ├── npc/
│   │   └── elderly_stranger.tscn # Reusable Elderly Stranger NPC scene
│   ├── interactables/
│   │   ├── moonleaf_herb.tscn # Gatherable Moonleaf Herb scene
│   │   └── ancient_runestone.tscn # Secret Ancient Runestone discovery scene
│   └── ui/
│       ├── dialogue_ui.tscn   # Modal dialogue panel with choice branching
│       └── exploration_ui.tscn# Contextual prompt, herb counter & discovery card
├── scripts/
│   ├── player/
│   │   └── player.gd          # Player 2D movement, collision, focus & locking
│   ├── environment/
│   │   ├── cabin_exterior.gd  # Cabin exterior doorway entry trigger
│   │   └── forest_bush.gd     # Procedural ambient swaying logic
│   ├── interior/
│   │   └── cabin_interior.gd  # Cabin interior controller & doorway exit trigger
│   ├── npc/
│   │   └── elderly_stranger.gd# Stranger NPC dialogue sequences & priority
│   ├── interactables/
│   │   ├── moonleaf_herb.gd   # Herb harvest state and petal pulse
│   │   └── ancient_runestone.gd # Inscribed clue landmark discovery logic
│   ├── ui/
│   │   ├── dialogue_ui.gd     # Dialogue progression and choice controller
│   │   └── exploration_ui.gd  # Exploration HUD management
│   └── world/
│       ├── forest_world.gd    # World coordinator, camera bounds & transitions
│       └── isometric_ground.gd# 64x32 2:1 isometric diamond grid & path renderer
└── docs/                      # Complete design bible and system specifications
    ├── asset-licenses.md      # Asset provenance and license ledger
    ├── context.md             # High-level design context and world pillars
    ├── decisions.md           # Architecture and design decision log
    ├── phases.md              # Staged development roadmap and criteria
    ├── lore-bible.md          # Canon lore, world tone, and protected mysteries
    ├── architecture.md        # Technical architecture and system boundaries
    ├── requirements-index.md  # Requirements traceability matrix
    ├── technical-requirements.md # Quality gates and acceptance criteria
    ├── open-questions.md      # Unresolved questions, risks, and mitigations
    ├── workflow.md            # Development cycle and agent templates
    ├── CHANGELOG.md           # Milestone progress log
    └── [gameplay specs]       # Combat, world simulation, economy, content, etc.
```

## Documentation Map (`docs/`)

- [docs/context.md](docs/context.md) — Core vision, world pillars, and first playable target.
- [docs/decisions.md](docs/decisions.md) — Working technical and design decisions.
- [docs/phases.md](docs/phases.md) — Staged roadmap from foundation to vertical slice.
- [docs/lore-bible.md](docs/lore-bible.md) — Worldbuilding canon and protected mysteries.
- [docs/architecture.md](docs/architecture.md) — Technical layout, conventions, and modular boundaries.
- [docs/requirements-index.md](docs/requirements-index.md) — Requirement mapping across phases.
- [docs/technical-requirements.md](docs/technical-requirements.md) — Testing standards and performance targets.
- [docs/asset-licenses.md](docs/asset-licenses.md) — Asset provenance, licensing, and attribution ledger.
- [docs/open-questions.md](docs/open-questions.md) — Known risks and unresolved questions.
- [docs/workflow.md](docs/workflow.md) — Implementation loop and review checklists.
- [docs/combat-and-progression.md](docs/combat-and-progression.md) — Combat mechanics, Spellblade class, and stats.
- [docs/world-simulation.md](docs/world-simulation.md) — Ecology, dynamic events, and world knowledge.
- [docs/economy-and-professions.md](docs/economy-and-professions.md) — Gathering, crafting, and player trade safeguards.
- [docs/content-design.md](docs/content-design.md) — Geography, quests, ancestries, and stealth.
- [docs/social-and-endgame.md](docs/social-and-endgame.md) — Dungeons, guilds, PvP safeguards, and endgame.
- [docs/multiplayer-and-networking.md](docs/multiplayer-and-networking.md) — Long-term multiplayer architecture gates.
- [docs/art-audio-and-ui.md](docs/art-audio-and-ui.md) — Visuals, camera, controls, UI, and audio guidelines.

## Development & Running

1. Open Godot 4.7.2.
2. Import the project using `project.godot`.
3. Press `F5` to run the main scene (`res://scenes/world.tscn`).

## Licensing

Code is released under the Apache License 2.0 (see [LICENSE](LICENSE)). Third-party and placeholder assets are recorded with provenance and attribution in [docs/asset-licenses.md](docs/asset-licenses.md).
