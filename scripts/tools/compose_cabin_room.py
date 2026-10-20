import math
import os
from PIL import Image, ImageDraw, ImageFilter, ImageEnhance
import numpy as np

W, H = 1152, 648

# 1. Base Canvas - fill entire background with dark rustic timber wood
canvas = Image.new('RGBA', (W, H), (24, 16, 12, 255))

# Under-wall wood fill (ensures no white slivers anywhere)
wall_tex_raw = Image.open('C:/Users/user/.gemini/antigravity/brain/c4731d29-dcf2-4e4d-a125-ff1579949ab2/cabin_interior_log_wall_texture_1792498927542.jpg').convert('RGBA')
wall_tex_tile = wall_tex_raw.resize((512, 512), Image.Resampling.LANCZOS)
for wy in range(0, 400, 512):
    for wx in range(0, W, 512):
        canvas.paste(wall_tex_tile, (wx, wy))

# Darken upper background behind rafters
dark_top = Image.new('RGBA', (W, H), (0, 0, 0, 0))
draw_dt = ImageDraw.Draw(dark_top)
draw_dt.rectangle([0, 0, W, 140], fill=(16, 10, 8, 180))
canvas = Image.alpha_composite(canvas, dark_top)

# 2. Floorboards (Isometric Rotation):
floor_raw = Image.open('C:/Users/user/.gemini/antigravity/brain/c4731d29-dcf2-4e4d-a125-ff1579949ab2/rustic_wooden_floorboards_seamless_1792501874776.jpg').convert('RGBA')
floor_tile = floor_raw.resize((512, 512), Image.Resampling.LANCZOS)

floor_large = Image.new('RGBA', (2048, 2048))
for fy in range(0, 2048, 512):
    for fx in range(0, 2048, 512):
        floor_large.paste(floor_tile, (fx, fy))

