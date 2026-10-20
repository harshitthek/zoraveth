import os
from PIL import Image, ImageDraw
import numpy as np

src_path = 'C:/Users/user/.gemini/antigravity/brain/c4731d29-dcf2-4e4d-a125-ff1579949ab2/woodland_cabin_safehaven_perfect_1792523229630.jpg'
im = Image.open(src_path).convert('RGBA')

W, H = 720, 420
# Resize to 720x420
im_resized = im.resize((W, H), Image.Resampling.LANCZOS)
im_resized.save('assets/interior/cabin_room_full.png')
print('Saved resized cabin_room_full.png (720x420)')

# Let's find coordinates of features in 720x420:
# Total width: 720 (from x=-60 to x=660 in room space, so room_x = canvas_x - 60)
# Total height: 420 (from y=-60 to y=360 in room space, so room_y = canvas_y - 60)

# In canvas_x, canvas_y:
# - Bookshelf: x: 30..185, y: 80..320 -> room_x: -30..125, room_y: 20..260
# - Fireplace: x: 190..370, y: 20..255 -> room_x: 130..310, room_y: -40..195
#   Hearth fire center: canvas (290, 205) -> room (230, 145)
#   Hearth floor base: canvas (290, 245) -> room (230, 185)
# - Window: x: 440..605, y: 70..245 -> room_x: 380..545, room_y: 10..185
# - Bed: x: 450..705, y: 200..385 -> room_x: 390..645, room_y: 140..325
#   Bed center footprint: canvas (580, 310) -> room (520, 250)
# - Table: x: 120..355, y: 270..415 -> room_x: 60..295, room_y: 210..355
#   Table center footprint: canvas (240, 350) -> room (180, 290)
# - Hearth Rug / Central Floor:
#   Between Fireplace and Table: canvas (330..430, 240..310) -> room (270..370, 180..250)
# - Elderly Stranger placement:
#   Standing comfortably in the central floor near the hearth/table:
#   canvas (330, 275) -> room (270, 215)
# - Doorway / Mat / Boots:
#   canvas (520..580, 365..415) -> room (460..520, 305..355)
#   Doorway center: canvas (550, 395) -> room (490, 335)
# - Player Spawn:
#   Standing just inside the door: canvas (480, 340) -> room (420, 280)

# Cut out foreground table for depth sorting if player walks behind it:
# Canvas box for table: (120, 270, 355, 415)
crop_table = im_resized.crop((120, 270, 355, 415))
crop_table.save('assets/interior/table_foreground_cutout.png')
print('Saved table_foreground_cutout.png')
