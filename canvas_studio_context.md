# canvas_studio — Full Project Context File
# Version: 1.0 | Last Updated: March 2026
# Use this file as the single source of truth when starting any coding session.
# Feed this to your AI assistant, share with new team members, or use as onboarding doc.

---

## 1. WHAT IS THIS PROJECT

`canvas_studio` is a lightweight, general-purpose Flutter SDK (published as a pub.dev package)
for building image and video editing canvas experiences inside any Flutter app.

It is NOT an app. It is a library that host apps embed.
The primary reference implementation (host app) is AdBanao — a poster/banner creator.

Core philosophy:
- Canvas is pure UI + state. No HTTP calls inside the library.
- Host app injects all data (templates, audio, stickers) via abstract provider interfaces.
- 91% of features run fully on-device (offline-capable).
- Video rendering uses on-device FFmpeg (ffmpeg_kit_flutter_new) — no backend required for export.
- Backend is only needed for: remote content delivery, cross-device sync, receipt validation.

---

## 2. TECHNOLOGY STACK

Language:        Dart / Flutter (SDK >=3.3.0)
Min Flutter:     3.19.0
Platforms:       Android (API 21+), iOS (13+)
State mgmt:      ChangeNotifier (no Riverpod/Bloc — keeps SDK dependency-light)
Rendering:       Flutter CustomPainter + RepaintBoundary
Video:           ffmpeg_kit_flutter_new (on-device FFmpeg)
BG Removal:      image_background_remover (ONNX U2Net, on-device)
Audio playback:  just_audio
Fonts:           google_fonts + bundled Indic asset fonts
Local storage:   hive_flutter (for draft cache in example app — not in core SDK)
Image cache:     flutter_cache_manager + cached_network_image

---

## 3. REPOSITORY STRUCTURE

