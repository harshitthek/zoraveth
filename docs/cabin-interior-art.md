# Zoraveth — Cabin Interior Art & Safe-Haven Design Specification

## 1. Identity & Narrative Atmosphere

The woodland cabin is the player's initial haven in Zoraveth. Following the inexplicable opening events and trauma of the ancient cataclysm, stepping into the cabin communicates immediate safety, physical warmth, and genuine human hospitality.

### 1.1 Core Atmosphere Pillars
- **Safe Haven:** A complete emotional shelter from the untamed forest. Where the outside woods are vast, cool, and ancient, the interior is intimate, amber-lit, and protective.
- **Lived-In Practicality:** The cabin belongs to someone who has lived a humble, self-sufficient life for decades. Tools, utensils, preserved foodstuffs, and well-mended furniture reflect daily routine.
- **Quiet Mystery Without Menace:** The elderly stranger is genuinely kind and welcoming. Clues of their deeper background (an old star chart, dried wild medicinal herbs, a well-worn leather journal) hint at quiet knowledge without overt wizardry, sinister secrets, or premature plot reveals.
- **Craftsmanship & Material Cohesion:** The interior directly mirrors the architectural construction of `cabin_exterior.png`—hand-hewn cedar logs, rough lime chinking, hand-split timber floorboards, and dry-stacked fieldstone masonry.

---

## 2. Spatial Layout & Full-Screen Room Architecture

The cabin interior is constructed as a **full-screen, immersive pre-rendered master environment** (`cabin_room_full.png`, $720 \times 420\text{ px}$) filling the entire viewport ($1152 \times 648$ at zoom $1.75$ across $[-60, -60, 660, 360]$) with zero cutaway black voids, floating diamond dioramas, or detached cutout sprites.

```
                  (300, -60) Ceiling Rafters & Roof Beams
                             /                 \
                            /                   \
(-60, -60) Top-Left Post   /                     \   Top-Right Post (660, -60)
     +--------------------+                       +--------------------+
     | Back-Left Log Wall | (300, 20) Room Apex   | Back-Right Log Wall|
     | [Fireplace (220,185)]|                     | [Window (integrated)|
     | [Hearth Rug & Fire]|                       |  Bed (520, 310)]   |
     +--------------------+                       +--------------------+
(-60, 200) West Wall Junc  \                     / (660, 200) East Wall Junc
     | [Bookshelf (50, 260)]\                   /                      |
     |                       \  PLAYABLE FLOOR /                       |
     | [Table (180, 345)]     \               / [Exit Doorway (480,335)]
     |                         \             /  [Spawn (440, 290)]     |
(-60, 360) Bot-Left Floor ----- (300, 360) ----- (660, 360) Bot-Right Floor
```

### 2.1 Coordinate Specifications
- **Full Viewport Coverage:** Spans $X \in [-60, 660]$ (width $720\text{ px}$) and $Y \in [-60, 360]$ (height $420\text{ px}$). At zoom $1.75$, this fills the $1152 \times 648$ game screen completely.
- **Floor Surface:** Authentic continuous wooden floorboards running at the $2:1$ isometric angle ($\arctan(0.5) \approx 26.565^\circ$), filling the ground area with natural grain and warm firelight reflections.
- **Back Walls & Built-in Architecture:**
  - Back-Left Wall: Slopes from $(-60, 200)$ up to $(300, 20)$ at exact $2:1$ slope with authentic chinked cedar logs. Embedded directly into this masonry is the dry-stacked fieldstone fireplace whose chimney rises continuously up through the ceiling rafters.
  - Back-Right Wall: Slopes from $(300, 20)$ down to $(660, 200)$ at exact $2:1$ slope with authentic chinked cedar logs. Embedded flush within this wall is the timber-framed bay window with golden morning forest daylight streaming across the floorboards.
- **Ceiling & Framing:**
  - Master tie beams and transverse roof rafters framing the ceiling with hanging dried herbs.
  - Hewn vertical framing timber posts along the corners.
- **Camera Bounds:** `Camera2D` limits set to $[-60, -60, 660, 360]$ with zoom $(1.75, 1.75)$, perfectly framing the full room.

---

## 3. Functional Zones & Grounded Furniture Arrangement

Every item in the cabin is solidly grounded in the master environment with exact collision boundaries and interactive origins matching its visual placement:

```
+-------------------------------------------------------------------------+
|                      [Overhead Rafters & Beams]                         |
|                                                                         |
| [Hearth Zone]                                [Sleeping Alcove]          |
| Fireplace (185, 175)                         Timber Bay Window          |
| Embers & Kettle                              Rustic Bed (530, 245)      |
| Braided Rug & Cat Chair (150, 215)           Window Bench               |
| Firewood & Barrels (310, 165)                                           |
| Stranger (245, 215)                                                     |
+-------------------------------------------------------------------------+
| [Storage Nook]                               [Entryway Foyer]           |
| Bookshelf (8, 175)                           Spawn Position (380, 280)  |
|                                              Exit Doorway (480, 335)    |
| [Study / Work Area]                          Threshold Mat & Boots      |
| Oak Table & Chairs (185, 335)                                           |
| Maps, Inkpot, Mug                                                       |
+-------------------------------------------------------------------------+
```

### 3.1 Zone 1: Hearth and Warmth (Back-Left Wall, $(185, 175)$)
- **Hearth Structure:** Dry-stacked fieldstone fireplace built directly into the log wall with vertical stone chimney piercing the roof rafters. Heavy timber mantelpiece with split logs and cast-iron kettle.
- **Dynamic Fire & Embers:** Hand-painted glowing fire base augmented with rising `CPUParticles2D` sparks/embers and warm pulsing hearth light aura.
- **Accessories:** Concentric braided oval wool hearth rug on the floorboards; hearthside chair with sleeping cat at $(150, 215)$; firewood basket and barrels at $(310, 165)$.
- **Elderly Stranger:** Positioned warmly at $(245, 215)$ standing on the hearth rug facing the entrance, ready to greet the arriving traveler.

### 3.2 Zone 2: Storage & Apothecary (West Wall, $(8, 175)$)
- **Bookshelf:** Sturdy dark cedar bookshelf resting flush against the left wall, filled with ancient leatherbound tomes, rolled scrolls, and apothecary jars.
- **Ceiling Storage:** Bundles of wild sage and medicinal herbs drying from the overhead ceiling beams.

### 3.3 Zone 3: Sleeping Alcove (East Wall, $(530, 245)$)
- **Timber Bed:** Solid cedar bedstead with rust-and-sage patchwork quilt, folded wool blankets, linen pillow, and foot-bench, set along the right wall.
- **Bay Window & Bench:** Multi-pane lattice bay window embedded in the right wall above a cushioned window bench, bathing the room in soft morning woodland light with gentle dynamic shimmer.

### 3.4 Zone 4: Study & Work Area (Foreground-Left, $(185, 335)$)
- **Work Table & Chairs:** Heavy oak refectory table with botanical sketches, regional parchment map, stoneware inkpot, quill, leather satchel, and clay tea mug.

### 3.5 Zone 5: Entryway Foyer (Southeast, $(480, 335)$)
- **Doorway Threshold:** Timber door sill with coarse woven doormat and muddy travel boots.
- **Player Spawn:** Spawns at $(380, 280)$ facing into the warm room with a comfortable $114\text{ px}$ buffer from the doorway trigger circle to prevent accidental re-triggering.
- **Exit Interaction:** Press `[E]` within $28\text{ px}$ of $(480, 335)$ to return smoothly to the forest.
