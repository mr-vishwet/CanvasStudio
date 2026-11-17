#!/usr/bin/env python3
"""Generate canvas_studio README images using PIL.

Procedural dark-theme mockups: gradients, device frames, drop shadows and
drawn icons — no external services, no sign-ups, fully reproducible.
Outputs replace the eight screenshots in place (old versions stay in git).
"""

from PIL import Image, ImageDraw, ImageFont, ImageFilter

# --- palette (matches the Flutter theme) ---
BG = (18, 18, 30)        # #12121e
CANVAS = (26, 26, 46)    # #1A1A2E
PANEL = (37, 37, 64)     # #252540
BORDER = (58, 58, 92)    # #3A3A5C
PURPLE = (103, 80, 164)  # #6750A4
PURPLE_D = (78, 58, 130)
AMBER = (255, 193, 7)    # #FFC107
TEAL = (3, 169, 144)     # #03A990
GREEN = (76, 175, 80)    # #4CAF50
PINK = (233, 30, 99)     # #E91E63
WHITE = (255, 255, 255)
MUTED = (176, 190, 197)  # #B0BEC5

FONTS_B = [
    "/c/Windows/Fonts/segoeuib.ttf",
    "/c/Windows/Fonts/arialbd.ttf",
    "/c/Windows/Fonts/calibrib.ttf",
    "/c/Windows/Fonts/verdanab.ttf",
]
FONTS_R = [
    "/c/Windows/Fonts/segoeui.ttf",
    "/c/Windows/Fonts/arial.ttf",
    "/c/Windows/Fonts/calibri.ttf",
    "/c/Windows/Fonts/verdana.ttf",
]

def font(size, bold=True):
    for path in FONTS_B if bold else FONTS_R:
        try:
            return ImageFont.truetype(path, size)
        except OSError:
            continue
    return ImageFont.load_default()


def linear_gradient(size, c1, c2, vertical=True):
    w, h = size
    base = Image.new("RGB", size, c1)
    top = Image.new("RGB", size, c2)
    n = (h if vertical else w) - 1
    ramp = Image.new("L", (1, n + 1))
    p = ramp.load()
    for i in range(n + 1):
        p[0, i] = int(255 * i / n)
    ramp = ramp.resize(size)
    return Image.composite(top, base, ramp)


def rounded_rect(img, xy, radius, fill, outline=None, outline_width=0):
    d = ImageDraw.Draw(img)
    d.rounded_rectangle(xy, radius=radius, fill=fill, outline=outline, width=outline_width)


def shadow(img, xy, radius, offset=(0, 10), blur=22, alpha=100):
    """Soft drop shadow beneath the shape at xy, composited onto img."""
    x1, y1, x2, y2 = xy
    pad = blur
    dy = max(offset[1], 0)
    layer = Image.new("RGBA", (x2 - x1 + pad * 2, y2 - y1 + pad * 2 + dy), (0, 0, 0, 0))
    sd = ImageDraw.Draw(layer)
    sd.rounded_rectangle([pad, pad + dy, pad + (x2 - x1), pad + dy + (y2 - y1)],
                         radius=radius, fill=(0, 0, 0, alpha))
    layer = layer.filter(ImageFilter.GaussianBlur(blur))
    img.alpha_composite(layer, (x1 - pad, y1 - pad))


def check(d, x, y, s, fill):
    """Small drawn check mark (avoids glyphs missing from system fonts)."""
    d.line([(x, y + s * 0.35), (x + s * 0.35, y + s * 0.9), (x + s * 0.95, y - s * 0.3)],
           fill=fill, width=3)


def arrow(d, x, y, color, size=22):
    d.line([(x, y), (x, y + size)], fill=color, width=4)
    d.polygon([(x - 7, y + size - 11), (x + 7, y + size - 11), (x, y + size)], fill=color)


def star(d, cx, cy, r, fill):
    d.polygon([(cx, cy - r), (cx + r * 0.55, cy), (cx, cy + r), (cx - r * 0.55, cy)], fill=fill)


