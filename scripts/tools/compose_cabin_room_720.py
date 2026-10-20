import math
import os
from PIL import Image, ImageDraw, ImageFilter, ImageEnhance
import numpy as np

W, H = 720, 420

# 1. Base Canvas - dark timber wood
canvas = Image.new('RGBA', (W, H), (22, 16, 12, 255))

# 2. Floorboards (Isometric Rotation):
floor_raw = Image.open('C:/Users/user/.gemini/antigravity/brain/c4731d29-dcf2-4e4d-a125-ff1579949ab2/rustic_wooden_floorboards_seamless_1792501874776.jpg').convert('RGBA')
floor_tile = floor_raw.resize((384, 384), Image.Resampling.LANCZOS)

floor_large = Image.new('RGBA', (1536, 1536))
for fy in range(0, 1536, 384):
    for fx in range(0, 1536, 384):
        floor_large.paste(floor_tile, (fx, fy))

floor_rot = floor_large.rotate(26.565, resample=Image.Resampling.BICUBIC, expand=False)
fcx, fcy = 768, 768
floor_cropped = floor_rot.crop((fcx - W // 2, fcy - H // 2, fcx + W // 2, fcy + H // 2))

floor_mask = Image.new('L', (W, H), 0)
draw_fmask = ImageDraw.Draw(floor_mask)
draw_fmask.polygon([(0, 260), (360, 80), (720, 260), (720, H), (0, H)], fill=255)
canvas.paste(floor_cropped, (0, 0), floor_mask)

# 3. Back Walls using Isometric Log Wall Section:
wall_sec = Image.open('assets/interior/wall_log_section.png').convert('RGBA')

arr_ws = np.array(wall_sec)
white_fringe = (arr_ws[:, :, 0] > 230) & (arr_ws[:, :, 1] > 230) & (arr_ws[:, :, 2] > 230)
arr_ws[white_fringe, 3] = 0
wall_sec = Image.fromarray(arr_ws)

under_wall = Image.new('RGBA', (W, H), (0, 0, 0, 0))
draw_uw = ImageDraw.Draw(under_wall)
draw_uw.polygon([(0, 0), (720, 0), (720, 260), (360, 80), (0, 260)], fill=(32, 22, 16, 255))
canvas = Image.alpha_composite(canvas, under_wall)

# Left wall layer
wall_left_full = Image.new('RGBA', (W, H), (0, 0, 0, 0))
w_left = wall_sec.resize((450, 310), Image.Resampling.LANCZOS)
enhancer_l = ImageEnhance.Brightness(w_left)
w_left = enhancer_l.enhance(0.92)
wall_left_full.paste(w_left, (-15, -45))

mask_l = Image.new('L', (W, H), 0)
draw_ml = ImageDraw.Draw(mask_l)
draw_ml.polygon([(0, 0), (360, 0), (360, 82), (0, 262)], fill=255)
canvas.paste(wall_left_full, (0, 0), mask_l)

# Right wall layer
wall_right_full = Image.new('RGBA', (W, H), (0, 0, 0, 0))
w_right = wall_sec.transpose(Image.Transpose.FLIP_LEFT_RIGHT).resize((450, 310), Image.Resampling.LANCZOS)
enhancer_r = ImageEnhance.Brightness(w_right)
w_right = enhancer_r.enhance(1.08)
wall_right_full.paste(w_right, (285, -45))

mask_r = Image.new('L', (W, H), 0)
draw_mr = ImageDraw.Draw(mask_r)
draw_mr.polygon([(360, 0), (720, 0), (720, 262), (360, 82)], fill=255)
canvas.paste(wall_right_full, (0, 0), mask_r)

# 4. Baseboard Seam and Ambient Shadow:
seam = Image.new('RGBA', (W, H), (0, 0, 0, 0))
draw_seam = ImageDraw.Draw(seam)
draw_seam.line([(0, 260), (360, 80)], fill=(22, 14, 10, 240), width=5)
draw_seam.line([(360, 80), (720, 260)], fill=(22, 14, 10, 240), width=5)
draw_seam.line([(0, 263), (360, 83)], fill=(10, 6, 4, 160), width=8)
draw_seam.line([(360, 83), (720, 263)], fill=(10, 6, 4, 160), width=8)
draw_seam.line([(0, 268), (360, 88)], fill=(10, 6, 4, 90), width=16)
draw_seam.line([(360, 88), (720, 268)], fill=(10, 6, 4, 90), width=16)
seam = seam.filter(ImageFilter.GaussianBlur(2.5))
canvas = Image.alpha_composite(canvas, seam)

# 5. Center Corner Hewn Post:
corner = Image.new('RGBA', (W, H), (0, 0, 0, 0))
draw_c = ImageDraw.Draw(corner)
post_w = 20
px1 = 360 - post_w // 2
px2 = 360 + post_w // 2
draw_c.rectangle([px1, 0, 360, 82], fill=(42, 28, 18, 255))
draw_c.rectangle([360, 0, px2, 82], fill=(62, 42, 28, 255))
for by in [20, 48, 72]:
    draw_c.rectangle([px1 - 2, by, px2 + 2, by + 6], fill=(26, 24, 24, 240))
    draw_c.rectangle([px1 - 1, by + 1, px2 + 1, by + 2], fill=(68, 66, 66, 220))
canvas = Image.alpha_composite(canvas, corner)

# 6. Overhead Ceiling Framing & Heavy Beams:
rafters = Image.new('RGBA', (W, H), (0, 0, 0, 0))
draw_raf = ImageDraw.Draw(rafters)
draw_raf.rectangle([0, 24, W, 42], fill=(38, 24, 16, 255))
draw_raf.rectangle([0, 25, W, 28], fill=(64, 42, 26, 255))
draw_raf.rectangle([0, 39, W, 43], fill=(16, 10, 6, 255))
draw_raf.rectangle([0, 0, W, 24], fill=(14, 10, 8, 230))

for rx in [90, 190, 290]:
    draw_raf.polygon([(rx, 0), (rx + 16, 0), (rx - 32, 42), (rx - 48, 42)], fill=(32, 20, 12, 255))
for rx in [630, 530, 430]:
    draw_raf.polygon([(rx, 0), (rx - 16, 0), (rx + 32, 42), (rx + 48, 42)], fill=(44, 28, 18, 255))

bshadow = Image.new('RGBA', (W, H), (0, 0, 0, 0))
draw_bsh = ImageDraw.Draw(bshadow)
draw_bsh.rectangle([0, 42, W, 68], fill=(10, 6, 4, 140))
draw_bsh.rectangle([0, 42, W, 90], fill=(10, 6, 4, 70))
bshadow = bshadow.filter(ImageFilter.GaussianBlur(6))
canvas = Image.alpha_composite(canvas, bshadow)
canvas = Image.alpha_composite(canvas, rafters)

# 7. Side Vertical Framing Posts:
side_posts = Image.new('RGBA', (W, H), (0, 0, 0, 0))
draw_sp = ImageDraw.Draw(side_posts)
draw_sp.rectangle([0, 0, 24, H], fill=(28, 18, 12, 255))
draw_sp.rectangle([21, 0, 24, H], fill=(14, 8, 6, 240))
draw_sp.rectangle([696, 0, 720, H], fill=(38, 24, 16, 255))
draw_sp.rectangle([696, 0, 699, H], fill=(14, 8, 6, 240))

# Bottom threshold
draw_sp.rectangle([0, 408, W, 420], fill=(26, 16, 12, 255))
draw_sp.rectangle([0, 406, W, 409], fill=(12, 8, 6, 220))
draw_sp.rectangle([315, 402, 405, 420], fill=(44, 28, 18, 255))
draw_sp.rectangle([313, 400, 407, 403], fill=(70, 46, 26, 255))
draw_sp.rectangle([313, 403, 407, 405], fill=(16, 10, 6, 220))
canvas = Image.alpha_composite(canvas, side_posts)

# 8. Ambient Lighting Gradients:
amb_light = Image.new('RGBA', (W, H), (0, 0, 0, 0))
draw_amb = ImageDraw.Draw(amb_light)

# Hearth warmth glow (room x=140, y=105 -> Canvas x=200, y=165)
for r in range(240, 15, -15):
    alpha = int(46 * (1.0 - r / 240.0))
    draw_amb.ellipse([200 - r, 165 - int(r * 0.65), 200 + r, 165 + int(r * 0.65)], fill=(255, 155, 45, alpha))

# Soft diagonal morning sunlight beam from window (Canvas x=530, y=130 down to floor)
sun_beam = Image.new('RGBA', (W, H), (0, 0, 0, 0))
draw_sb = ImageDraw.Draw(sun_beam)
draw_sb.polygon([(515, 130), (550, 145), (615, 330), (475, 330)], fill=(255, 235, 170, 40))
sun_beam = sun_beam.filter(ImageFilter.GaussianBlur(12))
amb_light = Image.alpha_composite(amb_light, sun_beam)

# Window sunlight origin glow
for r in range(180, 15, -15):
    alpha = int(36 * (1.0 - r / 180.0))
    draw_amb.ellipse([530 - r, 130 - int(r * 0.65), 530 + r, 130 + int(r * 0.65)], fill=(255, 230, 155, alpha))

amb_light = amb_light.filter(ImageFilter.GaussianBlur(14))
canvas = Image.alpha_composite(canvas, amb_light)

# Save
out_path = 'assets/interior/cabin_room_full.png'
canvas.save(out_path)
print(f'Composed 720x420 full cabin room saved to {out_path}')
