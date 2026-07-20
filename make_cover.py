#!/usr/bin/env python3
"""Generate a 3000x3000 podcast cover for 'Litsearch Audio' matching the
litsearch.darvinyi.com terminal aesthetic (near-black + teal/cyan, monospace)."""
import sys
from PIL import Image, ImageDraw, ImageFont

W = 3000
BG    = (10, 10, 11)      # #0a0a0b
FG    = (236, 236, 238)   # #ececee
TEAL  = (45, 212, 191)    # #2dd4bf
CYAN  = (34, 211, 238)    # #22d3ee
AMBER = (251, 146, 60)    # #fb923c
MUTED = (110, 110, 122)
FRAME = (30, 30, 38)

MONO = "/System/Library/Fonts/Menlo.ttc"

def font(sz, bold=True):
    for idx in ((1, 0) if bold else (0,)):
        try:
            return ImageFont.truetype(MONO, sz, index=idx)
        except Exception:
            continue
    return ImageFont.truetype(MONO, sz)

img = Image.new("RGB", (W, W), BG)
d = ImageDraw.Draw(img)

# Inset frame for a little structure.
d.rounded_rectangle([130, 130, W - 130, W - 130], radius=90, outline=FRAME, width=8)

# Three speaker dots (optimist / skeptic / guest).
dots = [TEAL, CYAN, AMBER]
r = 78
gap = 150
row_w = len(dots) * (2 * r) + (len(dots) - 1) * (gap - 2 * r)
x = (W - row_w) // 2 + r
y = 1000
for c in dots:
    d.ellipse([x - r, y - r, x + r, y + r], fill=c)
    x += gap

# Wordmark: "litsearch" over "audio" + cursor block, monospace.
f_title = font(400)
d.text((W // 2, 1430), "litsearch", font=f_title, fill=FG, anchor="mm")

# "audio" (teal) left-anchored so we can append a cursor block after it.
word = "audio"
wlen = d.textlength(word, font=f_title)
block_w = int(wlen / len(word) * 0.85)
gap2 = 40
total = wlen + gap2 + block_w
start_x = (W - total) / 2
ay = 1880
d.text((start_x, ay), word, font=f_title, fill=TEAL, anchor="lm")
# Cursor block, cap-height tall, cyan.
bbox = d.textbbox((start_x, ay), word, font=f_title, anchor="lm")
bh = bbox[3] - bbox[1]
bx = start_x + wlen + gap2
d.rounded_rectangle([bx, ay - bh / 2, bx + block_w, ay + bh / 2], radius=12, fill=CYAN)

# Tagline.
f_tag = font(96, bold=False)
d.text((W // 2, 2340), "research papers, read aloud", font=f_tag, fill=MUTED, anchor="mm")

out = sys.argv[1] if len(sys.argv) > 1 else "cover.jpg"
img.save(out, "JPEG", quality=90, optimize=True)
print(f"wrote {out} ({img.size[0]}x{img.size[1]})")
