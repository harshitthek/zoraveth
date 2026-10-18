# Zoraveth — Agent Context

Read this file and `AGENTS.md` first. For a task, also read the relevant system specification, `decisions.md`, `phases.md`, `architecture.md`, and `requirements-index.md`.

## Identity and current status

- **Zoraveth** is the name of the fantasy world. The final game title is undecided.
- Original isometric 2D fantasy action-RPG; long-term MMORPG ambition.
- Godot 4.7.2 selected, GDScript, Compatibility renderer, Git.
- Local project path selected: `E:\projects\zoraveth`.
- Project editor opened successfully; do not assume a runnable main scene exists until checked.
- Developer has programming experience but is new to game development.
- Antigravity is an implementation assistant; it must inspect, explain, validate and report changes.

## Core player experience

Discovery, belonging in a living world, and personal mastery are equally important.

## World pillars

1. Living world and ecology.
2. Forgotten civilizations and incomplete historical evidence.
3. Mysterious magic linking nature, ancient civilizations and personal soul powers, without a known final explanation.
4. An expansive, dangerous frontier that rewards preparation and curiosity.

Ordinary people know folklore and fragments. Scholars debate conflicting evidence. Powerful groups know more, but nobody has the complete truth.

## First playable target

A small, complete forest adventure containing:
- Responsive movement in an isometric-feeling 2D space.
- A cabin and kind elderly stranger.
- Exploration, a basic creature encounter, gathering, interaction and one meaningful discovery.
- Spellblade as the first playable class, eventually blending elemental sword magic, tactical runes and personal soul powers.
- Temporary graphics first; detailed original pixel art after the basic loop works.

## Opening story — unresolved by design

The player sees a battle involving a legendary being; something inexplicable happens. They later wake in a small cabin near a forest, where a kind elderly stranger found them unconscious and helped them. The stranger seems ordinary and genuinely kind, but subtle details suggest undisclosed knowledge. Much later, a clue directs the player back to the cabin, where a hidden path exists beneath the house.

Do not determine the battle's true nature, the stranger's identity, the path's destination, or the final mystery without explicit approval. These are intentionally unresolved.

## Scope

Build in this order: project foundation → movement → visual/isometric test → first forest → cabin/NPC → complete mini-adventure → Spellblade foundation → local persistence → polished vertical slice → multiplayer feasibility prototype.

Do not implement networking, MMO infrastructure, a large class roster, a complete economy, or a giant procedural world in the first prototype.
