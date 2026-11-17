#!/usr/bin/env python3
"""Generate canvas_studio README images using PIL."""

from PIL import Image, ImageDraw, ImageFont, ImageOps

# Colors matching the example app theme
PURPLE = (103, 80, 164)      # #6750A4
DARK_PURPLE = (78, 58, 130)
DARK_BG = (18, 18, 30)       # #12121e
CANVAS_BG = (26, 26, 46)     # #1A1A2E
WHITE = (255, 255, 255)
LIGHT_GRAY = (176, 190, 197) # #B0BEC5
AMBER = (255, 193, 7)
PINK = (233, 30, 99)
TEAL = (3, 169, 144)
GREEN = (76, 175, 80)

def get_font(size, bold=True):
    """Try to load a decent font, fallback to default."""
    font_paths = [
        "/c/Windows/Fonts/arialbd.ttf" if bold else "/c/Windows/Fonts/arial.ttf",
        "/c/Windows/Fonts/segoeuib.ttf" if bold else "/c/Windows/Fonts/segoeui.ttf",
        "/c/Windows/Fonts/calibrib.ttf" if bold else "/c/Windows/Fonts/calibri.ttf",
    ]
    for path in font_paths:
        try:
            return ImageFont.truetype(path, size)
        except Exception:
            continue
    return ImageFont.load_default()


def draw_rounded_rect(draw, xy, radius, fill, outline=None, outline_width=0):
    x1, y1, x2, y2 = xy
    draw.rounded_rectangle([x1, y1, x2, y2], radius=radius, fill=fill, outline=outline, width=outline_width)


