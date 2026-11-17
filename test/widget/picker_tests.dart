import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:canvas_studio/canvas_studio.dart';

void main() {
  group('ColorPicker', () {
    testWidgets('renders color presets', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ColorPicker(
            color: Colors.red,
            onColorChanged: (color) {},
          ),
        ),
      );

      expect(find.text('Color Picker'), findsOneWidget);
      // Should render multiple color circles
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('calls onColorChanged when preset tapped', (tester) async {
      Color? selectedColor;
      await tester.pumpWidget(
        MaterialApp(
          home: ColorPicker(
            color: Colors.red,
            onColorChanged: (color) => selectedColor = color,
          ),
        ),
      );

      // Tap the blue preset (3rd row, 4th item approximately)
      // Find a container with blue color
      await tester.tap(find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.decoration is BoxDecoration &&
            (widget.decoration as BoxDecoration).color == Colors.blue,
      ));
      expect(selectedColor, Colors.blue);
    });
  });

  group('EffectPicker', () {
    testWidgets('renders effect sliders', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: EffectPicker(
            effect: EffectConfig(),
            onEffectChanged: (effect) {},
          ),
        ),
      );

      expect(find.text('Effects'), findsOneWidget);
      expect(find.byType(Slider), findsWidgets);
    });

    testWidgets('calls onEffectChanged when slider changes', (tester) async {
      EffectConfig? selected;
      await tester.pumpWidget(
        MaterialApp(
          home: EffectPicker(
            effect: const EffectConfig(brightness: 0.0),
            onEffectChanged: (effect) => selected = effect,
          ),
        ),
      );

      // Drag the brightness slider
      final slider = find.byType(Slider).first;
      await tester.drag(slider, const Offset(100, 0));
      expect(selected, isNotNull);
      expect(selected!.brightness, greaterThan(0.0));
    });
  });

  group('FontPicker', () {
    testWidgets('renders font dropdown', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: FontPicker(
            selectedFont: 'Roboto',
            onFontSelected: (font) {},
          ),
        ),
      );

      expect(find.byType(DropdownButton<String>), findsOneWidget);
    });

    testWidgets('calls onFontSelected when font changed', (tester) async {
      String? selectedFont;
      await tester.pumpWidget(
        MaterialApp(
          home: FontPicker(
            selectedFont: 'Roboto',
            onFontSelected: (font) => selectedFont = font,
          ),
        ),
      );

      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      // Open dropdown and select a font
      await tester.tap(find.text('Open Sans').last);
      expect(selectedFont, 'Open Sans');
    });
  });
}
