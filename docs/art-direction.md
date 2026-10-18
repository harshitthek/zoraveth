# Zoraveth — Art Direction & Visual Standards

## 1. Core Artistic Identity

**Zoraveth** is visually defined by **detailed, handcrafted isometric 2D fantasy illustration**. The art style bridges the tactile warmth of classic illustrated fantasy RPGs with the dramatic contrast, deep silhouettes, and atmospheric immersion of modern narrative worldbuilding.

### Pillars of the Visual Direction
1. **Painterly Environmental Depth:** Natural surfaces avoid mechanical repetition. Earth, foliage, and stonework feature organic contouring, material weathering, moss coats, and hand-placed details.
2. **Atmospheric Lighting & Readability:** Grounded key lighting (top-left direction) creates legible depth while maintaining crisp gameplay silhouettes. Canopies and roofs visually shelter areas without obstructing ground navigation.
3. **Restrained Enchantment:** Magic in Zoraveth is rare, ancient, and quiet. Ethereal glows and celestial particles are reserved for significant landmarks and living flora, avoiding excessive visual noise or screen flooding.
4. **Cohesive Isometric Perspective:** Every entity adheres to a strict 2:1 isometric diamond projection ($64 \times 32\text{ px}$ ground ratio) with foot-origin depth sorting.

---

## 2. Two Complementary Atmospheric Modes

The world balances two distinct visual palettes that intersect organically across the landscape.

```
+-----------------------------------------------------------------------+
|                             ZORAVETH WORLD                            |
+-----------------------------------+-----------------------------------+
|            LIVING WORLD           |          FORGOTTEN WORLD          |
|  (Forests, Cabins, Settlements)   |    (Ruins, Monoliths, Frontiers)  |
|  • Deep Pine & Warm Moss Greens   |  • Weathered Basalt & Slate Grays |
|  • Warm Amber Sunlight (Top-Left) |  • Ethereal Cyan / Soul Luminescence|
|  • Weathered Cedar & Earth Tones  |  • Chipped Masonry & Sacred Glyphs|
|  • Organic Beaten Trails & Foliage|  • Dramatic Shadows & Mote Trails |
+-----------------------------------+-----------------------------------+
                                    |
                                    v
                 TRANSITIONAL & ENCHANTED CROSSROADS
     (Discovery Groves: Ancient Stonework Engulfed in Living Moss)
```

### A. Living World (Forests, Clearings, Settlements)
- **Palette:**
  - Canopy Greens: Deep Forest Pine (`#182a1c`), Verdant Moss (`#243d28`), Sunlit Leaf (`#3a5e36`), Meadow Birch (`#4b7244`).
  - Bark & Timbers: Hewn Cedar (`#4a3525`), Aged Oak (`#3b2a1e`), Chinked Log (`#5c4330`), Weathered Plank (`#322318`).
  - Earth & Paths: Beaten Path Soil (`#3a3322`), Dry Loam (`#453d28`), Meadow Sward (`#1c2e1f`).
- **Tone & Mood:** Inviting, grounded, lived-in, and sheltering. The woods feel rich with living ecology, birdsong, and ancient growth.
- **Lighting:** Warm afternoon sun from top-left casting soft translucent shadows downward-right.

### B. Forgotten World (Ancient Ruins, Monoliths, Sanctums)
- **Palette:**
  - Stonework: Weathered Basalt (`#2a3230`), Chiseled Granite (`#3b4542`), Highlight Ridge (`#52605c`), Sunken Crevice (`#18201e`).
  - Soul & Celestial Resonance: Moonlit Cyan (`#6ee8d2`), Astral Teal (`#3aa399`), Rune Shimmer (`#a2f5e6`), Dormant Fracture (`#285c54`).
- **Tone & Mood:** Silent, reverent, mysterious, and monumental. Structures display pre-cataclysmic craftsmanship reclaimed by nature.
- **Lighting:** Directional shadow with localized, pulsing rune illumination that draws the eye toward secrets.

### C. Transitional Blends (Discovery Groves & Overgrown Relics)
Where the natural forest encroaches upon the forgotten civilization (e.g. the Discovery Grove and Ancient Runestone), the two palettes layer seamlessly: vibrant green moss carpets broken grey stone, and celestial runes shine beneath trailing ivy.

---

## 3. Cohesion Rules & Spatial Standards