def generate_hero_canvas():
    """Main hero image showing the canvas editor UI."""
    W, H = 1200, 800
    img = Image.new("RGB", (W, H), DARK_BG)
    d = ImageDraw.Draw(img)

    # Top bar
    draw_rounded_rect(d, (0, 0, W, 64), 0, DARK_PURPLE)
    d.text((24, 16), "Canvas Studio", font=get_font(24, bold=True), fill=WHITE)
    d.text((W - 200, 18), "Undo   Redo   Brand Fill   Export", font=get_font(16), fill=LIGHT_GRAY)

    # Canvas area
    cx, cy = 100, 100
    cw, ch = 1000, 560
    draw_rounded_rect(d, (cx, cy, cx + cw, cy + ch), 16, CANVAS_BG)

    # Checkerboard pattern behind canvas
    tile = 40
    for ty in range(cy, cy + ch, tile):
        for tx in range(cx, cx + cw, tile):
            if ((tx // tile + ty // tile) % 2) == 0:
                d.rectangle([tx, ty, min(tx + tile, cx + cw), min(ty + tile, cy + ch)], fill=(34, 34, 54))

    # Background shape layer
    draw_rounded_rect(d, (cx + 20, cy + 20, cx + cw - 20, cy + ch - 20), 12, DARK_PURPLE)

    # Accent shape
    d.rectangle([cx + 440, cy + 300, cx + 640, cy + 314], fill=PURPLE)

    # Title text layer
    d.text((cx + 80, cy + 400), "Happy", font=get_font(64, bold=True), fill=WHITE)
    d.text((cx + 80, cy + 470), "Diwali", font=get_font(64, bold=True), fill=AMBER)

    # Subtitle
    d.text((cx + 80, cy + 540), "Flutter SDK for design creation", font=get_font(24), fill=LIGHT_GRAY)

    # Sticker layer (small circle)
    d.ellipse([cx + 850, cy + 420, cx + 930, cy + 500], fill=PINK, outline=WHITE, width=3)
    d.text((cx + 870, cy + 450), "✨", font=get_font(40), fill=WHITE)

    # Selection handles on title layer
    d.rectangle([cx + 76, cy + 396, cx + 80, cy + 404], fill=AMBER)
    d.rectangle([cx + 996, cy + 536, cx + 1000, cy + 544], fill=AMBER)

    # Bottom toolbar
    ty = 700
    draw_rounded_rect(d, (0, ty, W, H), 0, DARK_PURPLE)
    tools = [
        ("📝", "Text"), ("🖼️", "Image"), ("🔲", "Shape"), ("✨", "Sticker"),
        ("🖌️", "Paint"), ("🎵", "Audio"), ("🎬", "Video"), ("🧹", "Remove BG"),
    ]
    tx = 24
    for icon, label in tools:
        d.text((tx, ty + 14), icon, font=get_font(28))
        d.text((tx + 40, ty + 20), label, font=get_font(14), fill=LIGHT_GRAY)
        tx += 110

    # Export button
    draw_rounded_rect(d, (W - 220, ty + 10, W - 30, ty + 44), 8, AMBER)
    d.text((W - 190, ty + 18), "Export MP4", font=get_font(16, bold=True), fill=DARK_BG)

    img.save("example/assets/screenshots/hero-canvas.png")
    print("Saved hero-canvas.png")


def generate_feature_text():
    """Text editing feature image."""
    W, H = 600, 400
    img = Image.new("RGB", (W, H), DARK_BG)
    d = ImageDraw.Draw(img)

    d.text((24, 24), "Text Editing with Indic Support", font=get_font(24, bold=True), fill=WHITE)
    d.text((24, 60), "Devanagari • Bengali • Tamil • Telugu • Gujarati", font=get_font(16), fill=LIGHT_GRAY)

    # Text layer preview
    draw_rounded_rect(d, (24, 100, 576, 320), 16, CANVAS_BG)
    d.text((60, 140), "नमस्ते", font=get_font(48, bold=True), fill=WHITE)
    d.text((60, 200), "নমস্কার", font=get_font(48, bold=True), fill=AMBER)
    d.text((60, 260), "வணக்கம்", font=get_font(48, bold=True), fill=TEAL)

    # Toolbar
    draw_rounded_rect(d, (24, 330, 576, 370), 8, DARK_PURPLE)
    d.text((40, 342), "🅰 Font: Noto Sans Devanagari   🎨 Color: #FFFFFF   📏 Size: 48", font=get_font(16), fill=LIGHT_GRAY)

    img.save("example/assets/screenshots/feature-text.png")
    print("Saved feature-text.png")


def generate_feature_image():
    """Image editing feature image."""
    W, H = 600, 400
    img = Image.new("RGB", (W, H), DARK_BG)
    d = ImageDraw.Draw(img)

    d.text((24, 24), "Image Editing + BG Removal", font=get_font(24, bold=True), fill=WHITE)
    d.text((24, 60), "On-device ONNX U2Net — no API cost", font=get_font(16), fill=LIGHT_GRAY)

    # Image layer preview
    draw_rounded_rect(d, (24, 100, 576, 280), 16, CANVAS_BG)
    # Product image mockup
    d.rectangle([60, 120, 260, 260], fill=(70, 70, 90))
    d.text((100, 180), "Product", font=get_font(20), fill=LIGHT_GRAY)
    d.text((100, 210), "Image", font=get_font(20), fill=LIGHT_GRAY)

    # Effects panel
    effects = [("Brightness", 0.6), ("Contrast", 0.3), ("Saturation", 0.1), ("Blur", 2.0)]
    ey = 310
    for label, val in effects:
        d.text((40, ey), label, font=get_font(14), fill=LIGHT_GRAY)
        d.rectangle([120, ey, 300, ey + 10], fill=(60, 60, 80))
        d.rectangle([120, ey, 120 + int(val * 60), ey + 10], fill=PURPLE)
        ey += 30

    # BG removal badge
    draw_rounded_rect(d, (400, 310, 576, 360), 8, TEAL)
    d.text((416, 326), "✓ BG Removed", font=get_font(16, bold=True), fill=WHITE)
    d.text((416, 346), "On-device", font=get_font(12), fill=LIGHT_GRAY)

    img.save("example/assets/screenshots/feature-image.png")
    print("Saved feature-image.png")


def generate_feature_video():
    """Video export feature image."""
    W, H = 600, 400
    img = Image.new("RGB", (W, H), DARK_BG)
    d = ImageDraw.Draw(img)

    d.text((24, 24), "Image + Audio → MP4", font=get_font(24, bold=True), fill=WHITE)
    d.text((24, 60), "On-device FFmpeg — no backend needed", font=get_font(16), fill=LIGHT_GRAY)

    # Video timeline
    draw_rounded_rect(d, (24, 100, 576, 220), 16, CANVAS_BG)
    d.rectangle([60, 130, 540, 190], fill=(70, 70, 90))
    d.text((80, 150), "📹 Video Track", font=get_font(16), fill=LIGHT_GRAY)
    d.rectangle([60, 200, 540, 220], fill=(70, 70, 90))
    d.text((80, 210), "🎵 Audio Track", font=get_font(16), fill=LIGHT_GRAY)

    # Trim handles
    d.rectangle([60, 126, 80, 194], fill=AMBER)
    d.rectangle([520, 126, 540, 194], fill=AMBER)

    # Export settings
    draw_rounded_rect(d, (24, 250, 576, 330), 16, DARK_PURPLE)
    d.text((40, 266), "Export Settings:", font=get_font(16, bold=True), fill=WHITE)
    settings = ["Format: MP4 (H.264)", "Resolution: 1080×1080", "Watermark: Enabled", "Watermark: Enabled"]
    for i, s in enumerate(settings):
        d.text((60, 290 + i * 22), f"✓ {s}", font=get_font(14), fill=LIGHT_GRAY)

    # Result badge
    draw_rounded_rect(d, (24, 340, 576, 380), 8, GREEN)
    d.text((40, 354), "✓ Export complete — saved to gallery", font=get_font(16, bold=True), fill=WHITE)

    img.save("example/assets/screenshots/feature-video.png")
    print("Saved feature-video.png")


def generate_architecture():
    """Architecture diagram image."""
    W, H = 1000, 700
    img = Image.new("RGB", (W, H), DARK_BG)
    d = ImageDraw.Draw(img)

    d.text((40, 30), "canvas_studio SDK Architecture", font=get_font(28, bold=True), fill=WHITE)

    # Host App
    draw_rounded_rect(d, (40, 80, 300, 180), 12, PURPLE, outline=WHITE, outline_width=2)
    d.text((70, 100), "Host App", font=get_font(20, bold=True), fill=WHITE)
    d.text((60, 130), "Flutter Application", font=get_font(14), fill=LIGHT_GRAY)
    d.text((60, 150), "• TemplateProvider", font=get_font(12), fill=LIGHT_GRAY)
    d.text((60, 162), "• AudioProvider", font=get_font(12), fill=LIGHT_GRAY)
    d.text((60, 174), "• StickerProvider", font=get_font(12), fill=LIGHT_GRAY)

    # CanvasEditorWidget
    draw_rounded_rect(d, (340, 80, 660, 180), 12, PURPLE, outline=WHITE, outline_width=2)
    d.text((370, 100), "CanvasEditorWidget", font=get_font(20, bold=True), fill=WHITE)
    d.text((360, 130), "Theme • Icons • Fonts • Toolbar", font=get_font(12), fill=LIGHT_GRAY)

    # CanvasController
    draw_rounded_rect(d, (700, 80, 960, 180), 12, PURPLE, outline=WHITE, outline_width=2)
    d.text((730, 100), "CanvasController", font=get_font(20, bold=True), fill=WHITE)
    d.text((720, 130), "State • History • Selection", font=get_font(12), fill=LIGHT_GRAY)

    # Arrows down
    d.text((160, 190), "↓", font=get_font(24), fill=AMBER)
    d.text((490, 190), "↓", font=get_font(24), fill=AMBER)
    d.text((820, 190), "↓", font=get_font(24), fill=AMBER)

    # Canvas Layer
    draw_rounded_rect(d, (40, 220, 300, 320), 12, TEAL, outline=WHITE, outline_width=2)
    d.text((70, 240), "CustomPainter Canvas", font=get_font(20, bold=True), fill=WHITE)
    d.text((60, 270), "TextLayer • ImageLayer", font=get_font(12), fill=LIGHT_GRAY)
    d.text((60, 282), "ShapeLayer • StickerLayer", font=get_font(12), fill=LIGHT_GRAY)
    d.text((60, 294), "PaintLayer", font=get_font(12), fill=LIGHT_GRAY)

    # Modules Layer
    draw_rounded_rect(d, (340, 220, 660, 320), 12, TEAL, outline=WHITE, outline_width=2)
    d.text((370, 240), "Feature Modules", font=get_font(20, bold=True), fill=WHITE)
    modules = ["Text Edit", "Image Edit", "Audio", "Video", "Effects", "BG Removal", "Brand Auto-Fill", "Animation"]
    mx, my = 360, 270
    for i, m in enumerate(modules):
        col = i % 4
        row = i // 4
        d.text((mx + col * 130, my + row * 16), f"• {m}", font=get_font(12), fill=LIGHT_GRAY)

    # Export Layer
    draw_rounded_rect(d, (700, 220, 960, 320), 12, TEAL, outline=WHITE, outline_width=2)
    d.text((730, 240), "Export Pipeline", font=get_font(20, bold=True), fill=WHITE)
    d.text((720, 270), "PNG/JPG → MP4 via FFmpeg", font=get_font(12), fill=LIGHT_GRAY)
    d.text((720, 282), "On-device rendering", font=get_font(12), fill=LIGHT_GRAY)

    # Arrows to bottom
    d.text((160, 330), "↓", font=get_font(24), fill=AMBER)
    d.text((490, 330), "↓", font=get_font(24), fill=AMBER)
    d.text((820, 330), "↓", font=get_font(24), fill=AMBER)

    # Output Layer
    draw_rounded_rect(d, (340, 360, 660, 440), 12, GREEN, outline=WHITE, outline_width=2)
    d.text((370, 380), "Output", font=get_font(20, bold=True), fill=WHITE)
    d.text((360, 410), "PNG • JPG • MP4", font=get_font(16), fill=WHITE)
    d.text((360, 430), "Saved to device gallery", font=get_font(12), fill=LIGHT_GRAY)

    img.save("docs/assets/architecture.png")
    print("Saved docs/assets/architecture.png")


def generate_platform_support():
    """Platform support image."""
    W, H = 800, 400
    img = Image.new("RGB", (W, H), DARK_BG)
    d = ImageDraw.Draw(img)

    d.text((40, 30), "Platform Support", font=get_font(24, bold=True), fill=WHITE)

    platforms = [
        ("Android", "API 21+", PURPLE),
        ("iOS", "13+", TEAL),
        ("Web", "Chrome", AMBER),
        ("Windows", "10/11", PINK),
        ("macOS", "10.14+", GREEN),
        ("Linux", "Ubuntu", LIGHT_GRAY),
    ]

    y = 100
    for name, ver, color in platforms:
        draw_rounded_rect(d, (40, y, 760, y + 50), 10, DARK_PURPLE)
        d.text((70, y + 12), name, font=get_font(20, bold=True), fill=WHITE)
        d.text((700, y + 16), ver, font=get_font(16), fill=LIGHT_GRAY)
        d.ellipse([50, y + 15, 70, y + 35], fill=color)
        y += 60

    img.save("docs/assets/platform-support.png")
    print("Saved docs/assets/platform-support.png")


if __name__ == "__main__":
    generate_hero_canvas()
    generate_feature_text()
    generate_feature_image()
    generate_feature_video()
    generate_architecture()
    generate_platform_support()
    print("All images generated!")
