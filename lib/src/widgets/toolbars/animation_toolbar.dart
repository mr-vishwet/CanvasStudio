import 'package:flutter/material.dart';

class AnimationToolbar extends StatelessWidget {
  final ValueChanged<String> onAnimationSelected;

  const AnimationToolbar({
    super.key,
    required this.onAnimationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        for (final anim in _animations)
          ChoiceChip(
            label: Text(anim),
            selected: false,
            onSelected: (_) => onAnimationSelected(anim),
          ),
      ],
    );
  }

  static const List<String> _animations = [
    'Fade', 'Slide Left', 'Slide Right', 'Slide Up', 'Slide Down',
    'Zoom', 'Bounce', 'Rotate',
  ];
}
