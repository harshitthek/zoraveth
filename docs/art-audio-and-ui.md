# Art, Audio, Camera, Controls and UI

## Visual identity
- Detailed pixel art.
- Vibrant enchanted wilderness with lush colours and magical natural details.
- Safe settlements are warm and lively; ruins/frontiers can be darker, atmospheric and unsettling.
- Distinct silhouettes and consistent scale.
- Magic and combat effects must not obscure character/enemy silhouettes or attack telegraphs.
- Use temporary programmer art until the gameplay loop is proven.
- Use only original or appropriately licensed assets; track source, author, licence and attribution.

## Camera
- Stable isometric 2D camera.
- Adjustable but bounded zoom.
- Limited contextual rotation only if it adds value and remains comfortable.
- Cinematic framing can be used for discoveries and major bosses without taking control away for long periods.
- 2D coordinate model uses 2:1 isometric diamond projection (64x32 pixel tiles).
- Depth sorting is managed via `CanvasItem.y_sort_enabled = true`. Sortable entities use ground contact foot-origins `(0, 0)`, separating visual height from compact collision footprints.

## Controls
- Initial PC target: WASD movement, mouse aiming/target assistance, hotkey skills, directional dodge and weapon combos.
- Controls should be responsive and configurable.
- Heavy actions may have commitment, but their startup, active window, recovery and danger should be readable.
- Provide remapping/accessibility options as the project matures.
- Avoid making mouse precision the only way to play if alternative targeting is appropriate.

## UI
- Clean, immersive UI with optional advanced/customizable tools.
- Keep core information readable without covering the world.
- Important interactions, damage, resource use, discoveries and danger need clear feedback.
- Advanced players may benefit from customizable combat information later.
- Avoid cluttering the first prototype with inventory, minimap, quest log and MMO-style panels before the relevant mechanics exist.

## Audio
- Long-term direction: cinematic music plus a living atmospheric soundscape and adaptive exploration/danger music.
- NPC dialogue primarily written with expressive animations and ambient vocal sounds; cinematic framing/music for important scenes.
- Begin with silence or simple placeholders if needed; do not block movement/combat on a large audio pipeline.

## Animation and feel
- Weighty but responsive animations.
- Committed heavy actions and clear telegraphs.
- Grounded early mobility; advanced movement is earned through class paths, mastery, soul powers, mounts or discoveries.
- Test animation timing against actual gameplay rather than designing only from static mockups.
