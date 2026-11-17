# 🎨 canvas_studio

> A lightweight, general-purpose Flutter SDK for building image & video editing canvas experiences — **offline-first, on-device, pub.dev ready**.

---

## 🎯 What We're Building

**canvas_studio** is a Flutter SDK that host apps embed to give their users a full-featured image and video editing canvas — no backend required for 91% of features.

### The Vision

When complete, your host app will ship a complete canvas editor where users can:

- **Pick a template** (square, portrait, landscape, A4) from a bundled starter pack or your own CDN
- **Edit everything** — text (with Indic script support), images, shapes, stickers, freehand paint
- **Auto-fill brand info** — business name, phone, address, tagline, logo injected into placeholder layers
- **Remove backgrounds** on-device via ONNX U2Net (zero API cost)
- **Add music** from a pluggable audio library with preview playback
- **Export** PNG/JPG locally, or MP4 via on-device FFmpeg (image + audio → slideshow video, or full video pipeline)
- **White-label everything** — theme, icons, fonts, toolbar, feature gates, localization

---

## 🎨 Design System & AI Image Prompts

Rather than shipping static mockups, the visual identity is defined by AI image generation prompts. Run these in Midjourney, DALL-E, or Stable Diffusion to produce on-brand hero assets for your landing page, app store, or docs.

### 🖼️ Hero Image Prompt

```
A modern Flutter mobile app canvas editor interface, dark theme with deep purple (#1A1A2E) background, 
centered 1080x1080 canvas showing "Happy Diwali" in Devanagari script (नमस्ते) with gold accent line, 
product image layer with background removed, glowing sticker layer, bottom toolbar with text/image/sticker 
icons, top bar with undo/redo/brand-fill/export buttons, clean minimalist UI, 4K, soft neon accents, 
glassmorphism, professional SaaS design aesthetic
```

**Where to use:** README hero, landing page, app store screenshots

### 📱 Feature Image Prompts

| Feature | AI Image Prompt |
|---------|----------------|
| **Text Editing** | "Mobile app text editor overlay on dark canvas, Devanagari Bengali Tamil typography, font picker dropdown, color picker wheel, font size slider, purple and amber accent colors, 4K, clean UI" |
| **Image Editing** | "Photo editing interface with brightness/contrast/saturation sliders, background removal magic wand effect, product photo with transparent checkered background, dark theme, 4K" |
| **Video Export** | "Mobile video export screen showing image + audio timeline, MP4 rendering progress bar, FFmpeg pipeline visualization, dark purple theme, 4K" |
| **Brand Auto-Fill** | "Form with business name phone address tagline fields, logo upload placeholder, 'Apply to Canvas' button, instant text replacement preview on canvas behind form, dark theme, 4K" |
| **Template Picker** | "Grid of 5 starter templates (square, portrait, landscape, festival poster, business card), thumbnail cards with category tags, filter tabs, dark theme, 4K" |

### 🎨 Design Tokens

| Token | Value | Usage |
|-------|-------|-------|
| Primary | `#6750A4` | Active buttons, selected icons |
| Surface | `#12121e` | App background, cards |
| Canvas | `#1A1A2E` | Editor canvas background |
| Accent | `#FFB000` | Export CTAs, selection handles |
| Text | `#FFFFFF` | Primary headings |
| Muted | `#B0BEC5` | Secondary text, hints |

---

## ✨ Features

| Feature | Description | Status |
|---------|-------------|--------|
| 🖼️ **Layered Canvas** | Text, Image, Shape, Sticker, Paint layers with z-order | ✅ Done |
| 🎬 **Video Export** | Image + audio → MP4 via on-device FFmpeg | ✅ Done |
| 🏷️ **Brand Auto-Fill** | PlaceholderName matching + logo injection | ✅ Done |
| 🧹 **BG Removal** | On-device ONNX U2Net (no API cost) | ✅ Done |
| 🌐 **Indic Scripts** | Devanagari, Bengali, Tamil, Telugu, Gujarati | ✅ Done |
| 🎨 **Full Customization** | Theme, icons, fonts, toolbar, hooks | ✅ Done |
| 📦 **Template System** | Pluggable `TemplateProvider` interface | ✅ Done |
| 🎵 **Audio Library** | Pluggable `AudioProvider` with preview | ✅ Done |
| ↩️ **Undo/Redo** | 50-step immutable snapshot stack | ✅ Done |
| 📐 **Snap Lines** | Center + edge alignment guides | ✅ Done |
| 📱 **Offline-First** | 91% of features work without internet | ✅ Done |

---

