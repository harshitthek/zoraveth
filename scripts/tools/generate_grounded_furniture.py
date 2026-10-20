import os
from PIL import Image, ImageDraw, ImageFilter
import numpy as np

os.makedirs('assets/interior', exist_ok=True)

# 1. BED SHADOW (Exact sprite dimensions: 66x64)
# Contact feet in bed_rustic.png:
# Front post: (26, 63)
# Left post:  (4, 50)
# Right post: (62, 42)
# Rear post:  (40, 32)
bw, bh = 66, 64
bed_shadow = Image.new('RGBA', (bw, bh), (0, 0, 0, 0))
draw_bs = ImageDraw.Draw(bed_shadow)
p_front = (26, 62)
p_left  = (5, 50)
p_right = (61, 42)
p_back  = (40, 32)

# Diffuse underside body shadow
draw_bs.polygon([p_left, p_front, p_right, p_back], fill=(10, 6, 4, 140))
# Direct contact occlusion under each post
for px, py in [p_front, p_left, p_right, p_back]:
    draw_bs.ellipse([px - 5, py - 2, px + 5, py + 2], fill=(8, 4, 2, 220))

bed_shadow = bed_shadow.filter(ImageFilter.GaussianBlur(1.8))
bed_shadow.save('assets/interior/bed_rustic_shadow.png')
print('Generated exact-fit bed_rustic_shadow.png (66x64)')

# 2. TABLE SHADOW (Exact sprite dimensions: 82x64)
# Contact points in table_herbalist.png:
# Left chair rear: (4, 34)
# Left chair front: (12, 51)
# Front trestle: (32, 63)
# Rear trestle: (60, 55)
# Right chair front: (72, 61)
# Right chair rear: (80, 53)
tw, th = 82, 64
table_shadow = Image.new('RGBA', (tw, th), (0, 0, 0, 0))
draw_ts = ImageDraw.Draw(table_shadow)
t_left_chair_r = (5, 34)
t_left_chair_f = (12, 51)
t_trestle_f    = (32, 62)
t_trestle_r    = (60, 55)
t_right_chair_f= (72, 60)
t_right_chair_r= (79, 53)

# Tabletop diffuse shadow on floor
draw_ts.polygon([(18, 44), (32, 62), (72, 52), (58, 34)], fill=(10, 6, 4, 130))
# Chairs diffuse shadows
draw_ts.polygon([(3, 34), (12, 51), (18, 46), (10, 30)], fill=(10, 6, 4, 110))
draw_ts.polygon([(66, 52), (72, 60), (80, 53), (75, 44)], fill=(10, 6, 4, 110))

# Direct contact points
for px, py in [t_left_chair_r, t_left_chair_f, t_trestle_f, t_trestle_r, t_right_chair_f, t_right_chair_r]:
    draw_ts.ellipse([px - 4, py - 2, px + 4, py + 2], fill=(8, 4, 2, 220))

table_shadow = table_shadow.filter(ImageFilter.GaussianBlur(1.8))
table_shadow.save('assets/interior/table_herbalist_shadow.png')
print('Generated exact-fit table_herbalist_shadow.png (82x64)')

# 3. HEARTH SHADOW (Exact sprite dimensions: 85x128)
# Base footprint in hearth_stone.png:
# Front corner: (42, 127)
# Left corner: (1, 108)
# Right corner: (83, 108)
# Back corner: (42, 90)
hw, hh = 85, 128
hearth_shadow = Image.new('RGBA', (hw, hh), (0, 0, 0, 0))
draw_hs = ImageDraw.Draw(hearth_shadow)
hp_front = (42, 126)
hp_left  = (2, 108)
hp_right = (82, 108)
hp_back  = (42, 92)

# Hearth base occlusion
draw_hs.polygon([hp_left, hp_front, hp_right, hp_back], fill=(10, 6, 4, 160))
draw_hs.line([hp_left, hp_front, hp_right], fill=(6, 4, 2, 230), width=3)
hearth_shadow = hearth_shadow.filter(ImageFilter.GaussianBlur(1.8))
hearth_shadow.save('assets/interior/hearth_stone_shadow.png')
print('Generated exact-fit hearth_stone_shadow.png (85x128)')

# 4. BOOKSHELF SHADOW (Exact sprite dimensions: 57x98)
sw, sh = 57, 98
shelf_shadow = Image.new('RGBA', (sw, sh), (0, 0, 0, 0))
draw_ss = ImageDraw.Draw(shelf_shadow)
draw_ss.rectangle([2, 90, 54, 97], fill=(10, 6, 4, 160))
draw_ss.line([(2, 97), (54, 97)], fill=(6, 4, 2, 230), width=3)
shelf_shadow = shelf_shadow.filter(ImageFilter.GaussianBlur(1.8))
shelf_shadow.save('assets/interior/bookshelf_woodland_shadow.png')
print('Generated exact-fit bookshelf_woodland_shadow.png (57x98)')
