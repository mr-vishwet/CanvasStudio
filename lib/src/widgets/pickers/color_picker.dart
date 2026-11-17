import 'package:flutter/material.dart';

class ColorPicker extends StatelessWidget {
  final Color color;
  final ValueChanged<Color> onColorChanged;

  const ColorPicker({
    super.key,
    required this.color,
    required this.onColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Color Picker'),
        ColorPickerWidget(
          color: color,
          onChanged: onColorChanged,
        ),
      ],
    );
  }
}

class ColorPickerWidget extends StatelessWidget {
  final Color color;
  final ValueChanged<Color> onChanged;

  const ColorPickerWidget({super.key, required this.color, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        for (final c in _presetColors)
          GestureDetector(
            onTap: () => onChanged(c),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: c,
                shape: BoxShape.circle,
                border: Border.all(
                  color: c == color ? Colors.black : Colors.transparent,
                  width: 2,
                ),
              ),
            ),
          ),
      ],
    );
  }

  static const List<Color> _presetColors = [
    Colors.red, Colors.pink, Colors.purple, Colors.deepPurple,
    Colors.indigo, Colors.blue, Colors.lightBlue, Colors.cyan,
    Colors.teal, Colors.green, Colors.lightGreen, Colors.lime,
    Colors.yellow, Colors.amber, Colors.orange, Colors.deepOrange,
    Colors.brown, Colors.grey, Colors.blueGrey, Colors.black,
  ];
}
