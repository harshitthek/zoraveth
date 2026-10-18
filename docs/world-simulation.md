# World Simulation Specification

## Goals
Make Zoraveth feel alive without attempting an expensive simulation of every object everywhere. The world should behave consistently, communicate changes clearly and reward observation.

## Time, weather and ambience
- Intended world has a shared clock/weather system.
- Time/weather can affect ambience, creature activity, plants, events and discoveries.
- Some secrets can be time-dependent, but clues or alternate conditions must keep them solvable.
- Use local time/weather effects in early prototypes only when they improve the current experience.

## Ecology
Creatures may:
- Hunt, flee, defend territories, gather or rest.
- React to time, weather, threats and disturbances.
- Migrate or alter behaviour based on population/environment within limits.
- Remember individual encounters or repeated player tactics in selected cases.
- Be studied through observation, NPC expertise, bestiary records and direct encounters.

Use finite state machines or another simple, testable approach where appropriate. Do not add elaborate simulation before a small encounter works.

## Living ecosystem and adaptation
- Rare mutations/population changes can occur but must not permanently devastate a region.
- Creature memory/adaptation should be limited, readable and counterable.
- Player actions can alter a region; settlements and ecosystems should have recovery mechanisms.
- Settlement recovery can be community-driven and/or natural.
- Important changes should be legible through world state, rumours, signs or NPC reactions.

## Dynamic events
- Public events can be announced.
- Smaller regional changes may be discovered through clues, local signs and rumours.
- Legendary events may require investigation rather than global announcements.
- Events can progress when players ignore them; consequences should be understandable and not arbitrarily punish players for missing content.
- Safeguards should preserve meaningful access to core content.

## Legendary creatures
- Treat legendary creatures as living legends connected to ecology and history, not just high-HP enemies.
- They may migrate or react to disturbances.
- Discovery may involve legends, research, environmental conditions, ecology, ruins, or accidental triggers.
- Defeat may permanently record a discovery, change a region, cause a creature to disappear, or allow a later return depending on the encounter.
- Provide alternate challenge/access paths where necessary so one player's actions do not permanently deny others content.

## World knowledge
- Bestiary and research records can be layered: observation, expert knowledge, direct encounters and discovered clues.
- Private journals and shared archives may coexist.
- Players control what knowledge they share; rumours spread organically.
- Knowledge/map/guide trading can be part of the economy, but core progress must remain independently attainable.
- Credit can track first clues, triggers and contributors, including group participation.

## Simulation budget
- Simulate nearby entities at high fidelity.
- Use simplified state updates for distant entities where needed.
- Make systems deterministic or reproducible where useful for debugging.
- Expose debug indicators/logs during development.
- Profile before adding complexity.
