import 'package:flutter/material.dart';

class TextToolbar extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onFontChange;
  final VoidCallback onColorChange;
  final VoidCallback onAlign;

  const TextToolbar({
    super.key,
    required this.onEdit,
    required this.onFontChange,
    required this.onColorChange,
    required this.onAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(icon: const Icon(Icons.edit), onPressed: onEdit, tooltip: 'Edit Text'),
        IconButton(icon: const Icon(Icons.text_format), onPressed: onFontChange, tooltip: 'Font'),
        IconButton(icon: const Icon(Icons.color_lens), onPressed: onColorChange, tooltip: 'Color'),
        IconButton(icon: const Icon(Icons.format_align_left), onPressed: onAlign, tooltip: 'Align'),
      ],
    );
  }
}
