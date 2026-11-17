# 🎨 canvas_studio

> A lightweight, general-purpose Flutter SDK for building image & video editing canvas experiences — **offline-first, on-device, pub.dev ready**.

---

## 🎯 What We're Building

**canvas_studio** is a Flutter SDK that host apps embed to give their users a full-featured image and video editing canvas — no backend required for 91% of features.

<p align="center">
  <img src="docs/assets/reference/Trip%20Vlog%20Video%20Editor.png" width="340" alt="Canvas Studio video editor — preview, multi-track timeline, layers and export">
</p>

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

## 🎨 Design System

Colors used across the SDK and every render in this README.

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

All features ship in the SDK today:

- 🖼️ **Layered Canvas** — Text, Image, Shape, Sticker, Paint layers with z-order
- 🎬 **Video Export** — Image + audio → MP4 via on-device FFmpeg
- 🏷️ **Brand Auto-Fill** — PlaceholderName matching + logo injection
- 🧹 **BG Removal** — On-device ONNX U2Net (no API cost)
- 🌐 **Indic Scripts** — Devanagari, Bengali, Tamil, Telugu, Gujarati
- 🎨 **Full Customization** — Theme, icons, fonts, toolbar, hooks
- 📦 **Template System** — Pluggable `TemplateProvider` interface
- 🎵 **Audio Library** — Pluggable `AudioProvider` with preview
- ↩️ **Undo/Redo** — 50-step immutable snapshot stack
- 📐 **Snap Lines** — Center + edge alignment guides
- 📱 **Offline-First** — 91% of features work without internet

### 💡 The Idea — What's Being Built

Concept renders of the finished SDK — not literal screenshots, just the idea of what a host team's mobile app looks like built on top of it:

<table>
  <tr>
    <td align="center"><img src="docs/assets/reference/Diagonal%20Demo%20App%20Overlay.png" width="210" alt="Home screen"><br><sub>Home &amp; projects</sub></td>
    <td align="center"><img src="docs/assets/reference/Trip%20Vlog%20Video%20Editor.png" width="210" alt="Video editor"><br><sub>Video editor — preview + timeline</sub></td>
  </tr>
  <tr>
    <td align="center"><img src="docs/assets/reference/Coffee%20Vibes%20Mobile%20Design%20Editor.png" width="210" alt="Image editor"><br><sub>Image editor — layers</sub></td>
    <td align="center"><img src="docs/assets/reference/Diwali%20Poster%20Editor%20Interface%20%281%29.png" width="210" alt="Poster editor with layer list"><br><sub>Layer list</sub></td>
  </tr>
  <tr>
    <td align="center"><img src="docs/assets/reference/Coffee%20Vibes%20Mobile%20Editor.png" width="210" alt="Text editing"><br><sub>Text editing — fonts, color, size</sub></td>
    <td align="center"><img src="docs/assets/reference/Sleek%20Sneaker%20Background%20Remover.png" width="210" alt="Background removal"><br><sub>Background removal</sub></td>
  </tr>
  <tr>
    <td align="center"><img src="docs/assets/reference/Travel%20Vlog%20Music%20Picker.png" width="210" alt="Music picker"><br><sub>Music picker</sub></td>
    <td align="center"><img src="docs/assets/reference/Brand%20Auto-Fill%20Mobile%20UI.png" width="210" alt="Brand auto-fill"><br><sub>Brand auto-fill</sub></td>
  </tr>
  <tr>
    <td align="center"><img src="docs/assets/reference/Dark%20Templates%20Gallery%20UI.png" width="210" alt="Templates"><br><sub>Templates</sub></td>
    <td align="center"><img src="docs/assets/reference/Dark%20Export%20Project%20Dialog.png" width="210" alt="Export"><br><sub>Export — PNG / JPG / MP4</sub></td>
  </tr>
</table>

---

## 🏗️ Architecture

canvas_studio follows a clean separation between the **SDK core** (pure Dart + Flutter) and the **host app** (providers, UI customization, data):

> Architecture is documented here as a **plain-text diagram on purpose** — no architecture image asset.

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

## 📄 License

MIT License — see [LICENSE](LICENSE) for details.

---

**Built with Flutter • Published on pub.dev • MIT Licensed**
