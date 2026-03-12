# canvas_studio

A lightweight, general-purpose Flutter SDK for building image and video editing canvas experiences.

## Features
- Layered canvas — text, image, shape, sticker, paint layers
- Image + audio → video export via on-device FFmpeg
- Brand info auto-fill with placeholder system
- On-device background removal (ONNX U2Net — no API cost)
- Full developer customization: theme, icons, fonts, toolbar, hooks
- Indic script support — Devanagari, Bengali, Tamil, Telugu, Gujarati
- Template system with pluggable TemplateProvider interface
- Audio library with pluggable AudioProvider interface
- Undo/redo, snap lines, multi-select
- Offline-first — 91% of features work without internet

## Quick Start

```dart
import 'package:canvas_studio/canvas_studio.dart';

CanvasEditorWidget(
  controller: CanvasController.empty(
    canvasSize: const Size(1080, 1080),
    mediaType: CanvasMediaType.image,
  ),
  config: CanvasEditorConfig.defaults(),
  onExportImage: (Uint8List bytes, ExportFormat format) async {
    // save to gallery, upload, etc.
  },
  onSaveDraft: (CanvasDocument doc) async {
    // save to Hive / backend
  },
)
```

## Documentation
See [docs/](docs/) for full API reference and integration guides.