def icon(d, cx, cy, r, fill, kind):
    d.ellipse([cx - r, cy - r, cx + r, cy + r], fill=fill)
    d.ellipse([cx - r + 5, cy - r + 5, cx + r - 5, cy + r - 5], fill=BG)
    if kind == "t":  # text
        d.rectangle([cx - 6, cy - 9, cx + 6, cy - 1], fill=fill)
        d.rectangle([cx - 9, cy + 3, cx + 2, cy + 7], fill=fill)
    elif kind == "i":  # image
        d.rectangle([cx - 7, cy - 7, cx + 7, cy + 7], fill=fill, width=2)
        d.ellipse([cx + 1, cy - 4, cx + 5, cy], fill=fill)
    elif kind == "s":  # shape
        d.rectangle([cx - 6, cy - 6, cx + 6, cy + 6], fill=fill)
    elif kind == "p":  # sticker badge
        star(d, cx, cy, r * 0.55, fill)
    elif kind == "b":  # paint brush
        d.line([(cx - 5, cy - 5), (cx + 5, cy + 5)], fill=fill, width=3)
    elif kind == "n":  # audio note
        d.ellipse([cx - 4, cy - 8, cx + 4, cy], fill=fill)
        d.line([(cx, cy - 8), (cx, cy + 6)], fill=fill, width=3)
    elif kind == "v":  # video
        d.polygon([(cx - 5, cy - 5), (cx + 3, cy), (cx - 5, cy + 5)], fill=fill)
    elif kind == "g":  # remove background
        d.rectangle([cx - 6, cy - 6, cx + 6, cy + 6], fill=fill, width=2)
        d.line([cx - 5, cy - 2, cx + 5, cy + 2], fill=fill, width=2)


def save(img, path):
    img.convert("RGB").save(path, "PNG")
    print("Saved", path)