## 🏗️ Architecture

canvas_studio follows a clean separation between the **SDK core** (pure Dart + Flutter) and the **host app** (providers, UI customization, data):

```
Host App
├── TemplateProvider      (fetch templates from your CDN)
├── AudioProvider         (fetch tracks, handle uploads)
├── StickerProvider       (fetch sticker packs)
└── CanvasEditorWidget    (theme, icons, hooks, feature gates)
        │
        ▼
    CanvasController      (single source of truth: CRUD, history, transforms)
        │
        ▼
    CanvasDocument        (root state: layers, audio, videoTrim)
        │
        ▼
    Layer Hierarchy       (Text, Image, Shape, Sticker, Paint)
        │
        ▼
    CustomPainter         (z-order rendering, RepaintBoundary per layer)
```

### Layer Types

| Layer | Icon | Use Case |
|-------|------|----------|
| `TextLayer` | 📝 | Titles, descriptions, Indic script text |
| `ImageLayer` | 🖼️ | Product photos, backgrounds, logos |
| `ShapeLayer` | 🔲 | Rectangles, circles, lines, polygons |
| `StickerLayer` | ✨ | Emoji, festival elements, decorative |
| `PaintLayer` | 🖌️ | Freehand drawing, signatures |

---

## 🔌 Plugin System (Ponytail)

canvas_studio integrates with the **Ponytail** engineering plugin ecosystem for autonomous development workflows:

| Plugin | Purpose |
|--------|---------|
| `ponytail` | Engineering standards — code review, quality gates, debt tracking |
| `ponytail:ponytail-audit` | Security scan and quality audit before commits |
| `ponytail:ponytail-debt` | Technical debt tracking and refactoring prompts |
| `ponytail:ponytail-gain` | Feature gain analysis and impact scoring |
| `ponytail:ponytail-help` | Context-aware help and onboarding for new contributors |
| `ponytail:ponytail-review` | Pre-commit review pipeline with auto-fix loops |

The plugin system is **configurable per-project** — enable only the ponytail modules you need via `config.yaml`.

## 🚀 Quick Start

### 1. Add to `pubspec.yaml`

```yaml
dependencies:
  canvas_studio: ^0.1.0
  # Optional: for background removal
  image_background_remover: ^2.0.0
  # Optional: for video export
  ffmpeg_kit_flutter_new: ^4.1.0
```

### 2. Basic Usage

```dart
import 'package:canvas_studio/canvas_studio.dart';
import 'dart:typed_data';

class MyEditorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = CanvasController.empty(
      canvasSize: const Size(1080, 1080),
      type: CanvasMediaType.image,
    );

    // Add a title layer
    controller.addLayer(TextLayer(
      id: 'title',
      name: 'Title',
      position: const Offset(80, 400),
      size: const Size(920, 120),
      text: 'Canvas Studio',
      fontFamily: 'Roboto',
      fontSize: 72,
      color: const Color(0xFFFFFFFF),
    ));

    // Add an image layer
    controller.addLayer(ImageLayer(
      id: 'product',
      name: 'Product Image',
      position: const Offset(200, 200),
      size: const Size(400, 400),
      imageUrl: 'https://cdn.example.com/product.jpg',
    ));

    return CanvasEditorWidget(
      controller: controller,
      config: CanvasEditorConfig.defaults,
      canvasBackground: const Color(0xFF1A1A2E),
      onExportImage: (result) async {
        // result.bytes — Uint8List PNG/JPG
        // result.suggestedFileName — filename
        await saveToGallery(result.bytes);
      },
      onSaveDraft: (doc) async {
        await saveDraftToHive(doc.toJson());
      },
      onFeatureLocked: (feature) {
        showUpgradeDialog(feature);
      },
    );
  }
}
```

### 3. Load a Template

```dart
final template = await templateProvider.fetchTemplateById('tpl_business_card');
final doc = CanvasDocument(
  id: template.id,
  canvasSize: template.canvasSize,
  type: CanvasMediaType.image,
  layers: template.layers.map((l) => layerFromJson(l)).toList(),
  updatedAt: DateTime.now(),
);
controller.loadDocument(doc);
```

### 4. Apply Brand Info

```dart
controller.applyBrandProfile(BrandProfile(
  businessName: 'Sharma Electronics',
  phone: '+91 98765 43210',
  address: 'Mumbai, India',
  tagline: 'Quality Products Since 1990',
  logoUrl: 'https://cdn.example.com/logo.png',
));
// All layers with placeholderName='business_name' get auto-filled
// Text auto-shrinks to fit layer bounds
// Single undo step for the entire operation
```

