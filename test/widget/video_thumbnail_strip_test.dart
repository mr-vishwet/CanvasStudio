import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:canvas_studio/canvas_studio.dart';

void main() {
  group('VideoThumbnailStrip', () {
    testWidgets('renders thumbnail count correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: VideoThumbnailStrip(
            thumbnailUrls: ['url1', 'url2', 'url3'],
            selectedIndex: 1,
            onThumbnailSelected: (index) {},
          ),
        ),
      );

      expect(find.byType(Image), findsNWidgets(3));
    });

    testWidgets('calls onThumbnailSelected when tapped', (tester) async {
      int? selectedIndex;
      await tester.pumpWidget(
        MaterialApp(
          home: VideoThumbnailStrip(
            thumbnailUrls: ['url1', 'url2'],
            selectedIndex: 0,
            onThumbnailSelected: (index) => selectedIndex = index,
          ),
        ),
      );

      await tester.tap(find.byType(Image).at(1));
      expect(selectedIndex, 1);
    });

    testWidgets('shows selection border on selected thumbnail', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: VideoThumbnailStrip(
            thumbnailUrls: ['url1', 'url2'],
            selectedIndex: 1,
            onThumbnailSelected: (index) {},
          ),
        ),
      );

      // Selected thumbnail should have a blue border
      expect(find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.decoration is BoxDecoration &&
            (widget.decoration as BoxDecoration).border != null,
      ), findsWidgets);
    });
  });
}
