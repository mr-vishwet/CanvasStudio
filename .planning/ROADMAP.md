# canvas_studio — GSD Roadmap

## Phases (from canvas_studio_development_plan.txt)

### Phase 1 — Core Canvas Engine (Weeks 1-3)
- [x] Data Models (CanvasDocument, Layer hierarchy, AnimationConfig, EffectConfig, ExportConfig, VideoTrimConfig)
- [x] CanvasController + HistoryManager + SelectionState
- [x] Canvas Rendering (CanvasPainter, LayerRenderer, CanvasView) — partially implemented
- [x] Gesture System (GestureHandler) — partially implemented
- [x] Image Export (ExportRenderer, ExportHandler)
- [x] Main Widget Shell (CanvasEditorWidget, CanvasEditorConfig)

### Phase 2 — Image + Text Tools (Weeks 4-5)
- [x] Text Editing Module (TextEditController, IndicFontSupport, TextFitUtil, FontLoader)
- [x] Image Tools (ImageManipulation, CropHandler, EffectEngine)
- [x] Background Removal (BgRemovalService, BgRemovalConfig, platform channels)
- [x] Layer Panel, Audio Picker Panel, Sticker Picker Panel
- [ ] Pickers: ColorPicker, EffectPicker, FontPicker
- [ ] Toolbars: AnimationToolbar, ImageToolbar, TextToolbar, VideoToolbar

### Phase 3 — Templates + Brand Auto-Fill (Week 6)
- [x] TemplateManifest model
- [x] TemplateProvider interface
- [x] BrandAutoFill module
- [ ] AssetTemplateProvider (bundled starter templates)
- [ ] 5 starter template JSON files

### Phase 4 — Audio + Video Export (Weeks 7-8)
- [x] AudioTrack model, AudioLibraryController, AudioProvider interface
- [x] VideoTrimWidget, CropGridWidget, CoverSelectionWidget, VideoTrimState
- [x] FFmpegCommandBuilder
- [ ] VideoThumbnailStrip rendering
- [ ] Full FFmpeg export pipeline integration

### Phase 5 — Developer Customization + Example App + Polish (Weeks 9-10)
- [x] CanvasEditorTheme, CanvasEditorIcons, CanvasFontConfig, CanvasToolbarConfig
- [x] SlotOverrides
- [x] CanvasEditorLocalizations
- [ ] Example app providers (Template, Audio, Sticker)
- [ ] Example app screens (TemplatePicker, BrandProfile, ExportResult)
- [ ] Tests (unit + widget + golden + integration)
- [ ] pub.dev publish prep

## Autoresearch Loop State
Current iteration: Implementing tests and review pass
Next: Example app providers and screens
