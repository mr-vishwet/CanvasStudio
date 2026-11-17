import 'package:flutter/material.dart';
import '../../models/layer/layers.dart';

class LayerPanel extends StatelessWidget {
  final List<Layer> layers;
  final String? selectedId;
  final ValueChanged<String> onLayerSelected;
  final ValueChanged<int> onLayerReordered;

  const LayerPanel({
    super.key,
    required this.layers,
    this.selectedId,
    required this.onLayerSelected,
    required this.onLayerReordered,
  });

  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      children: [
        for (final layer in layers)
          ListTile(
            key: ValueKey(layer.id),
            leading: const Icon(Icons.layers),
            title: Text(layer.name),
            subtitle: Text('${layer.type}'),
            selected: selectedId == layer.id,
            onTap: () => onLayerSelected(layer.id),
          ),
      ],
      onReorder: (int oldIndex, int newIndex) => onLayerReordered(newIndex),
    );
  }
}
