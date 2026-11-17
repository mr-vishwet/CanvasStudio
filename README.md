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

## 🎨 Design System & AI Image Prompts

The README ships two kinds of AI-generated visuals: **flat UI renders** of the finished SDK (hero + gallery — the idea of what's being built) and **concept "idea" art** for the design system. Everything is generated for free, in the design tokens underneath.

**Generation notes:** the concept set was made on [FreeGen.app](https://freegen.app) (Z-Image Turbo) and [Bing Image Creator](https://www.bing.com/images/create) (MAI-Image-2.6) — both free, no signup, no watermark. Alternatives tested: Felo AI and Leonardo.ai (login required), AI Free Forever (models overloaded).

### 🖼️ Hero Image Prompt

```
Cinematic concept artwork for an image & video editing canvas SDK. A glowing rounded-square
artboard floats in dark space with layered design elements hovering above it at different
depths — a photo card, an abstract type block, a star sticker, a flowing paint stroke — each
casting soft shadows to show z-order layering. Small tool chips orbit the artboard; one warm
golden export button glows. Wide landscape composition, generous dark negative space.
Style: dark premium tech illustration, near-black indigo background (#12121e), deep violet
(#6750A4) glassmorphic panels, warm gold (#FFB000) accent glow, soft neon rim lighting,
professional SaaS aesthetic. No text, no words, no letters, no numbers, no logos, no watermark.
```

**Where to use:** README hero, landing page, app store screenshots

### 📱 Feature Image Prompts

| Feature | AI Image Prompt |
|---------|----------------|
| **Text Editing** | "Multilingual Indic typography: three overlapping rounded font cards decorated with elegant abstract calligraphic brush strokes suggesting Devanagari, Bengali and Tamil scripts (decorative marks, not real words), floating color swatches, font-size slider, glowing language pill tags, dark violet + gold" |
| **Image Editing** | "One-tap background removal: a stylized sneaker floating in center, its background peeling away like a curled sheet of paper revealing a transparency checkerboard, magic wand with sparkles, dark violet + gold" |
| **Video Export** | "On-device video export: a horizontal film strip and timeline with glowing amber playhead, an audio waveform flowing into a rounded video-file card with a play symbol, circular progress ring, small lightning bolt, dark violet + gold" |
| **Brand Auto-Fill** | "Brand auto-fill: a poster template card with glowing empty placeholder slots, a floating identity kit (logo, phone, address, tagline chips) sliding into the slots along curved golden arrows, magnetic snap sparkles, dark violet + gold" |
| **Template Picker** | "Template gallery: a neat grid of floating template cards in mixed aspect ratios (square, portrait, landscape) with abstract layout blocks in violet, teal and gold, category pill tabs above, one card highlighted with a golden selection border, dark violet + gold" |

> Every prompt ends with the shared style suffix above (near-black indigo background, violet glass panels, gold accent glow, no text/watermark) so all six images stay visually consistent.

### 📱 SDK Screenshot Prompts (real-looking UI)

The SDK is a **general-purpose image *and* video editor** — these renders show it as the core of a host team's own mobile app (a mobile team ships their editor by embedding this SDK, not building from scratch). Flat solid Material 3, exact portrait, real product screens — no poster-only mockups, no glassmorphism/glow. Each prompt is self-contained; paste any one alone. AI garbles small text — keep the render with the fewest/shortest labels.

**One-shot hero prompt** (video mode — full screen in one paste):

```
Realistic portrait smartphone screenshot, exact 9:19.5 aspect ratio, of a finished Flutter video & image editing app built with the Canvas Studio SDK, straight-on screen capture. Flat Material 3 dark UI, solid surfaces only — no glassmorphism, no glow. Top: status bar, app bar with back arrow, project title "Trip Vlog", undo/redo icons, gold Export button. Upper half: 16:9 video preview frame showing a travel vlog clip with one caption text layer selected and corner drag handles. Lower half: multi-track timeline — a video track of thumbnail clips with violet trim handles, an audio track with waveform, a text caption track — gold playhead with play/scrub controls; Image/Video mode tabs above the timeline. Bottom toolbar: Text, Image, Sticker, Music, Templates — one highlighted violet. Near-black indigo (#12121e) background, deep violet (#6750A4) active states, warm gold (#FFB000) primary actions and handles, white/muted-gray text. Pixel-sharp native Flutter rendering, 4K. No watermark, no brand logos, no lorem ipsum.
```

**Per-screen prompts:**

| Screen | AI Image Prompt |
|--------|----------------|
| **Home / projects** | "Realistic screenshot of a finished Flutter editing app home screen: top bar with profile avatar and search icon, segmented tabs Image and Video with Video active in violet, a large dashed New project card, a Continue editing grid of two project thumbnails (a travel clip and a product photo) with durations, a horizontal Start from template row. Flat Material 3 dark UI, solid surfaces only — no glassmorphism, no glow. Near-black indigo (#12121e) background, deep violet (#6750A4) filled buttons and active states, warm gold (#FFB000) primary actions and selection handles, white headings, muted gray text. Pixel-sharp native Flutter rendering, exact 9:19.5 portrait phone screenshot, straight-on. No watermark, no brand logos, no lorem ipsum." |
| **Image editor** | "Realistic screenshot of the image editor: top bar with back arrow, project title, undo/redo and a gold Export button; centered square artboard showing a product photo of a coffee cup on a table with one text layer selected showing corner drag handles; a compact layers strip on the right with thumbnails for text, image, shape, sticker and paint; bottom toolbar Text, Image, Shape, Sticker, Paint, Templates with Text highlighted violet. Flat Material 3 dark UI, solid surfaces only — no glassmorphism, no glow. Near-black indigo (#12121e) background, deep violet (#6750A4) filled buttons and active states, warm gold (#FFB000) primary actions and selection handles, white headings, muted gray text. Pixel-sharp native Flutter rendering, exact 9:19.5 portrait phone screenshot, straight-on. No watermark, no brand logos, no lorem ipsum." |
| **Text editing** | "Realistic screenshot of text editing mode: a short headline text block selected on the canvas with a violet caret and corner handles; bottom sheet with a font list, a horizontal color swatch row with violet and gold active, a font-size slider and alignment plus bold/italic icon buttons. Flat Material 3 dark UI, solid surfaces only — no glassmorphism, no glow. Near-black indigo (#12121e) background, deep violet (#6750A4) filled buttons and active states, warm gold (#FFB000) primary actions and selection handles, white headings, muted gray text. Pixel-sharp native Flutter rendering, exact 9:19.5 portrait phone screenshot, straight-on. No watermark, no brand logos, no lorem ipsum." |
| **Background removal** | "Realistic screenshot of one-tap background removal: a product photo of a sneaker split into before and after halves by a vertical drag divider, left half original background, right half transparency checkerboard, a gold Remove background button and a small processing badge. Flat Material 3 dark UI, solid surfaces only — no glassmorphism, no glow. Near-black indigo (#12121e) background, deep violet (#6750A4) filled buttons and active states, warm gold (#FFB000) primary actions and selection handles, white headings, muted gray text. Pixel-sharp native Flutter rendering, exact 9:19.5 portrait phone screenshot, straight-on. No watermark, no brand logos, no lorem ipsum." |
| **Music / audio** | "Realistic screenshot of a music picker bottom sheet over a dimmed editor: rows of tracks each with a small waveform bar, duration label and a violet add button, a category row of pills Trending, Calm, Upbeat, one row expanded with a mini player. Flat Material 3 dark UI, solid surfaces only — no glassmorphism, no glow. Near-black indigo (#12121e) background, deep violet (#6750A4) filled buttons and active states, warm gold (#FFB000) primary actions and selection handles, white headings, muted gray text. Pixel-sharp native Flutter rendering, exact 9:19.5 portrait phone screenshot, straight-on. No watermark, no brand logos, no lorem ipsum." |
| **Brand auto-fill** | "Realistic screenshot of a brand auto-fill panel: form fields for business name, phone, address, tagline and a logo upload row, a gold Apply to canvas button at the bottom, a canvas with empty placeholder slots faintly visible above the sheet. Flat Material 3 dark UI, solid surfaces only — no glassmorphism, no glow. Near-black indigo (#12121e) background, deep violet (#6750A4) filled buttons and active states, warm gold (#FFB000) primary actions and selection handles, white headings, muted gray text. Pixel-sharp native Flutter rendering, exact 9:19.5 portrait phone screenshot, straight-on. No watermark, no brand logos, no lorem ipsum." |
| **Templates** | "Realistic screenshot of a template gallery: category pills at top — All, Poster, Story, Thumbnail, Reel cover — a two-column grid of template thumbnails in portrait and square ratios with abstract layouts in violet, teal and gold, one card highlighted with a gold border. Flat Material 3 dark UI, solid surfaces only — no glassmorphism, no glow. Near-black indigo (#12121e) background, deep violet (#6750A4) filled buttons and active states, warm gold (#FFB000) primary actions and selection handles, white headings, muted gray text. Pixel-sharp native Flutter rendering, exact 9:19.5 portrait phone screenshot, straight-on. No watermark, no brand logos, no lorem ipsum." |
| **Export sheet** | "Realistic screenshot of an export bottom sheet: format chips PNG, JPG, MP4 with MP4 active in violet, resolution rows 720p, 1080p, 4K with 1080p checked, an estimated size label, a full-width gold Export button, a circular progress ring at 60 percent. Flat Material 3 dark UI, solid surfaces only — no glassmorphism, no glow. Near-black indigo (#12121e) background, deep violet (#6750A4) filled buttons and active states, warm gold (#FFB000) primary actions and selection handles, white headings, muted gray text. Pixel-sharp native Flutter rendering, exact 9:19.5 portrait phone screenshot, straight-on. No watermark, no brand logos, no lorem ipsum." |

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

> Architecture is documented here as a **plain-text diagram on purpose** — no architecture image asset. All README visuals are AI-generated from the [prompts above](#-design-system--ai-image-prompts).

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
