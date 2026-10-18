# Requirements Index and Traceability

Use this index to find the source of truth for a requirement and the phase in which it should first be addressed. A listed requirement is a design target, not proof of implementation.

| ID | Requirement | Specification | First phase |
|---|---|---|---|
| R-001 | Project opens and runs main scene | `technical-requirements.md` | 0 |
| R-002 | Responsive player movement and collision | `technical-requirements.md`, `architecture.md` | 1 |
| R-003 | Isometric visual/depth sorting conventions | `art-audio-and-ui.md`, `architecture.md` | 2 |
| R-004 | Exploratory first forest with landmarks | `content-design.md`, `world-simulation.md` | 3 |
| R-005 | Cabin and kind elderly stranger | `lore-bible.md`, `content-design.md` | 4 |
| R-006 | One combat encounter | `combat-and-progression.md` | 5 |
| R-007 | Gathering and simple resource feedback | `economy-and-professions.md` | 5 |
| R-008 | One clue-supported discovery | `content-design.md`, `lore-bible.md` | 5 |
| R-009 | Spellblade basic attack, technique, rune and dodge | `combat-and-progression.md` | 6 |
| R-010 | Local save/load and separate world-specific state | `architecture.md`, `technical-requirements.md` | 7 |
| R-011 | Detailed original pixel art and audio | `art-audio-and-ui.md` | 8 |
| R-012 | Living ecology and dynamic events | `world-simulation.md` | After vertical slice |
| R-013 | Professions, player market and knowledge economy | `economy-and-professions.md` | Later |
| R-014 | Parties, guilds, dungeons, raids and PvP safeguards | `social-and-endgame.md` | Later |
| R-015 | Personal/shared worlds and dedicated servers | `multiplayer-and-networking.md` | 9 feasibility |
| R-016 | Security/authority and scale testing | `multiplayer-and-networking.md`, `technical-requirements.md` | 9 feasibility |
| R-017 | Preserve central mystery | `lore-bible.md`, `AGENTS.md` | All phases |
| R-018 | Open-source contributor workflow and licence hygiene | `workflow.md`, `AGENTS.md`, `README.md` | Before public release |

## Priority rule
When two tasks compete, prioritize:
1. Current phase acceptance criteria.
2. Stability and playability of the current slice.
3. Documentation of durable decisions and risks.
4. Long-term features only when the current milestone makes them necessary.

## Status convention
Use `Not started`, `In progress`, `Blocked`, `Validated`, or `Deferred`. Never mark a requirement `Validated` without evidence.
