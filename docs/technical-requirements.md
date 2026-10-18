# Technical Requirements and Quality Gates

## General
- All features must be testable, understandable and documented at the level appropriate to their complexity.
- Use Godot APIs that exist in the installed version.
- Keep the first prototype local and bounded.
- Avoid unnecessary dependencies and large generated assets.
- Never claim untested code is working.

## Project foundation requirements
- Main scene exists at `res://scenes/world.tscn`.
- Root node is `Node2D` named `World`.
- Project main-scene setting points to the intended scene.
- Project opens and runs without unexplained errors.
- Git diff contains only relevant files.
- Documentation accurately reflects actual status.

## Movement requirements
- Configurable input actions.
- Consistent movement speed in normal play.
- Collision prevents walking through intended obstacles.
- Camera follows the player without unexpected jumps.
- No obvious jitter caused by mixing physics and frame updates.
- Test keyboard diagonals and boundary/collision cases.

## Visual/isometric requirements
- A consistent coordinate convention is documented.
- Character/object depth sorting is predictable.
- Tall objects can obscure/reveal the player naturally.
- Camera zoom remains within useful limits.
- Pixel-art filtering/scale is consistent.
- Basic scene is readable on the target display and performs adequately on the developer's hardware.

## Combat requirements
- Inputs, attack timing, collision/hit detection, damage and feedback are testable.
- Enemy attacks have readable telegraphs.
- Dodge has predictable invulnerability/collision rules if invulnerability is used.
- Cooldowns/resources cannot become negative or bypass rules.
- Combat outcomes are not based only on unverified animation timing.

## Persistence requirements (later phase)
- Saves survive a restart.
- Missing, corrupt, or older save data is handled safely.
- Important progress is not silently overwritten.
- Character and world-specific state have defined ownership.
- Never store secrets or credentials in save/config files committed to Git.

## Future networking requirements
- Explicit authority model.
- Server validates important client requests.
- Disconnect/reconnect behavior tested.
- State changes are consistent and recoverable.
- Latency and resource use are measured.
- Do not promise MMO scale without load tests and operational planning.

## Validation/report format
For each task report:
1. Summary.
2. Files changed.
3. Tests/commands executed and results.
4. What was not tested.
5. Known limitations.
6. Next smallest step.

## Performance
- Profile before optimizing.
- Keep early regions bounded.
- Simulate nearby entities at high fidelity and simplify distant simulation if needed.
- Avoid unbounded per-frame work or loading large assets synchronously during gameplay.
- Use evidence for client/server capacity claims.
