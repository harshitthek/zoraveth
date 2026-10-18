# Development Workflow

## Standard task loop
1. Read `AGENTS.md`, `context.md`, the current phase, and relevant specs.
2. Inspect files, Godot version/settings and Git status.
3. State one scoped task and acceptance criteria.
4. Implement only that task.
5. Run relevant validation.
6. Review the diff.
7. Update status/decisions/docs only where meaningful.
8. Report changed files, tests, limitations and next step.

## Antigravity prompt template
```text
Read AGENTS.md, context.md, decisions.md, the current phase in phases.md,
requirements-index.md, and the relevant system specification.
Inspect the actual project and Git status before editing.

Task:
[One specific task]

Acceptance criteria:
- [Observable result 1]
- [Observable result 2]
- [Validation result]

Constraints:
- Do not implement unrelated future systems.
- Do not overwrite/delete user work or run destructive Git commands.
- Use APIs compatible with the installed Godot version.
- Keep changes small and reviewable.
- Run validation where possible and report truthful results.
```

## Owner review checklist
- [ ] Diff only contains relevant files.
- [ ] No unrelated project settings changed.
- [ ] APIs exist in the installed Godot version.
- [ ] Scene/script references are connected correctly.
- [ ] Project launches.
- [ ] Feature tested manually or automatically.
- [ ] External asset source/licence is recorded.
- [ ] Documentation status is accurate.

## Git
Inspect status before/after tasks. Commit coherent milestones when ready. Use branches for risky experiments. Never commit credentials/secrets or use destructive commands without explicit approval.

## Communication preference
The owner prefers step-by-step progress, clear explanations of game-development concepts, routine reversible decisions handled by the AI, and only important creative questions asked one at a time.
