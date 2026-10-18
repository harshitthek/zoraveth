# Combat and Progression Specification

This is a design specification for future implementation. It does not mean these systems already exist. Build only what the current phase needs.

## Combat identity
Real-time action combat combines movement and dodging, target assistance, cooldown-based skills, weapon combos, readable telegraphs and tactical preparation. Controls should feel responsive, while heavy actions may have meaningful commitment and clear animation/telegraph windows.

## First class: Spellblade
Core identity: elemental sword magic, tactical runes, and evolving personal soul powers.
Prototype order:
1. Movement and facing.
2. Basic weapon attack with a clear hit window.
3. One readable enemy and damage response.
4. Directional dodge.
5. One elemental sword technique.
6. One tactical rune/ability.
7. Resource/cooldown feedback.
Do not implement a full class framework before one class is fun.

## Power sources
Long-term character strength can come from:
- Character level and baseline attributes.
- Weapon familiarity/mastery.
- Gear stats and special mechanics.
- Core class and specialization.
- Learned skills and advanced techniques.
- Personal soul powers/evolution.
- Discoveries, preparation and encounter knowledge.
Avoid an endless numerical treadmill that invalidates old accomplishments.

## Stats and resources
Design direction:
- Keep core stats understandable while derived effects can be deeper.
- Baseline stat growth can be automatic with a modest specialization choice.
- Classes may use different resources such as stamina, mana, rage, focus, charges or soul energy.
- Recovery depends on the resource and situation.
- Consumables and preparation matter more in dangerous expeditions.
These are future design targets; exact formulas and resource names remain open until combat prototypes provide evidence.

## Classes and builds
- Player chooses a core class at character creation.
- Class identity remains meaningful.
- Advanced paths, weapon choices, mastery and soul evolution create variation.
- Long-term target is roughly 8–10 core classes; possible concepts include Soul Weaver, Beast Caller, Rune Knight, Spellblade and Shadow Dancer. Final roster/names are not locked.
- Class switching may eventually be available through trainers/quests/services with costs; previous mastery remains valuable.
- Builds may creatively hybridize but should require investment and trade-offs.

## Skills and combinations
- Core skills use clear structured progression.
- Advanced techniques can come from research, experimentation, environmental clues and hidden knowledge.
- Design readable combos, then add consistent interactions with elements, terrain, weather, enemy biology and soul powers.
- Preserve counterplay and understandable feedback.
- Rare discoveries may be extraordinary, but should have costs, counters, weaknesses or situational constraints.

## Boss and enemy principles
- Bosses should reward mechanical skill, preparation, research, discovery and teamwork.
- Readable telegraphs and danger cues coexist with uncertainty in wilderness.
- Creature behaviour matters in addition to level.
- Some important creatures can learn repeated tactics in limited, readable and counterable ways.
- Ordinary bosses can respawn; legendary encounters may be recorded in history or change the world. Alternate challenges/access paths should prevent permanent content lockout.

## Soul powers and resonance
- Personal soul powers may emerge from habits, choices, discoveries and pivotal experiences.
- Soul evolutions can branch, refine or change, with meaningful trade-offs.
- Rare rituals/quests/resources may allow respec/reversal while retaining historical records.
- Cooperative resonance can arise from compatible powers, formations, environment and coordinated actions.
- Partner resonance can evolve with both participants; group resonance may support three or more players.
- First discovery can receive historical credit; once discovered, techniques should be reproducible through knowledge and mastery.
All resonance mechanics are long-term design goals, not prototype requirements.

## Death, healing and status
- Ordinary deaths should be forgiving; selected dangerous regions/challenges can impose harsher contextual costs.
- Healing/support classes are useful but not mandatory; each class should have ways to sustain itself.
- Healing/resource recovery can depend on context.
- Status effects should interact consistently with creature biology and environmental systems.
- Exact numbers, cooldowns, damage formulas and balance tables are intentionally deferred until a playable combat loop exists.

## Acceptance principles
Combat features need clear input, animation/readability, collision/hit logic, feedback, failure/recovery behavior and a repeatable test. Do not call combat complete based only on compiling scripts.
