import 'package:flutter/material.dart';

class FontPicker extends StatelessWidget {
  final String selectedFont;
  final ValueChanged<String> onFontSelected;

  const FontPicker({
    super.key,
    required this.selectedFont,
    required this.onFontSelected,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedFont,
      items: _fontFamilies.map((family) =>
          DropdownMenuItem(value: family, child: Text(family))).toList(),
      onChanged: (value) { if (value != null) onFontSelected(value); },
    );
  }

  static const List<String> _fontFamilies = [
    'Roboto', 'Open Sans', 'Lato', 'Montserrat', 'Playfair Display',
    'Noto Sans Devanagari', 'Noto Sans Bengali', 'Noto Sans Tamil',
    'Noto Sans Telugu', 'Noto Sans Gujarati',
  ];
}
