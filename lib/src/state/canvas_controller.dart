import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import '../models/canvas_document.dart';
import '../models/layer/layers.dart';
import '../models/audio_config.dart';
import '../models/brand_profile.dart';
import '../models/export/export_config.dart';
import '../models/export/video_trim_config.dart';
import 'history_manager.dart';
import 'selection_state.dart';

class CanvasController extends ChangeNotifier {
  CanvasDocument _document;
  SelectionState _selection = const SelectionState();
  final HistoryManager _history = HistoryManager();

  // Text edit mode — layer currently being edited
  String? _editingLayerId;

  CanvasController(CanvasDocument document) : _document = document;

  // ── Convenience factories ──────────────────────────────────

  factory CanvasController.empty({
    required Size canvasSize,
    CanvasMediaType type = CanvasMediaType.image,
  }) =>
      CanvasController(
        CanvasDocument.empty(canvasSize: canvasSize, type: type),
      );

  factory CanvasController.fromJson(Map<String, dynamic> json) =>
      CanvasController(CanvasDocument.fromJson(json));

  // ── Getters ───────────────────────────────────────────────

  CanvasDocument get document => _document;
  SelectionState get selection => _selection;
  List<Layer> get layers => _document.layers;
  String? get selectedLayerId => _selection.primaryId;
  Layer? get selectedLayer => _selection.resolveLayer(_document.layers);
  bool get canUndo => _history.canUndo;
  bool get canRedo => _history.canRedo;
  bool get isTextEditing => _editingLayerId != null;
  String? get editingLayerId => _editingLayerId;

  // ── Internal mutation helper ──────────────────────────────

  /// Saves snapshot to history, applies mutation, notifies listeners
  void _mutate(CanvasDocument Function(CanvasDocument current) mutation) {
    _history.push(_document);
    _document = mutation(_document);
    notifyListeners();
  }

  // ── Layer CRUD ────────────────────────────────────────────

  void addLayer(Layer layer) {
    _mutate((doc) => doc.copyWith(
      layers: [...doc.layers, layer],
    ));
  }

  void removeLayer(String layerId) {
    _mutate((doc) => doc.copyWith(
      layers: doc.layers.where((l) => l.id != layerId).toList(),
    ));
    // Deselect if removed layer was selected
    if (_selection.isSelected(layerId)) {
      _selection = _selection.removeFromSelection(layerId);
      notifyListeners();
    }
  }

  void updateLayer(String layerId, Layer updated) {
    assert(updated.id == layerId, 'Layer id mismatch in updateLayer');
    _mutate((doc) => doc.copyWith(
      layers: doc.layers
          .map((l) => l.id == layerId ? updated : l)
          .toList(),
    ));
  }

  void reorderLayers(int oldIndex, int newIndex) {
    final layers = List<Layer>.from(_document.layers);
    final layer = layers.removeAt(oldIndex);
    // ReorderableListView fires newIndex AFTER removal
    final insertAt = newIndex > oldIndex ? newIndex - 1 : newIndex;
    layers.insert(insertAt, layer);
    _mutate((doc) => doc.copyWith(layers: layers));
  }

  void duplicateLayer(String layerId) {
    final original = _layerById(layerId);
    if (original == null) return;
    // New layer: offset slightly so it's visible on top
    final duplicated = original.copyWith(
      position: Offset(
        original.position.dx + 16,
        original.position.dy + 16,
      ),
    );
    // Override id — copyWith keeps the same id, we need a new one
    final withNewId = _cloneWithNewId(duplicated);
    _mutate((doc) => doc.copyWith(
      layers: [...doc.layers, withNewId],
    ));
    selectLayer(withNewId.id);
  }

  void toggleVisibility(String layerId) {
    final layer = _layerById(layerId);
    if (layer == null) return;
    updateLayer(layerId, layer.copyWith(isVisible: !layer.isVisible));
  }

  void toggleLock(String layerId) {
    final layer = _layerById(layerId);
    if (layer == null) return;
    updateLayer(layerId, layer.copyWith(isLocked: !layer.isLocked));
  }

  // ── Transform ─────────────────────────────────────────────