### 5. Export

```dart
// PNG export
final config = controller.buildExportConfig(
  format: ExportFormat.png,
  applyWatermark: true,
);
final result = await ExportRenderer.renderToBytes(
  controller.document,
  config.format,
);
// result.bytes → Uint8List
// result.suggestedFileName → 'canvas_export_1234567890.png'

// MP4 export (image + audio)
controller.setAudio(AudioConfig(
  trackId: 'audio_01',
  trackUrl: 'https://cdn.example.com/track.mp3',
  previewUrl: 'https://cdn.example.com/preview.mp3',
  trackName: 'Diwali Beat',
  duration: Duration(minutes: 3),
));
final videoConfig = controller.buildExportConfig(
  format: ExportFormat.mp4,
);
// FFmpeg command built on-device, no backend needed
```

---

## 📱 Example App

The `example/` directory contains a complete host app demonstrating every feature:

```
example/lib/
├── main.dart                    # App entry + TemplatePickerScreen route
├── screens/
│   ├── template_picker_screen.dart  # Template grid with category filters
│   ├── editor_screen.dart           # Full CanvasEditorWidget integration
│   ├── brand_profile_screen.dart    # Brand info form + logo picker
│   └── export_result_screen.dart    # Export preview + share
└── providers/
    ├── example_template_provider.dart   # 5 starter templates
    ├── example_audio_provider.dart      # 4 tracks with festival categories
    └── example_sticker_provider.dart    # 5 stickers across 3 categories
```

Run it:

```bash
cd example
flutter pub get
flutter run
```

---

## 🛠️ Provider Interfaces (Host App Implements)

```dart
abstract class TemplateProvider {
  Future<List<TemplateManifest>> fetchTemplates({
    String? category,
    TemplateAspectRatio? ratio,
    int page = 1,
  });
  Future<TemplateManifest?> fetchTemplateById(String id);
}

abstract class AudioProvider {
  Future<List<AudioTrack>> fetchTracks({String? festival, int page = 1});
  Future<List<String>> fetchCategories();
  Future<List<AudioTrack>> fetchUserUploads();
  Future<AudioTrack> uploadAudio(String localFilePath);
  bool canAccessTrack(AudioTrack track);
}

abstract class StickerProvider {
  Future<List<StickerCategory>> fetchCategories();
  Future<List<Sticker>> fetchStickers({String? categoryId, int page = 1});
}
```

---

## 🎨 Developer Customization

| Customization | How |
|---------------|-----|
| **Theme** | `CanvasEditorTheme` (ThemeExtension) — colors, borders, radii |
| **Icons** | `CanvasEditorIcons` — override any icon with one line |
| **Fonts** | `CanvasFontConfig` — Google + asset + network + per-script Indic |
| **Toolbar** | `CanvasToolbarConfig` — custom tools, layout, labels |
| **Slots** | `SlotOverrides` — 8 builder slots for custom UI |
| **Hooks** | `onExportImage`, `onSaveDraft`, `onFeatureLocked`, `onLayerSelected` |
| **Feature Gates** | `isFeatureEnabled(EditorFeature)` + `onFeatureLocked` callback |
| **Localization** | `CanvasEditorLocalizations` — EN, HI, MR, BN presets |

---

## 📦 Size & Performance

| Metric | Target |
|--------|--------|
| Core SDK APK size | < 5 MB |
| With ONNX BG removal | +25-30 MB (optional) |
| With FFmpeg video | +15-30 MB (optional) |
| PNG export time | < 500ms (1080×1080) |
| Canvas FPS (10 layers) | 60 fps |
| Undo/redo steps | 50 |
| Offline capability | 91% of features |

---

## 📋 Roadmap

```mermaid
gantt
    title canvas_studio Development Roadmap
    dateFormat  YYYY-MM-DD
    section Phase 1
    Core Canvas Engine       :done, p1, 2026-03-01, 3w
    Image + Text Tools       :done, p2, 2026-03-22, 2w
    section Phase 3
    Templates + Brand Auto-Fill :done, p3, 2026-04-05, 1w
    section Phase 4
    Audio + Video Export     :done, p4, 2026-04-12, 2w
    section Phase 5
    Developer Customization  :active, p5, 2026-04-26, 2w
    Example App + Publish    :p6, 2026-05-10, 2w
```

---

## 📄 License

MIT License — see [LICENSE](LICENSE) for details.

---

## 🤝 Contributing

1. Fork the repo
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'feat: add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

**Built with Flutter • Published on pub.dev • MIT Licensed**
