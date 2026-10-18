# Open Questions, Risks, and Assumptions

The owner prefers the AI to handle routine reversible decisions and ask only high-impact creative questions, one at a time.

## Creative questions intentionally unresolved
1. Final game title (world name Zoraveth is established).
2. Exact central mystery, its cause and final answer.
3. Nature of the opening battle and its relation to the player.
4. Elderly stranger's identity and connection to the opening.
5. What the hidden path beneath the cabin leads to and how the revelation unfolds.
6. Exact geography, continents, civilizations, factions, languages and deities.
7. Final playable ancestry and class roster details.

Do not raise these during routine implementation. Raise one only when a future creative milestone genuinely depends on it.

## Technical questions to resolve through prototypes
- Which 2D/isometric rendering and tilemap approach works best with the installed Godot version?
- What tile size, internal scale, filtering and target resolution look best?
- Which depth-sorting approach handles tall trees, roofs and moving characters?
- What movement/collision setup feels responsive?
- What asset pipeline and licensing policy works for contributors?
- What network architecture is feasible after the vertical slice?
- What save format and migration strategy is appropriate once persistence is needed?
- What automated validation is practical?

Use small experiments and evidence; do not turn routine details into owner questions.

## Risks and mitigations
- **Scope creep:** build playable milestones before expanding.
- **AI-generated brittle systems:** use small diffs, run the game and validate each step.
- **Networking too early:** defer until local vertical slice works.
- **Asset/licence uncertainty:** record provenance and choose code/art licences explicitly before public release.
- **Isometric complexity:** validate movement, collision and sorting early with placeholder tiles.
- **Performance assumptions:** measure client performance and server load instead of guessing.
- **Over-explaining lore:** keep protected mysteries unresolved until clues and story are ready.

## Assumptions, not facts
Godot 4.7.2, Compatibility renderer, GDScript, Windows-first, Git, and `E:\projects\zoraveth` are current choices. Verify actual machine/project state before acting. The developer has programming experience but is new to game development.
