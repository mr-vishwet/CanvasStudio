import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:canvas_studio/canvas_studio.dart';

void main() {
  group('LayerPanel', () {
    testWidgets('renders layer list', (tester) async {
      final layers = [
        TextLayer(
          id: 'l1',
          name: 'Title',
          position: const Offset(0, 0),
          size: const Size(100, 50),
          text: 'Hello',
        ),
        ImageLayer(
          id: 'l2',
          name: 'Image',
          position: const Offset(0, 0),
          size: const Size(100, 100),
          imageUrl: 'https://cdn.example.com/img.jpg',
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: LayerPanel(
            layers: layers,
            selectedId: 'l1',
            onLayerSelected: (id) {},
            onLayerReordered: (old, new) {},
          ),
        ),
      );

      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Image'), findsOneWidget);
    });

    testWidgets('calls onLayerSelected when tapped', (tester) async {
      String? selectedId;
      await tester.pumpWidget(
        MaterialApp(
          home: LayerPanel(
            layers: [
              TextLayer(
                id: 'l1',
                name: 'Title',
                position: const Offset(0, 0),
                size: const Size(100, 50),
                text: 'Hello',
              ),
            ],
            selectedId: null,
            onLayerSelected: (id) => selectedId = id,
            onLayerReordered: (old, new) {},
          ),
        ),
      );

      await tester.tap(find.text('Title'));
      expect(selectedId, 'l1');
    });
  });

  group('StickerPickerPanel', () {
    testWidgets('renders sticker grid', (tester) async {
      final stickers = [
        Sticker(
          id: 's1',
          name: 'Sticker 1',
          url: 'https://cdn.example.com/s1.png',
          categoryId: 'cat1',
        ),
        Sticker(
          id: 's2',
          name: 'Sticker 2',
          url: 'https://cdn.example.com/s2.png',
          categoryId: 'cat1',
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: StickerPickerPanel(
            stickers: stickers,
            onStickerSelected: (sticker) {},
          ),
        ),
      );

      expect(find.text('Sticker 1'), findsOneWidget);
      expect(find.text('Sticker 2'), findsOneWidget);
    });

    testWidgets('calls onStickerSelected when tapped', (tester) async {
      Sticker? selected;
      await tester.pumpWidget(
        MaterialApp(
          home: StickerPickerPanel(
            stickers: [
              Sticker(
                id: 's1',
                name: 'Sticker 1',
                url: 'https://cdn.example.com/s1.png',
                categoryId: 'cat1',
              ),
            ],
            onStickerSelected: (sticker) => selected = sticker,
          ),
        ),
      );

      await tester.tap(find.byType(GestureDetector).first);
      expect(selected?.id, 's1');
    });
  });
}