def generate_hero_canvas():
    W, H = 1200, 800
    img = Image.new("RGBA", (W, H), BG + (255,))
    base = linear_gradient((W, H), BG, (30, 30, 54))
    shadows = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    content = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    cd = ImageDraw.Draw(content)

    # Top bar
    rounded_rect(content, (0, 0, W, 64), 0, PANEL)
    cd.text((28, 19), "Canvas Studio", font=font(26, True), fill=WHITE, anchor="lm")
    cd.text((W - 28, 20), "Undo   Redo   Brand Fill   Export", font=font(17), fill=MUTED, anchor="rm")

    # Device frame around canvas
    fx, fy, fw, fh = 60, 96, 1080, 560
    shadow(shadows, (fx - 8, fy - 8, fx + fw + 8, fy + fh + 8), 20, offset=(0, 16), blur=28, alpha=120)
    rounded_rect(content, (fx, fy, fx + fw, fy + fh), 22, PANEL, outline=BORDER, outline_width=1)

    # Screen
    sx, sy, sw, sh = fx + 30, fy + 30, fw - 60, fh - 60
    rounded_rect(content, (sx, sy, sx + sw, sy + sh), 16, CANVAS)

    # Checkerboard behind canvas
    tile = 36
    for ty in range(sy, sy + sh, tile):
        for tx in range(sx, sx + sw, tile):
            if ((tx // tile + ty // tile) % 2) == 0:
                cd.rectangle([tx, ty, min(tx + tile, sx + sw), min(ty + tile, sy + sh)], fill=(34, 34, 54))

    # Layers
    rounded_rect(content, (sx + 28, sy + 28, sx + sw - 28, sy + sh - 28), 12, PURPLE_D)
    cd.rectangle([sx + 420, sy + 270, sx + 620, sy + 286], fill=PURPLE)
    cd.rounded_rectangle([sx + 340, sy + 310, sx + 700, sy + 360], 10, BG)

    # Title layers
    cd.text((sx + 80, sy + 372), "Happy", font=font(60, True), fill=WHITE)
    cd.text((sx + 80, sy + 444), "Diwali", font=font(60, True), fill=AMBER)
    cd.text((sx + 80, sy + 516), "Flutter SDK for design creation", font=font(22), fill=MUTED)

    # Selection handles
    cd.rectangle([sx + 72, sy + 368, sx + 78, sy + 376], fill=AMBER)
    cd.rectangle([sx + sw - 82, sy + 512, sx + sw - 76, sy + 520], fill=AMBER)

    # Sticker badge
    cd.ellipse([sx + 850, sy + 380, sx + 940, sy + 470], fill=PINK, outline=WHITE, width=3)
    star(cd, sx + 895, sy + 425, 16, WHITE)

    # Bottom toolbar
    ty = 700
    rounded_rect(content, (0, ty, W, H), 0, PANEL)
    tools = [("Text", "t"), ("Image", "i"), ("Shape", "s"), ("Sticker", "p"),
             ("Paint", "b"), ("Audio", "n"), ("Video", "v"), ("Remove BG", "g")]
    tx = 28
    for label, kind in tools:
        icon(cd, tx + 22, ty + 30, 14, PURPLE, kind)
        cd.text((tx + 48, ty + 23), label, font=font(14), fill=MUTED, anchor="lm")
        tx += 115
    rounded_rect(content, (W - 230, ty + 12, W - 32, ty + 48), 8, AMBER)
    cd.text((W - 200, ty + 30), "Export MP4", font=font(16, True), fill=(26, 26, 42), anchor="mm")

    img = Image.alpha_composite(base.convert("RGBA"), shadows)
    img = Image.alpha_composite(img, content)
    save(img, "example/assets/screenshots/hero-canvas.png")


def feature_shell(W, H, title, subtitle):
    img = Image.new("RGBA", (W, H), BG + (255,))
    base = linear_gradient((W, H), BG, (26, 26, 44))
    shadows = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    content = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    cd = ImageDraw.Draw(content)
    cd.text((28, 24), title, font=font(24, True), fill=WHITE, anchor="lm")
    cd.text((28, 58), subtitle, font=font(16), fill=MUTED, anchor="lm")
    return img, base, shadows, content, cd


def finish(img, base, shadows, content, path):
    img = Image.alpha_composite(base.convert("RGBA"), shadows)
    img = Image.alpha_composite(img, content)
    save(img, path)


def generate_feature_text():
    W, H = 600, 400
    img, base, shadows, content, d = feature_shell(W, H, "Text Editing with Indic Support",
                                                   "Devanagari • Bengali • Tamil • Telugu • Gujarati")
    shadow(shadows, (28, 108, 572, 328), 16, offset=(0, 10), blur=20, alpha=100)
    rounded_rect(content, (28, 108, 572, 328), 16, CANVAS)
    cd = ImageDraw.Draw(content)
    samples = [("DEVANAGARI", WHITE), ("BENGALI", AMBER), ("TAMIL", TEAL)]
    for i, (name, color) in enumerate(samples):
        cd.text((72, 150 + i * 46), name, font=font(34, True), fill=color)
    shadow(shadows, (28, 342, 572, 382), 8, offset=(0, 6), blur=12, alpha=90)
    rounded_rect(content, (28, 342, 572, 382), 8, PANEL)
    cd.text((46, 362), "A   Font: Noto Sans Indic      B   Color: #FFFFFF      C   Size: 48",
            font=font(15), fill=MUTED)
    finish(img, base, shadows, content, "example/assets/screenshots/feature-text.png")


def generate_feature_image():
    W, H = 600, 400
    img, base, shadows, content, d = feature_shell(W, H, "Image Editing + BG Removal",
                                                   "On-device ONNX U2Net — no API cost")
    shadow(shadows, (28, 108, 572, 298), 16, offset=(0, 10), blur=20, alpha=100)
    rounded_rect(content, (28, 108, 572, 298), 16, CANVAS)
    cd = ImageDraw.Draw(content)
    cd.rectangle([64, 128, 284, 278], fill=(46, 46, 70), outline=BORDER, width=1)
    cd.text((144, 194), "Product", font=font(20, True), fill=MUTED)
    cd.text((144, 222), "Image", font=font(20, True), fill=MUTED)
    effects = [("Brightness", 0.6), ("Contrast", 0.3), ("Saturation", 0.1), ("Blur", 2.0)]
    ey = 320
    for label, val in effects:
        cd.text((46, ey), label, font=font(14), fill=MUTED)
        cd.rectangle([132, ey + 4, 308, ey + 12], fill=(46, 46, 70))
        cd.rectangle([132, ey + 4, 132 + int(val * 78), ey + 12], fill=PURPLE)
        ey += 26
    shadow(shadows, (320, 318, 572, 378), 8, offset=(0, 6), blur=12, alpha=90)
    rounded_rect(content, (320, 318, 572, 378), 8, TEAL)
    cd.text((336, 332), "BG Removed", font=font(16, True), fill=WHITE)
    check(cd, 326, 332, 20, WHITE)
    cd.text((336, 354), "On-device", font=font(12), fill=MUTED)
    finish(img, base, shadows, content, "example/assets/screenshots/feature-image.png")


def generate_feature_video():
    W, H = 600, 400
    img, base, shadows, content, d = feature_shell(W, H, "Image + Audio → MP4",
                                                   "On-device FFmpeg — no backend needed")
    shadow(shadows, (28, 108, 572, 230), 16, offset=(0, 10), blur=20, alpha=100)
    rounded_rect(content, (28, 108, 572, 230), 16, CANVAS)
    cd = ImageDraw.Draw(content)
    cd.rectangle([64, 140, 536, 190], fill=(46, 46, 70))
    cd.text((88, 156), "Video Track", font=font(16), fill=MUTED)
    cd.rectangle([64, 200, 536, 220], fill=(46, 46, 70))
    cd.text((88, 208), "Audio Track", font=font(16), fill=MUTED)
    cd.rectangle([60, 134, 80, 196], fill=AMBER)
    cd.rectangle([520, 134, 540, 196], fill=AMBER)
    shadow(shadows, (28, 254, 572, 334), 16, offset=(0, 8), blur=18, alpha=90)
    rounded_rect(content, (28, 254, 572, 334), 16, PANEL)
    cd.text((46, 270), "Export Settings:", font=font(16, True), fill=WHITE)
    settings = ["Format: MP4 (H.264)", "Resolution: 1080×1080", "Watermark: Enabled"]
    for i, s in enumerate(settings):
        cd.text((64, 294 + i * 22), s, font=font(14), fill=MUTED)
        check(cd, 44, 294 + i * 22, 16, PURPLE)
    shadow(shadows, (28, 346, 572, 386), 8, offset=(0, 4), blur=10, alpha=90)
    rounded_rect(content, (28, 346, 572, 386), 8, GREEN)
    cd.text((46, 366), "Export complete — saved to gallery", font=font(16, True), fill=WHITE)
    check(cd, 34, 366, 20, WHITE)
    finish(img, base, shadows, content, "example/assets/screenshots/feature-video.png")


def generate_architecture():
    W, H = 1000, 700
    img, base, shadows, content, cd = feature_shell(W, H, "canvas_studio SDK Architecture", "")

    def box(x, y, w, h, color, title, lines):
        shadow(shadows, (x, y, x + w, y + h), 12, offset=(0, 8), blur=16, alpha=100)
        rounded_rect(content, (x, y, x + w, y + h), 12, color, outline=WHITE, outline_width=1)
        cd.text((x + 30, y + 18), title, font=font(20, True), fill=WHITE)
        for i, line in enumerate(lines):
            cd.text((x + 20, y + 48 + i * 14), line, font=font(12), fill=MUTED)

    box(40, 80, 260, 110, PURPLE, "Host App", ["Flutter Application", "• TemplateProvider",
                                               "• AudioProvider", "• StickerProvider"])
    box(340, 80, 320, 110, PURPLE, "CanvasEditorWidget", ["Theme • Icons • Fonts • Toolbar"])
    box(700, 80, 260, 110, PURPLE, "CanvasController", ["State • History • Selection"])
    arrow(cd, 162, 200, AMBER)
    arrow(cd, 492, 200, AMBER)
    arrow(cd, 822, 200, AMBER)
    box(40, 230, 260, 100, TEAL, "CustomPainter Canvas", ["TextLayer • ImageLayer",
                                                         "ShapeLayer • StickerLayer", "PaintLayer"])
    box(340, 230, 320, 100, TEAL, "Feature Modules",
        ["Text Edit", "Image Edit", "Audio", "Video", "Effects", "BG Removal", "Brand Auto-Fill", "Animation"])
    box(700, 230, 260, 100, TEAL, "Export Pipeline", ["PNG/JPG → MP4 via FFmpeg",
                                                    "On-device rendering"])
    arrow(cd, 162, 340, AMBER)
    arrow(cd, 492, 340, AMBER)
    arrow(cd, 822, 340, AMBER)
    shadow(shadows, (340, 370, 660, 450), 12, offset=(0, 8), blur=16, alpha=100)
    rounded_rect(content, (340, 370, 660, 450), 12, GREEN, outline=WHITE, outline_width=1)
    cd.text((374, 392), "Output", font=font(20, True), fill=WHITE)
    cd.text((362, 422), "PNG • JPG • MP4", font=font(16, True), fill=WHITE)
    cd.text((362, 440), "Saved to device gallery", font=font(12), fill=MUTED)
    finish(img, base, shadows, content, "docs/assets/architecture.png")


def generate_feature_brand():
    W, H = 600, 400
    img, base, shadows, content, d = feature_shell(W, H, "Brand Auto-Fill",
                                                   "Placeholder matching + logo injection")
    shadow(shadows, (28, 108, 308, 350), 16, offset=(0, 10), blur=20, alpha=100)
    rounded_rect(content, (28, 108, 308, 350), 16, PANEL)
    cd = ImageDraw.Draw(content)
    fields = [("Business Name", "Sharma Electronics"), ("Phone", "+91 98765 43210"),
              ("Address", "Mumbai, India"), ("Tagline", "Quality Since 1990")]
    for i, (label, value) in enumerate(fields):
        rect_y = 140 + i * 60
        cd.text((54, rect_y - 20), label, font=font(13), fill=MUTED)
        rounded_rect(content, (54, rect_y, 282, rect_y + 30), 8, CANVAS)
        cd.text((62, rect_y + 15), value, font=font(13), fill=WHITE, anchor="lm")
    rounded_rect(content, (104, 366, 232, 386), 8, AMBER)
    cd.text((168, 376), "Apply to Canvas", font=font(14, True), fill=(26, 26, 42), anchor="mm")
    shadow(shadows, (340, 108, 572, 388), 16, offset=(0, 10), blur=20, alpha=100)
    rounded_rect(content, (340, 108, 572, 388), 16, CANVAS)
    cd.text((372, 132), "Sharma Electronics", font=font(24, True), fill=WHITE)
    cd.text((372, 172), "+91 98765 43210", font=font(17), fill=MUTED)
    cd.text((372, 202), "Mumbai, India", font=font(17), fill=MUTED)
    cd.text((372, 232), "Quality Since 1990", font=font(17), fill=MUTED)
    rounded_rect(content, (404, 260, 484, 340), 8, PURPLE)
    cd.text((444, 300), "LOGO", font=font(16, True), fill=WHITE, anchor="mm")
    finish(img, base, shadows, content, "example/assets/screenshots/feature-brand.png")


def generate_feature_templates():
    W, H = 600, 400
    img, base, shadows, content, cd = feature_shell(W, H, "Template Picker",
                                                   "6 starter templates · Category filters")
    tabs = ["All", "Blank", "Business", "Sale", "Festival", "Video"]
    tx = 28
    for tab in tabs:
        rounded_rect(content, (tx, 108, tx + 94, 140), 8, CANVAS)
        cd.text((tx + 47, 124), tab, font=font(12, True), fill=MUTED, anchor="mm")
        tx += 104
    templates = [("Blank Square", "1080×1080", PURPLE), ("Blank Portrait", "1080×1920", TEAL),
                 ("Business Card", "1080×608", AMBER), ("Sale Poster", "1080×1920", PINK),
                 ("Festival Post", "1080×1080", AMBER), ("Video Slideshow", "1080×1080", TEAL)]
    ty = 166
    for i, (name, size, color) in enumerate(templates):
        col = i % 2
        row = i // 2
        x = 28 + col * 286
        y = ty + row * 112
        rounded_rect(content, (x, y, x + 270, y + 96), 12, CANVAS)
        cd.rectangle([x + 22, y + 22, x + 102, y + 74], fill=color)
        cd.text((x + 124, y + 30), name, font=font(14, True), fill=WHITE)
        cd.text((x + 124, y + 56), size, font=font(12), fill=MUTED)
    finish(img, base, shadows, content, "example/assets/screenshots/feature-templates.png")


def generate_platform_support():
    W, H = 800, 400
    img, base, shadows, content, cd = feature_shell(W, H, "Platform Support", "")
    platforms = [("Android", "API 21+", PURPLE), ("iOS", "13+", TEAL), ("Web", "Chrome", AMBER),
                 ("Windows", "10/11", PINK), ("macOS", "10.14+", GREEN), ("Linux", "Ubuntu", MUTED)]
    y = 104
    for name, ver, color in platforms:
        shadow(shadows, (40, y, 760, y + 52), 10, offset=(0, 6), blur=14, alpha=90)
        rounded_rect(content, (40, y, 760, y + 52), 10, PANEL)
        cd.text((72, y + 26), name, font=font(20, True), fill=WHITE, anchor="lm")
        cd.text((758, y + 26), ver, font=font(16), fill=MUTED, anchor="rm")
        cd.ellipse([54, y + 16, 74, y + 36], fill=color)
        y += 64
    finish(img, base, shadows, content, "docs/assets/platform-support.png")


EXPECTED = {
    "example/assets/screenshots/hero-canvas.png": (1200, 800),
    "example/assets/screenshots/feature-text.png": (600, 400),
    "example/assets/screenshots/feature-image.png": (600, 400),
    "example/assets/screenshots/feature-video.png": (600, 400),
    "example/assets/screenshots/feature-brand.png": (600, 400),
    "example/assets/screenshots/feature-templates.png": (600, 400),
    "docs/assets/architecture.png": (1000, 700),
    "docs/assets/platform-support.png": (800, 400),
}


if __name__ == "__main__":
    generate_hero_canvas()
    generate_feature_text()
    generate_feature_image()
    generate_feature_video()
    generate_feature_brand()
    generate_feature_templates()
    generate_architecture()
    generate_platform_support()
    from PIL import Image as _I
    ok = True
    for path, size in EXPECTED.items():
        with _I.open(path) as im:
            good = im.size == size
            ok &= good
            print(f"{'OK ' if good else 'FAIL'} {path} {im.size}")
    print("All images generated!" if ok else "SOME IMAGES FAILED")