canvas_studio/
├── lib/
│   ├── canvas_studio.dart              ← PUBLIC barrel export (only file host app imports)
│   └── src/
│       ├── models/                     ← Pure Dart models, zero Flutter dependency
│       │   ├── canvas_document.dart    ← Root state object
│       │   ├── audio_config.dart
│       │   ├── animation_config.dart
│       │   ├── brand_profile.dart
│       │   ├── effect_config.dart
│       │   ├── template_manifest.dart
│       │   ├── layer/
│       │   │   ├── layer.dart          ← Abstract base class
│       │   │   ├── text_layer.dart
│       │   │   ├── image_layer.dart
│       │   │   ├── shape_layer.dart
│       │   │   ├── sticker_layer.dart
│       │   │   └── paint_layer.dart    ← Freehand brush
│       │   └── export/
│       │       ├── export_config.dart
│       │       └── video_trim_config.dart
│       │
│       ├── state/
│       │   ├── canvas_controller.dart  ← CORE: ChangeNotifier, single source of truth
│       │   ├── history_manager.dart    ← Undo/redo (immutable snapshot stack, max 50)
│       │   ├── selection_state.dart
│       │   ├── video_trim_state.dart
│       │   └── audio_library_controller.dart
│       │
│       ├── rendering/
│       │   ├── canvas_painter.dart     ← CustomPainter, paints all layers in z-order
│       │   ├── layer_renderer.dart     ← Per-layer paint logic
│       │   ├── export_renderer.dart    ← Offscreen high-res PictureRecorder render
│       │   └── video_thumbnail_strip.dart
│       │
│       ├── widgets/
│       │   ├── canvas_editor_widget.dart  ← MAIN entry widget (host app uses this)
│       │   ├── canvas_editor_config.dart  ← All config + feature flags
│       │   ├── canvas_view.dart           ← GestureDetector + InteractiveViewer + CustomPaint
│       │   ├── toolbars/
│       │   │   ├── main_toolbar.dart
│       │   │   ├── text_toolbar.dart
│       │   │   ├── image_toolbar.dart
│       │   │   ├── video_toolbar.dart
│       │   │   └── animation_toolbar.dart
│       │   ├── panels/
│       │   │   ├── layer_panel.dart        ← ReorderableListView
│       │   │   ├── audio_picker_panel.dart
│       │   │   └── sticker_picker_panel.dart
│       │   ├── pickers/
│       │   │   ├── font_picker.dart
│       │   │   ├── color_picker.dart
│       │   │   └── effect_picker.dart
│       │   └── slots/
│       │       └── slot_overrides.dart     ← All builder callback types defined here
│       │
│       ├── modules/                        ← Feature-specific logic, isolated
│       │   ├── text/
│       │   │   ├── text_edit_controller.dart
│       │   │   └── indic_font_support.dart
│       │   ├── image/
│       │   │   ├── image_manipulation.dart
│       │   │   └── crop_handler.dart
│       │   ├── audio/
│       │   │   ├── audio_library_controller.dart
│       │   │   └── audio_track_model.dart
│       │   ├── video/
│       │   │   ├── video_trim_widget.dart
│       │   │   ├── crop_grid_widget.dart
│       │   │   └── cover_selection_widget.dart
│       │   ├── effects/
│       │   │   └── effect_engine.dart      ← ColorFilter matrix + ImageFilter
│       │   ├── bg_removal/
│       │   │   ├── bg_removal_service.dart ← Tiered: onDevice → backend fallback
│       │   │   └── bg_removal_config.dart
│       │   ├── brand/
│       │   │   └── brand_autofill.dart     ← placeholderName matching + autoFitFontSize
│       │   ├── export/
│       │   │   ├── export_handler.dart     ← Routes to image or video export
│       │   │   └── ffmpeg_command_builder.dart ← Builds FFmpeg command string
│       │   └── animation/
│       │       └── animation_preview.dart  ← Lightweight in-editor preview only
│       │
│       ├── providers/                      ← ABSTRACT interfaces — host app implements
│       │   ├── template_provider.dart
│       │   ├── audio_provider.dart
│       │   └── sticker_provider.dart
│       │
│       ├── theme/
│       │   ├── canvas_editor_theme.dart    ← ThemeExtension with full customization
│       │   ├── canvas_editor_icons.dart    ← Icon override map
│       │   ├── canvas_font_config.dart     ← Font injection: Google + asset + network
│       │   └── canvas_toolbar_config.dart  ← Toolbar items, order, custom tools
│       │
│       ├── localization/
│       │   └── canvas_editor_localizations.dart  ← All UI strings, multi-language
│       │
│       ├── utils/
│       │   ├── text_fit_util.dart          ← autoFitFontSize() using TextPainter
│       │   ├── font_loader.dart            ← Loads Google + asset + network fonts
│       │   ├── gesture_handler.dart        ← Tap/drag/pinch/rotate per layer
│       │   ├── connectivity_watcher.dart
│       │   └── cache_manager.dart
│       │
│       └── platform/
│           ├── android/
│           │   └── android_bg_removal.dart ← ML Kit Selfie Segmentation channel
│           └── ios/
│               └── ios_bg_removal.dart     ← Apple Vision framework channel
│
├── assets/
│   ├── fonts/indic/                    ← NotoSansDevanagari, Bengali, Tamil, Telugu etc.
│   ├── fonts/latin/                    ← Optional bundled fallback Latin fonts
│   ├── templates/starter/              ← 5-10 bundled starter templates (JSON)
│   ├── stickers/default/              ← Default sticker pack (50-100 PNGs)
│   ├── audio/starter/                 ← 3-5 royalty-free starter tracks
│   └── icons/                         ← SVG tool icons
│
├── test/
│   ├── unit/models/
│   ├── unit/state/
│   ├── unit/modules/
│   ├── widget/
│   ├── golden/
│   └── integration/
│
├── example/                           ← Full working example app
│   └── lib/
│       ├── main.dart
│       ├── screens/
│       └── providers/                 ← Example implementations of TemplateProvider etc.
│
└── docs/
    ├── api/
    └── guides/

---

## 4. CORE DATA MODELS (QUICK REFERENCE)

### CanvasDocument
Root object. Serializes to/from JSON for drafts and backend export.
Fields: id, templateId, canvasSize, type(image|video), layers[], audio, videoTrim, updatedAt

### Layer (abstract base)
Fields: id, name, type, position(Offset), size, rotation, opacity, isVisible, isLocked,
        placeholderName, entranceAnimation, exitAnimation
Subtypes: TextLayer, ImageLayer, ShapeLayer, StickerLayer, PaintLayer

### TextLayer extra fields
text, fontFamily, fontSize, fontWeight, color, textAlign, isIndicScript

### ImageLayer extra fields
imageUrl, localPath, cropRect, effects(EffectConfig), hasTransparentBg

