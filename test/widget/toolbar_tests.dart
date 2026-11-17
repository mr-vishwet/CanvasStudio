import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:canvas_studio/canvas_studio.dart';

void main() {
  group('AnimationToolbar', () {
    testWidgets('renders animation chips', (tester) async {
      String? selected;
      await tester.pumpWidget(
        MaterialApp(
          home: AnimationToolbar(
            onAnimationSelected: (anim) => selected = anim,
          ),
        ),
      );

      expect(find.text('Fade'), findsOneWidget);
      expect(find.text('Zoom'), findsOneWidget);
      expect(find.text('Bounce'), findsOneWidget);
      expect(find.byType(ChoiceChip), findsWidgets);
    });

    testWidgets('calls onAnimationSelected when chip tapped', (tester) async {
      String? selected;
      await tester.pumpWidget(
        MaterialApp(
          home: AnimationToolbar(
            onAnimationSelected: (anim) => selected = anim,
          ),
        ),
      );

      await tester.tap(find.text('Fade').first);
      expect(selected, 'Fade');
    });
  });

  group('ImageToolbar', () {
    testWidgets('renders image tool buttons', (tester) async {
      var replaceTapped = false;
      var cropTapped = false;
      var removeBgTapped = false;
      var effectsTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: ImageToolbar(
            onReplace: () => replaceTapped = true,
            onCrop: () => cropTapped = true,
            onRemoveBg: () => removeBgTapped = true,
            onEffects: () => effectsTapped = true,
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.replace));
      expect(replaceTapped, true);

      await tester.tap(find.byIcon(Icons.crop));
      expect(cropTapped, true);

      await tester.tap(find.byIcon(Icons.cut));
      expect(removeBgTapped, true);

      await tester.tap(find.byIcon(Icons.filter_alt));
      expect(effectsTapped, true);
    });
  });

  group('TextToolbar', () {
    testWidgets('renders text tool buttons', (tester) async {
      var editTapped = false;
      var fontTapped = false;
      var colorTapped = false;
      var alignTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: TextToolbar(
            onEdit: () => editTapped = true,
            onFontChange: () => fontTapped = true,
            onColorChange: () => colorTapped = true,
            onAlign: () => alignTapped = true,
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.edit));
      expect(editTapped, true);

      await tester.tap(find.byIcon(Icons.fonts));
      expect(fontTapped, true);

      await tester.tap(find.byIcon(Icons.color_lens));
      expect(colorTapped, true);

      await tester.tap(find.byIcon(Icons.format_align_left));
      expect(alignTapped, true);
    });
  });

  group('VideoToolbar', () {
    testWidgets('renders video tool buttons', (tester) async {
      var trimTapped = false;
      var rotateTapped = false;
      var coverTapped = false;
      var cropTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: VideoToolbar(
            onTrim: () => trimTapped = true,
            onRotate: () => rotateTapped = true,
            onCoverSelect: () => coverTapped = true,
            onCrop: () => cropTapped = true,
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.crop));
      expect(trimTapped, true);

      await tester.tap(find.byIcon(Icons.rotate_90_degrees_cw));
      expect(rotateTapped, true);

      await tester.tap(find.byIcon(Icons.face));
      expect(coverTapped, true);

      await tester.tap(find.byIcon(Icons.crop_rotate));
      expect(cropTapped, true);
    });
  });
}