  void moveLayer(String layerId, Offset delta) {
    final layer = _layerById(layerId);
    if (layer == null || layer.isLocked) return;
    updateLayer(
      layerId,
      layer.copyWith(position: layer.position + delta),
    );
  }

  void setLayerPosition(String layerId, Offset position) {
    final layer = _layerById(layerId);
    if (layer == null || layer.isLocked) return;
    updateLayer(layerId, layer.copyWith(position: position));
  }

  void resizeLayer(String layerId, Size newSize) {
    final layer = _layerById(layerId);
    if (layer == null || layer.isLocked) return;
    // Enforce minimum size
    final clamped = Size(
      newSize.width.clamp(20.0, double.infinity),
      newSize.height.clamp(20.0, double.infinity),
    );
    updateLayer(layerId, layer.copyWith(size: clamped));
  }

  void rotateLayer(String layerId, double degrees) {
    final layer = _layerById(layerId);
    if (layer == null || layer.isLocked) return;
    updateLayer(layerId, layer.copyWith(rotation: degrees));
  }

  void setLayerOpacity(String layerId, double opacity) {
    final layer = _layerById(layerId);
    if (layer == null) return;
    updateLayer(
      layerId,
      layer.copyWith(opacity: opacity.clamp(0.0, 1.0)),
    );
  }

  // ── Selection ─────────────────────────────────────────────

  void selectLayer(String? id) {
    _selection = id == null ? const SelectionState() : _selection.selectSingle(id);
    notifyListeners();
  }

  void addToSelection(String id) {
    _selection = _selection.addToSelection(id);
    notifyListeners();
  }

  void clearSelection() {
    _selection = const SelectionState();
    notifyListeners();
  }

  // ── Text Edit Mode ─────────────────────────────────────────

  void enterTextEditMode(String layerId) {
    assert(
    _layerById(layerId) is TextLayer,
    'enterTextEditMode called on non-TextLayer',
    );
    _editingLayerId = layerId;
    selectLayer(layerId);
    notifyListeners();
  }

  void enterTextEditModeIfText(String layerId) {
    final layer = _layerById(layerId);
    if (layer is TextLayer) {
      enterTextEditMode(layerId);
    }
  }

  void exitTextEditMode() {
    _editingLayerId = null;
    notifyListeners();
  }

  void updateTextContent(String layerId, String newText) {
    final layer = _layerById(layerId);
    if (layer is! TextLayer) return;
    // Live text update — does NOT push to history on every keystroke
    // History is pushed only when edit mode exits (see commitTextEdit)
    _document = _document.copyWith(
      layers: _document.layers
          .map((l) => l.id == layerId ? layer.copyWith(text: newText) : l)
          .toList(),
    );
    notifyListeners();
  }

  /// Call when user dismisses keyboard / taps outside text field
  void commitTextEdit(String layerId) {
    // Push to history as a single undo step for the entire text edit session
    _history.push(_document);
    exitTextEditMode();
  }

  // ── History ───────────────────────────────────────────────

  void undo() {
    final previous = _history.undo(_document);
    if (previous == null) return;
    _document = previous;
    clearSelection();
    notifyListeners();
  }

  void redo() {
    final next = _history.redo(_document);
    if (next == null) return;
    _document = next;
    clearSelection();
    notifyListeners();
  }

  // ── Audio ─────────────────────────────────────────────────

  void setAudio(AudioConfig? audio) {
    _mutate((doc) => doc.copyWith(audio: audio));
  }

  // ── Video Trim ────────────────────────────────────────────

  void updateTrim(Duration start, Duration end) {
    final current = _document.videoTrim ??
        VideoTrimConfig(
          startTrim: Duration.zero,
          endTrim: end,
        );
    _mutate((doc) => doc.copyWith(
      videoTrim: current.copyWith(startTrim: start, endTrim: end),
    ));
  }

  void updateCrop(Offset minCrop, Offset maxCrop) {
    final current = _document.videoTrim;
    if (current == null) return;
    _mutate((doc) => doc.copyWith(
      videoTrim: current.copyWith(minCrop: minCrop, maxCrop: maxCrop),
    ));
  }

  void rotateVideo90() {
    final current = _document.videoTrim;
    if (current == null) return;
    final newRotation = (current.rotation + 90) % 360;
    _mutate((doc) => doc.copyWith(
      videoTrim: current.copyWith(rotation: newRotation),
    ));
  }