### ExportConfig
outputType: staticImage | slideshowVideo | animatedVideo
format: png | jpg | mp4
Key logic: image doc + audio attached + mp4 requested → auto-resolves to slideshowVideo
           image doc + animation layers + audio → auto-resolves to animatedVideo

### VideoTrimConfig
startTrim, endTrim, minCrop(Offset), maxCrop(Offset), rotation, selectedCover

---

## 5. CANVASCONTROLLER — KEY METHODS

// Layer CRUD
addLayer(Layer), removeLayer(String id), updateLayer(String id, Layer),
reorderLayers(int old, int new), duplicateLayer(String id), toggleVisibility(String id)

// Selection
selectLayer(String? id), addToSelection(String id), clearSelection()

// Transforms
moveLayer(String id, Offset delta), resizeLayer(String id, Size), rotateLayer(String id, double)

// History
undo(), redo(), canUndo (bool), canRedo (bool)

// Brand fill (single undo step)
applyBrandProfile(BrandProfile profile)

// Video
updateTrim(Duration start, Duration end), rotateVideo90(RotateDirection), updateCrop(min, max)

// Audio
setAudio(AudioConfig? config)

// Export
Future<Uint8List> renderToImage({double pixelRatio = 3.0})
ExportConfig buildExportConfig({required ExportFormat format, bool applyWatermark})

// Serialization
Map<String,dynamic> toJson()
factory CanvasController.fromJson(Map json)

---

## 6. RENDERING RULES

1. Canvas renders using CustomPainter (CanvasPainter).
2. Each layer wrapped in RepaintBoundary — only the moved/changed layer repaints.
3. Image effects applied at LOW resolution (400px) during editing.
4. Image effects applied at FULL resolution during export only.
5. shouldRepaint() returns true only when affected layer data changes.
6. InteractiveViewer wraps canvas for pinch-zoom/pan support.
7. Animations are DATA ONLY in editor — static badge shown, no live animation loop.
8. FFmpeg renders animations during video export (on-device via ffmpeg_kit).

---

## 7. EXPORT DECISION TREE

User taps Export →
  document.type == image AND audio == null  → PNG/JPG (ExportRenderer.renderToBytes)
  document.type == image AND audio != null  → MP4 slideshowVideo (FFmpeg: -loop 1 image + audio)
  document.type == image AND audio != null AND hasAnimationLayers → MP4 animatedVideo (FFmpeg filter_complex)
  document.type == video                    → MP4 animatedVideo (FFmpeg full pipeline)

FFmpeg command built by: FFmpegCommandBuilder.build(ExportConfig)
Executed by: FFmpegKit.executeAsync(command, callback)
Output saved to: path_provider app documents dir → image_gallery_saver to gallery

---

## 8. PROVIDER INTERFACES (HOST APP MUST IMPLEMENT)

abstract class TemplateProvider {
  Future<List<TemplateManifest>> fetchTemplates({String? category, TemplateAspectRatio? ratio, int page});
  Future<TemplateManifest> fetchTemplateById(String id);
}

abstract class AudioProvider {
  Future<List<AudioTrack>> fetchTracks({String? festival, int page});
  Future<List<String>> fetchCategories();
  Future<List<AudioTrack>> fetchUserUploads();
  Future<AudioTrack> uploadAudio(String localFilePath);
  bool canAccessTrack(AudioTrack track);
}

abstract class StickerProvider {
  Future<List<StickerCategory>> fetchCategories();
  Future<List<Sticker>> fetchStickers({String? categoryId, int page});
}

---

## 9. BACKGROUND REMOVAL STRATEGY

BgRemovalMode.onDevice   → image_background_remover (ONNX U2Net) — no backend, +30MB APK
BgRemovalMode.backendApi → host app callback: onBackgroundRemovalRequested(imageUrl) → new URL
BgRemovalMode.tiered     → try onDevice first; if fails, call backendApi (DEFAULT)

Config:
BgRemovalConfig(mode: BgRemovalMode.tiered, onnxThreshold: 0.5, smoothMask: true)

---

## 10. TEMPLATE JSON SCHEMA (CANONICAL — v1.0)

{
  "schema_version": "1.0",
  "id": "tpl_xxx",
  "name": "...",
  "category": "festival|business|sale|...",
  "tags": [],
  "ratio": "square_1x1|portrait_9x16|landscape_16x9|a4_print",
  "canvas_size": {"width": 1080, "height": 1080},
  "type": "image|video",
  "video_duration_ms": null,
  "thumbnail_url": "...",
  "preview_gif_url": "...",
  "source": "self_hosted|vendor_cdn|user_custom",
  "default_audio_id": null,
  "layers": [ ...layer objects... ]
}

