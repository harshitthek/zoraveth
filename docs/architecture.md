# Initial Technical Architecture

## Principle
Start with a small, understandable Godot project. Add structure only when a feature needs it. This is a direction, not an instruction to implement all future systems now.

## Intended folder layout
```text
Zoraveth/
├── project.godot
├── scenes/
│   ├── world.tscn
│   ├── player/
│   ├── world/
│   ├── characters/
│   └── ui/
├── scripts/
│   ├── player/
│   ├── world/
│   ├── combat/
│   └── interaction/
├── assets/
│   ├── sprites/
│   ├── tilesets/
│   ├── audio/
│   └── fonts/
├── resources/
└── docs/
```
Create folders when needed; do not create empty architecture for its own sake.

## First scene
- Main scene target: `res://scenes/world.tscn`.
- Root: `Node2D` named `World`.
- First controllable actor likely uses `CharacterBody2D`.
- Validate node APIs against the installed Godot version.

## Coordinate and visual conventions
The initial prototype uses standard Cartesian 2D physics with isometric visuals and depth sorting (`CanvasItem` Y-sorting). Keep movement/collision calculations in standard 2D space while presenting sprites and tiles with isometric projection. Final pixel-art viewport resolution and filtering settings remain provisional until tested in a small visual scene. Do not mix true-3D assumptions into the 2D project.

## State architecture
Character progression (attributes, mastery, inventory, soul powers) and world-specific state (regional flags, discoveries, unlocked shortcuts) must remain conceptually separate when save systems are introduced, ensuring future multi-world or co-op compatibility without data coupling.

## System boundaries as needed
- Player: movement, input response, player animations.
- World: environment composition and world-level connections.
- Interaction: NPC/object/resource interaction.
- Combat: attacks, damage, cooldowns, hitboxes, status effects and telegraphs.
- Progression: class/skill/character state when needed.
- Persistence: local save after meaningful state exists.
- UI: health, prompts, inventory and skill UI as gameplay needs them.
- Networking: separate feasibility prototype after the local vertical slice.

A boundary can initially be one small script. Avoid giant managers and generic frameworks.

## Data
Use Godot Resources for reusable authored data (e.g., multiple enemy/skill definitions) when a shared schema genuinely helps. Do not convert every constant into a Resource prematurely.

## Future networking
The long-term design includes personal worlds, invite-only co-op and dedicated shared worlds. No final network architecture is decided. Before implementation, define authority, request validation, persistence, reconnect behavior, latency expectations and operational costs. Do not trust clients to authoritatively decide important networked outcomes.

## Performance
Target the developer's available PC and integrated graphics early. Keep prototype maps bounded, profile before optimizing, and use sensible active simulation regions rather than updating every entity at full fidelity all the time.