floor_rot = floor_large.rotate(26.565, resample=Image.Resampling.BICUBIC, expand=False)
fcx, fcy = 1024, 1024
floor_cropped = floor_rot.crop((fcx - W // 2, fcy - H // 2, fcx + W // 2, fcy + H // 2))

floor_mask = Image.new('L', (W, H), 0)
draw_fmask = ImageDraw.Draw(floor_mask)
draw_fmask.polygon([(0, 360), (576, 125), (1152, 360), (1152, H), (0, H)], fill=255)
canvas.paste(floor_cropped, (0, 0), floor_mask)

# 3. Back Walls using Isometric Log Wall Section:
wall_sec = Image.open('assets/interior/wall_log_section.png').convert('RGBA')

# Clean any white fringe on wall_sec
arr_ws = np.array(wall_sec)
white_fringe = (arr_ws[:, :, 0] > 235) & (arr_ws[:, :, 1] > 235) & (arr_ws[:, :, 2] > 235)
arr_ws[white_fringe, 3] = 0
wall_sec = Image.fromarray(arr_ws)

# Left wall layer (WxH)
wall_left_full = Image.new('RGBA', (W, H), (0, 0, 0, 0))
w_left = wall_sec.resize((660, 450), Image.Resampling.LANCZOS)
# Darken left wall slightly
enhancer_l = ImageEnhance.Brightness(w_left)
w_left = enhancer_l.enhance(0.92)
wall_left_full.paste(w_left, (-10, -20))

mask_l = Image.new('L', (W, H), 0)
draw_ml = ImageDraw.Draw(mask_l)
draw_ml.polygon([(0, 30), (576, 30), (576, 130), (0, 365)], fill=255)
canvas.paste(wall_left_full, (0, 0), mask_l)

# Right wall layer (WxH)
wall_right_full = Image.new('RGBA', (W, H), (0, 0, 0, 0))
w_right = wall_sec.transpose(Image.Transpose.FLIP_LEFT_RIGHT).resize((660, 450), Image.Resampling.LANCZOS)
enhancer_r = ImageEnhance.Brightness(w_right)
w_right = enhancer_r.enhance(1.08)
wall_right_full.paste(w_right, (502, -20))

mask_r = Image.new('L', (W, H), 0)
draw_mr = ImageDraw.Draw(mask_r)
draw_mr.polygon([(576, 30), (1152, 30), (1152, 365), (576, 130)], fill=255)
canvas.paste(wall_right_full, (0, 0), mask_r)

# 4. Baseboard Seam and Shadow:
seam = Image.new('RGBA', (W, H), (0, 0, 0, 0))
draw_seam = ImageDraw.Draw(seam)
draw_seam.line([(0, 360), (576, 125)], fill=(22, 14, 10, 240), width=6)
draw_seam.line([(576, 125), (1152, 360)], fill=(22, 14, 10, 240), width=6)
# Drop shadow on floor
draw_seam.line([(0, 364), (576, 129)], fill=(10, 6, 4, 160), width=10)
draw_seam.line([(576, 129), (1152, 364)], fill=(10, 6, 4, 160), width=10)
draw_seam.line([(0, 370), (576, 135)], fill=(10, 6, 4, 90), width=22)
draw_seam.line([(576, 135), (1152, 370)], fill=(10, 6, 4, 90), width=22)
seam = seam.filter(ImageFilter.GaussianBlur(3))
canvas = Image.alpha_composite(canvas, seam)

# 5. Center Corner Hewn Post:
corner = Image.new('RGBA', (W, H), (0, 0, 0, 0))
draw_c = ImageDraw.Draw(corner)
post_w = 28
px1 = 576 - post_w // 2
px2 = 576 + post_w // 2
draw_c.rectangle([px1, 0, 576, 130], fill=(42, 28, 18, 255))
draw_c.rectangle([576, 0, px2, 130], fill=(62, 42, 28, 255))
for by in [35, 75, 115]:
    draw_c.rectangle([px1 - 2, by, px2 + 2, by + 8], fill=(26, 24, 24, 240))
    draw_c.rectangle([px1 - 1, by + 1, px2 + 1, by + 3], fill=(68, 66, 66, 220))
canvas = Image.alpha_composite(canvas, corner)

# 6. Overhead Ceiling Framing & Heavy Beams:
rafters = Image.new('RGBA', (W, H), (0, 0, 0, 0))
draw_raf = ImageDraw.Draw(rafters)
draw_raf.rectangle([0, 36, W, 64], fill=(40, 26, 16, 255))
draw_raf.rectangle([0, 37, W, 42], fill=(68, 44, 26, 255))
draw_raf.rectangle([0, 60, W, 65], fill=(16, 10, 6, 255))
draw_raf.rectangle([0, 0, W, 36], fill=(14, 10, 8, 230))

for rx in [140, 300, 460]:
    draw_raf.polygon([(rx, 0), (rx + 24, 0), (rx - 48, 64), (rx - 72, 64)], fill=(34, 20, 12, 255))
for rx in [1012, 852, 692]:
    draw_raf.polygon([(rx, 0), (rx - 24, 0), (rx + 48, 64), (rx + 72, 64)], fill=(48, 30, 18, 255))

bshadow = Image.new('RGBA', (W, H), (0, 0, 0, 0))
draw_bsh = ImageDraw.Draw(bshadow)
draw_bsh.rectangle([0, 64, W, 100], fill=(10, 6, 4, 140))
draw_bsh.rectangle([0, 64, W, 130], fill=(10, 6, 4, 70))
bshadow = bshadow.filter(ImageFilter.GaussianBlur(8))
canvas = Image.alpha_composite(canvas, bshadow)
canvas = Image.alpha_composite(canvas, rafters)

# 7. Side Vertical Framing Posts (Left & Right screen edges):
side_posts = Image.new('RGBA', (W, H), (0, 0, 0, 0))
draw_sp = ImageDraw.Draw(side_posts)
draw_sp.rectangle([0, 0, 36, H], fill=(30, 18, 12, 255))
draw_sp.rectangle([32, 0, 36, H], fill=(14, 8, 6, 240))
draw_sp.rectangle([1116, 0, 1152, H], fill=(42, 26, 16, 255))
draw_sp.rectangle([1116, 0, 1120, H], fill=(14, 8, 6, 240))

# Bottom threshold
draw_sp.rectangle([0, 632, W, 648], fill=(28, 18, 12, 255))
draw_sp.rectangle([0, 630, W, 633], fill=(12, 8, 6, 220))
draw_sp.rectangle([516, 622, 636, 648], fill=(46, 30, 18, 255))
draw_sp.rectangle([514, 620, 638, 624], fill=(72, 48, 28, 255))
draw_sp.rectangle([514, 624, 638, 627], fill=(16, 10, 6, 220))
canvas = Image.alpha_composite(canvas, side_posts)

# 8. Ambient Lighting Gradients (Hearth warm amber & Window golden daylight):
amb_light = Image.new('RGBA', (W, H), (0, 0, 0, 0))
draw_amb = ImageDraw.Draw(amb_light)

# Hearth warmth glow (center x=260, y=270)
for r in range(360, 20, -20):
    alpha = int(48 * (1.0 - r / 360.0))
    draw_amb.ellipse([260 - r, 270 - int(r * 0.65), 260 + r, 270 + int(r * 0.65)], fill=(255, 155, 45, alpha))

# Window sunlight beam (center x=940, y=250)
for r in range(320, 20, -20):
    alpha = int(40 * (1.0 - r / 320.0))
    draw_amb.ellipse([940 - r, 250 - int(r * 0.65), 940 + r, 250 + int(r * 0.65)], fill=(255, 230, 155, alpha))

amb_light = amb_light.filter(ImageFilter.GaussianBlur(18))
canvas = Image.alpha_composite(canvas, amb_light)

# Save
out_path = 'assets/interior/cabin_room_full.png'
canvas.save(out_path)
print(f'Composed refined full cabin room saved to {out_path} ({W}x{H})')