  // ── Brand Auto-Fill ───────────────────────────────────────

  void applyBrandProfile(BrandProfile profile) {
    _history.push(_document);

    final mapping = <String, String>{
      'business_name': profile.businessName,
      'phone': profile.phone,
      'address': profile.address,
      if (profile.tagline != null) 'tagline': profile.tagline!,
    };

    final updatedLayers = <Layer>[          // ← explicit List<Layer> type
      for (final layer in _document.layers)
        if (layer is TextLayer && mapping.containsKey(layer.placeholderName))
          layer.copyWith(text: mapping[layer.placeholderName])
        else if (layer is ImageLayer &&
            layer.placeholderName == 'logo' &&
            profile.logoUrl != null)
          layer.copyWith(imageUrl: profile.logoUrl)
        else
          layer,
    ];

    _document = _document.copyWith(layers: updatedLayers);
    notifyListeners();
  }

  // ── Template Load ─────────────────────────────────────────

  void loadDocument(CanvasDocument doc) {
    _history.clear();
    _selection = const SelectionState();
    _editingLayerId = null;
    _document = doc;
    notifyListeners();
  }

  // ── Export ────────────────────────────────────────────────

  /// Build export config — auto-resolves output type from document state
  ExportConfig buildExportConfig({
    required ExportFormat format,
    bool applyWatermark = false,
  }) =>
      ExportConfig.resolve(
        document: _document,
        format: format,
        applyWatermark: applyWatermark,
      );

  // ── Serialization ─────────────────────────────────────────

  Map<String, dynamic> toJson() => _document.toJson();

  // ── Z-order helpers ───────────────────────────────────────

  void bringToFront(String layerId) {
    final layers = List<Layer>.from(_document.layers);
    final index = layers.indexWhere((l) => l.id == layerId);
    if (index == -1 || index == layers.length - 1) return;
    final layer = layers.removeAt(index);
    layers.add(layer);
    _mutate((doc) => doc.copyWith(layers: layers));
  }

  void sendToBack(String layerId) {
    final layers = List<Layer>.from(_document.layers);
    final index = layers.indexWhere((l) => l.id == layerId);
    if (index <= 0) return;
    final layer = layers.removeAt(index);
    layers.insert(0, layer);
    _mutate((doc) => doc.copyWith(layers: layers));
  }

  void bringForward(String layerId) {
    final layers = List<Layer>.from(_document.layers);
    final index = layers.indexWhere((l) => l.id == layerId);
    if (index == -1 || index == layers.length - 1) return;
    final layer = layers.removeAt(index);
    layers.insert(index + 1, layer);
    _mutate((doc) => doc.copyWith(layers: layers));
  }

  void sendBackward(String layerId) {
    final layers = List<Layer>.from(_document.layers);
    final index = layers.indexWhere((l) => l.id == layerId);
    if (index <= 0) return;
    final layer = layers.removeAt(index);
    layers.insert(index - 1, layer);
    _mutate((doc) => doc.copyWith(layers: layers));
  }

  // ── Hit testing (used by GestureHandler) ─────────────────

  /// Returns topmost visible layer at given canvas-space point
  Layer? hitTest(Offset point) {
    // Iterate reverse (topmost first)
    for (final layer in _document.layers.reversed) {
      if (!layer.isVisible) continue;
      if (_layerBounds(layer).contains(point)) return layer;
    }
    return null;
  }

  Rect _layerBounds(Layer layer) => Rect.fromLTWH(
    layer.position.dx,
    layer.position.dy,
    layer.size.width,
    layer.size.height,
  );

  // ── Private helpers ───────────────────────────────────────

  Layer? _layerById(String id) {
    try {
      return _document.layers.firstWhere((l) => l.id == id);
    } catch (_) {
      return null;
    }
  }

  Layer _cloneWithNewId(Layer layer) {
    final json = layer.toJson();
    json['id'] = 'layer_${DateTime.now().microsecondsSinceEpoch}';
    json['name'] = '${layer.name} copy';
    return layerFromJson(json);   // ← was Layer.fromJson(json)
  }

  @override
  void dispose() {
    _history.clear();
    super.dispose();
  }
}
