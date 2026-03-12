import '../models/layer/layer.dart';

class SelectionState {
  final String? primaryId;           // last tapped layer
  final Set<String> selectedIds;     // for multi-select

  const SelectionState({
    this.primaryId,
    this.selectedIds = const {},
  });

  bool get hasSelection => primaryId != null;
  bool get isMultiSelect => selectedIds.length > 1;
  bool isSelected(String id) => selectedIds.contains(id);

  SelectionState selectSingle(String id) => SelectionState(
    primaryId: id,
    selectedIds: {id},
  );

  SelectionState addToSelection(String id) => SelectionState(
    primaryId: id,
    selectedIds: {...selectedIds, id},
  );

  SelectionState removeFromSelection(String id) {
    final updated = Set<String>.from(selectedIds)..remove(id);
    return SelectionState(
      primaryId: updated.isEmpty ? null : (primaryId == id ? updated.first : primaryId),
      selectedIds: updated,
    );
  }

  SelectionState clear() => const SelectionState();

  /// Resolve the primary Layer object from a list
  Layer? resolveLayer(List<Layer> layers) =>
      primaryId == null ? null : layers.cast<Layer?>().firstWhere(
            (l) => l?.id == primaryId,
        orElse: () => null,
      );

  /// Resolve all selected Layer objects
  List<Layer> resolveAll(List<Layer> layers) =>
      layers.where((l) => selectedIds.contains(l.id)).toList();
}