Each layer object:
{
  "id", "type", "name", "z_index", "placeholder_name",
  "position": {"x","y"}, "size": {"width","height"},
  "rotation", "opacity", "is_visible", "is_locked",
  // TextLayer adds: text, font_family, font_size, font_weight, color, alignment, entrance_animation
  // ImageLayer adds: image_url, local_path, effects: {brightness, contrast, saturation, blur_radius, vignette}
  // ShapeLayer adds: shape_type, fill_color, stroke_color, stroke_width
}

---

## 11. BACKEND DEPENDENCY MAP

Feature                       | Local% | Backend% | Notes
------------------------------|--------|----------|-------------------------------------------
Canvas render/paint           | 100%   | 0%       | CustomPainter
Text editing + Indic fonts    | 100%   | 0%       | HarfBuzz + GoogleFonts
Image effects + filters       | 100%   | 0%       | ColorFilter + ImageFilter
Image export PNG/JPG          | 100%   | 0%       | ExportRenderer (PictureRecorder)
Gestures + transforms         | 100%   | 0%       | GestureDetector + matrix
Undo/redo                     | 100%   | 0%       | HistoryManager snapshots
Draft save (local)            | 100%   | 0%       | Hive
BG removal                    | 95%    | 5%       | ONNX local; backend edge-case fallback
Audio playback preview        | 90%    | 10%      | just_audio streams CDN URL
Video export (FFmpeg)         | 90%    | 10%      | ffmpeg_kit on-device; heavy = backend
Animation rendering           | 85%    | 15%      | ffmpeg_kit; complex = backend
Image+audio → MP4             | 95%    | 5%       | ffmpeg_kit -loop 1
Watermark                     | 95%    | 5%       | FFmpeg overlay / CustomPainter bake
Template fetch                | 30%    | 70%      | Starter pack bundled; rest from CDN
Audio library                 | 40%    | 60%      | Starter bundled; premium from CDN
User logo storage             | 85%    | 15%      | Local path_provider; sync optional
Draft sync (cross-device)     | 25%    | 75%      | Local primary; backend optional sync
Subscription/quota            | 65%    | 35%      | StoreKit/Play Billing local + server validation

OVERALL: ~85% LOCAL / ~15% BACKEND

---

## 12. THIRD-PARTY BACKEND TOOL SUGGESTIONS

### For Templates
Option A — Self-hosted (RECOMMENDED)
  - Store template JSONs in S3 / Cloudflare R2 / Supabase Storage
  - Serve via REST API: GET /templates?category=diwali&ratio=square_1x1&page=1
  - Assets (images) on Cloudflare CDN (fastest, cheapest)
  - Schema: use canvas_studio TemplateManifest JSON schema v1.0 directly

Option B — Third-party
  - APITemplate.io: REST API generates images from templates, has template editor UI
    Free tier: 100 renders/month | Paid: $29/mo+
    Use case: if you want a no-code template editor for your content team
  - Canva API (enterprise): template marketplace, expensive
  - Freepik API: large template library, requires attribution on free tier

### For Audio
Option A — Self-hosted (RECOMMENDED for Indian festival content)
  - Store MP3s on Cloudflare R2 (pay per GB, very cheap)
  - Pre-generate 30-second preview clips server-side (FFmpeg one-time job)
  - Serve track list via REST: GET /audio/tracks?festival=diwali
  - Use royalty-free Indian music from: Pixabay Music, Mixkit, FreePD, ccMixter

Option B — Third-party APIs
  - Jamendo API: 600,000+ royalty-free tracks, free API, commercial license available
    GET https://api.jamendo.com/v3.0/tracks/?client_id=xxx&fuzzytags=festival
  - Freesound API: Creative Commons audio, free, 500k+ sounds
  - Pixabay API: Free music + SFX, no attribution required for free tier
  - Mubert API: AI-generated royalty-free music, mood/genre based, $0.05/track

Option C — For Indian festivals specifically
  - License tracks from Hungama, Saregama (B2B licensing)
  - Or generate festival-specific tracks using Suno AI / Udio (royalty-free output)

