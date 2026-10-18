# AI Agent Instructions

## Before editing
1. Read `docs/context.md` and this file.
2. Read `docs/decisions.md`, the current phase in `docs/phases.md`, and relevant system specifications in `docs/`.
3. Inspect actual files, project settings, Godot version, and `git status`.
4. Identify one task and its observable acceptance criteria.
5. Report any mismatch between documentation and actual project state before making risky changes.

## Implementation
- Work in small, coherent, reviewable increments.
- Implement only the current task. Do not build systems merely because they are in the long-term vision.
- Use APIs supported by the actual Godot version. Do not invent methods, signals, nodes, or settings.
- Prefer clear typed GDScript where helpful and small focused scenes/scripts.
- Avoid premature frameworks and giant manager scripts.
- For typical player movement, consider `CharacterBody2D`; validate the approach against the desired coordinate model.
- Keep gameplay logic, presentation, world simulation, persistence, and networking separable as needs emerge.
- Do not add plugins, dependencies, downloaded assets, or unrelated project-setting changes without need and approval.
- Do not generate large placeholder asset collections. Use simple programmer art until the gameplay loop is proven.
- Isometric 2D means 2D unless the owner explicitly approves a move to 3D.

## Creative canon
- Follow `docs/decisions.md` and `docs/lore-bible.md`.
- Never resolve protected story mysteries merely to fill gaps.
- If a durable decision changes, record the change and its reason.
- Ask only about high-impact creative decisions, licensing/publishing choices, destructive actions, or architectural choices with meaningful long-term consequences. Handle routine reversible technical choices independently.

## Git safety
- Inspect `git status` before and after work.
- Never discard, reset, overwrite, or delete user work without explicit approval.
- Do not run destructive Git commands.
- Do not commit unless requested.
- Never add credentials, tokens, keys, or personal secrets.
- Keep diffs small and reviewable.

## Validation and reporting
After every task:
1. Run relevant Godot validation/tests when possible.
2. If validation cannot run, say so and give manual steps.
3. List exact files created/modified.
4. Report tests/commands and truthful results.
5. State known limitations and next smallest step.
6. Update documentation when actual project status or a durable decision changes.

A feature is not "working" merely because code was generated. It must be run or explicitly marked unverified.