### 3.1 Projection & Geometry
- **Ground Tile Aspect Ratio:** 2:1 isometric diamond ($64\text{ px}$ width $\times$ $32\text{ px}$ height).
- **Coordinate Model:** Standard 2D Cartesian physics. Input and movement remain clean Cartesian vectors, projected visually into the isometric camera frame.
- **Sorting Paradigm:** `CanvasItem.y_sort_enabled = true` on entity containers.

### 3.2 Foot-Origin & Collision Footprint Separation
Every entity separates its **visual volume** from its **ground contact footprint**:
- **Origin Anchor:** The node origin $(0, 0)$ is fixed precisely at the bottom center of the entity's ground contact.
- **Collision Boundary:** Solid physics shapes are strictly restricted to the small ground footprint (e.g. tree trunk base, boulder bottom, cabin wall perimeter).
- **Canopy Occlusion:** Visual foliage, branches, and roofs extend freely upward and outward past the collision shape, allowing the player to naturally walk behind and beneath structures with accurate Y-sorting.

| Entity Type | Visual Dimensions ($W \times H$) | Collision Footprint ($W \times H$) | Footprint Offset |
| :--- | :--- | :--- | :--- |
| **Player** | $24 \times 38\text{ px}$ | $18 \times 10\text{ px}$ | $(0, -5\text{ px})$ |
| **Elderly Stranger** | $26 \times 38\text{ px}$ | $18 \times 10\text{ px}$ | $(0, -5\text{ px})$ |
| **Standard Pine Tree** | $74 \times 116\text{ px}$ | $20 \times 12\text{ px}$ | $(0, -6\text{ px})$ |
| **Ancient Spreading Oak** | $110 \times 140\text{ px}$ | $28 \times 16\text{ px}$ | $(0, -8\text{ px})$ |
| **Forest Boulder** | $36 \times 28\text{ px}$ | $24 \times 14\text{ px}$ | $(0, -7\text{ px})$ |
| **Forest Bush** | $36 \times 26\text{ px}$ | Non-blocking / Passable | N/A |
| **Moonleaf Herb** | $20 \times 18\text{ px}$ | Trigger Area: $R=24\text{ px}$ | $(0, -6\text{ px})$ |
| **Ancient Runestone** | $36 \times 78\text{ px}$ | $28 \times 14\text{ px}$ | $(0, -7\text{ px})$ |
| **Cabin Exterior** | $148 \times 120\text{ px}$ | Wall Perimeter Polygon | Perimeter |
| **Cabin Interior Floor** | $440 \times 220\text{ px}$ (Playable) | Outer Wall Perimeter Polygon | Perimeter |

---

## 4. UI & Interaction Visual Language

1. **Panel Surfaces:** Deep obsidian-slate (`#101512` with 96% opacity) with crisp $1\text{ px}$ borders (`#3d4a3e` at 80% opacity) and $4\text{ px}$ corner radii.
2. **Typography & Hierarchies:**
   - Speaker Names & Titles: Warm golden amber (`#f5d780`), bold tracking.
   - Narrative & Dialogue Body: Soft linen cream (`#eaefe9`), comfortable reading height with $1.4\times$ line spacing.
   - Contextual Action Hints: Sage leaf green (`#7ea884`), discrete brackets `[E]`.
3. **Tactile Interaction States:**
   - Default: Solid muted slate-moss (`#1a241c`).
   - Hover: Focused emerald tint (`#2a3d2e`) with softened highlight border (`#5c7a60`).
   - Active Press: Micro-scale down ($0.98\times$) and darkened tone (`#141c16`).
   - Focus Ring: High-visibility contrast ring (`#9ee0a8`) for complete keyboard operability.

---

## 5. Lighting & Atmospheric Details

- **Ground Shadows:** Directional diamond-ellipse polygons tinted `#08100a` at $35\text{--}45\%$ opacity anchored to ground contact.
- **Ambient Life:** Procedural low-frequency sway on forest bushes and branches ($1.8\text{--}2.5\text{ rad/s}$) simulating wind currents.
- **Hearth Glow:** Cozy warm light flicker ($5\text{--}7\text{ Hz}$, scale factor $0.90\text{--}1.10$) radiating from fireplace and cabin doorway.
- **Soul Particles:** Subtle upward-drifting motes ($6\text{--}10\text{ particles}$, life $2\text{--}3\text{s}$) near ancient celestial landmarks.
