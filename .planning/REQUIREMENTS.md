# canvas_studio — GSD Requirements

Source: canvas_studio_context.md (canonical project context)
Source: canvas_studio_development_plan.txt (phase-wise plan)

## Core Requirements
1. **Canvas is pure UI + state** — No HTTP calls inside the library
2. **Host app injects all data** — templates, audio, stickers via abstract provider interfaces
3. **91% of features run fully on-device** — offline-capable
4. **Video rendering uses on-device FFmpeg** — no backend required for export
5. **Backend only for:** remote content delivery, cross-device sync, receipt validation

## Provider Interfaces (host app must implement)
- TemplateProvider: fetchTemplates(), fetchTemplateById()
- AudioProvider: fetchTracks(), fetchCategories(), fetchUserUploads(), uploadAudio(), canAccessTrack()
- StickerProvider: fetchCategories(), fetchStickers()

## Export Decision Tree
- image + no audio → PNG/JPG (ExportRenderer.renderToBytes)
- image + audio → MP4 slideshowVideo (FFmpeg: -loop 1 image + audio)
- image + audio + animation → MP4 animatedVideo (FFmpeg filter_complex)
- video → MP4 animatedVideo (FFmpeg full pipeline)

## Background Removal Strategy
- onDevice → image_background_remover (ONNX U2Net)
- backendApi → host app callback
- tiered (DEFAULT) → try onDevice first, fallback to backendApi

## Template JSON Schema v1.0
- schema_version, id, name, category, tags, ratio, canvas_size, type, video_duration_ms, thumbnail_url, preview_gif_url, source, default_audio_id, layers[]

## Quality Gates
- flutter analyze → zero issues
- 80%+ unit test coverage
- Golden tests for all layer types
- Integration test: template → brand → export
- flutter pub publish --dry-run → zero errors