### For Background Removal (backend fallback)
  - Remove.bg API: Best quality, $0.20/image, free 50/month
  - ClipDrop API (Stability AI): $0.05/image, bulk pricing
  - PhotoRoom API: Good for product photos, $0.03/image
  - Replicate (BRIA RMBG model): $0.002/image — cheapest, self-serve

### For Stickers / Elements
  - LottieFiles API: Animated stickers (Lottie JSON), free tier available
  - Icons8 API: 1M+ icons and stickers, $19/mo for commercial
  - Flaticon API (Freepik): Vector icons, attribution required on free
  - Self-host: Buy a one-time pack from Creative Market / Envato, serve from CDN

---

## 13. SELF-HOSTED BACKEND MINIMAL SETUP

Minimal backend stack to support the library (if host app builds their own):

Stack: Node.js (Express) + PostgreSQL + Supabase Storage / S3 + Redis (cache)

Endpoints needed:
  GET  /templates              → list, paginated, filterable by category/ratio/type
  GET  /templates/:id          → single template manifest JSON
  GET  /audio/tracks           → list, filterable by festival
  GET  /audio/categories       → list of festival categories
  POST /audio/upload           → user uploads audio file
  POST /export/image           → async image render job (if not using local render)
  POST /export/video           → async video render job (FFmpeg on server)
  GET  /export/:jobId/status   → poll export job status
  POST /bg-removal             → background removal AI job
  GET  /bg-removal/:jobId      → poll bg removal status
  POST /drafts                 → save/update draft (cross-device sync)
  GET  /drafts                 → list user drafts
  POST /subscription/validate  → server-side receipt validation

Docker Compose for local dev:
  services: api (Node), postgres, redis, minio (S3-compatible local storage)

---

## 14. SIZE OPTIMIZATION STRATEGY

Target: Core SDK < 5MB added to host app APK (excluding ONNX model)
        With ONNX bg removal: +25-30MB (optional, gated by BgRemovalConfig)
        With ffmpeg_kit: +15-30MB (optional, gated by ExportConfig)

Techniques:
1. flutter build apk --release --tree-shake-icons  (up to 60% icon size reduction)
2. Deferred imports for heavy modules (ffmpeg_kit, ONNX) — load only when first used
3. Bundle only 5 starter templates (JSON, ~50KB total)
4. Bundle only 50 starter stickers (WebP format, ~2MB total)
5. Indic fonts: load only selected scripts (toggles in CanvasFontConfig)
6. google_fonts: only load requested fonts, not full library
7. No heavy reflection — keeps Dart tree shaking effective
8. Use WebP for all bundled image assets
9. Conditional imports: platform/android vs platform/ios modules

---

## 15. DEVELOPMENT PHASES

Phase 1 — Core Canvas (Weeks 1-3)
  ✅ CanvasDocument + Layer models
  ✅ CanvasController (add/remove/update/reorder layers)
  ✅ HistoryManager (undo/redo)
  ✅ CanvasPainter (render all layer types)
  ✅ GestureHandler (tap, drag, pinch, rotate)
  ✅ ExportRenderer (PNG/JPG)
  ✅ TextLayer editing + autoFitFontSize

Phase 2 — Image Tools (Weeks 4-5)
  ✅ ImageLayer (replace, crop, filters/effects)
  ✅ EffectEngine (ColorFilter matrix)
  ✅ BgRemovalService (ONNX on-device)
  ✅ ShapeLayer, StickerLayer

Phase 3 — Brand + Template System (Week 6)
  ✅ BrandAutoFill module
  ✅ TemplateProvider interface + asset-based implementation
  ✅ TemplateManifest JSON schema v1.0

Phase 4 — Audio + Video (Weeks 7-8)
  ✅ AudioLibraryController + just_audio
  ✅ AudioPickerPanel
  ✅ VideoTrimConfig + VideoTrimWidget
  ✅ FFmpegCommandBuilder
  ✅ ExportHandler (image → PNG, image+audio → MP4, video → MP4)

Phase 5 — Developer Customization (Week 9)
  ✅ CanvasEditorTheme (ThemeExtension)
  ✅ CanvasFontConfig (Google + asset + network fonts)
  ✅ CanvasToolbarConfig (custom tools injection)
  ✅ All widget slot builder overrides
  ✅ CanvasEditorLocalizations

Phase 6 — Polish + Publish (Week 10)
  ✅ Full test suite (unit + widget + golden + integration)
  ✅ Example app
  ✅ API documentation
  ✅ pub.dev publish prep (CHANGELOG, LICENSE, README)
