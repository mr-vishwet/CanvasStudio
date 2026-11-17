import 'package:flutter/material.dart';
import 'package:test/test.dart';
import 'package:canvas_studio/canvas_studio.dart';

void main() {
  group('CanvasEditorTheme', () {
    test('default values are correct', () {
      const theme = CanvasEditorTheme();
      expect(theme.primaryColor, const Color(0xFF6200EE));
      expect(theme.secondaryColor, const Color(0xFF03DAC6));
      expect(theme.surfaceColor, const Color(0xFFFFFFFF));
      expect(theme.onSurfaceColor, const Color(0xFF000000));
      expect(theme.borderColor, const Color(0xFFE0E0E0));
      expect(theme.activeColor, const Color(0xFF6200EE));
      expect(theme.disabledColor, const Color(0xFFBDBDBD));
      expect(theme.toolbarHeight, 56.0);
      expect(theme.panelItemHeight, 48.0);
    });

    test('copyWith creates modified copy', () {
      const theme = CanvasEditorTheme();
      final updated = theme.copyWith(
        primaryColor: const Color(0xFFFF0000),
        toolbarHeight: 64.0,
      );
      expect(updated.primaryColor, const Color(0xFFFF0000));
      expect(updated.toolbarHeight, 64.0);
      // Unchanged fields should keep original values
      expect(updated.secondaryColor, theme.secondaryColor);
      expect(updated.surfaceColor, theme.surfaceColor);
    });

    test('copyWith with no args returns same values', () {
      const theme = CanvasEditorTheme();
      final updated = theme.copyWith();
      expect(updated.primaryColor, theme.primaryColor);
      expect(updated.borderColor, theme.borderColor);
      expect(updated.panelBorderRadius, theme.panelBorderRadius);
    });

    test('lerp interpolates between themes', () {
      const theme1 = CanvasEditorTheme(
        primaryColor: Color(0xFF6200EE),
        toolbarHeight: 56.0,
      );
      const theme2 = CanvasEditorTheme(
        primaryColor: Color(0xFFFF0000),
        toolbarHeight: 64.0,
      );
      final lerped = theme1.lerp(theme2, 0.5);
      expect(lerped.toolbarHeight, 60.0);
    });

    test('lerp with null other returns self', () {
      const theme = CanvasEditorTheme();
      final result = theme.lerp(null, 0.5);
      expect(result.primaryColor, theme.primaryColor);
    });
  });

  group('CanvasEditorIcons', () {
    test('default icons are set', () {
      const icons = CanvasEditorIcons();
      expect(icons.addLayer, Icons.add);
      expect(icons.deleteLayer, Icons.delete_outline);
      expect(icons.export, Icons.download);
      expect(icons.text, Icons.text_fields);
      expect(icons.image, Icons.image);
      expect(icons.video, Icons.videocam);
      expect(icons.audio, Icons.audiotrack);
    });

    test('getIcon returns correct icon for known names', () {
      const icons = CanvasEditorIcons();
      expect(icons.getIcon('add_layer'), Icons.add);
      expect(icons.getIcon('undo'), Icons.undo);
      expect(icons.getIcon('redo'), Icons.redo);
      expect(icons.getIcon('export'), Icons.download);
      expect(icons.getIcon('text'), Icons.text_fields);
      expect(icons.getIcon('image'), Icons.image);
      expect(icons.getIcon('sticker'), Icons.emoji_objects);
      expect(icons.getIcon('brand_fill'), Icons.auto_awesome);
    });

    test('getIcon returns default for unknown names', () {
      const icons = CanvasEditorIcons();
      expect(icons.getIcon('unknown'), icons.more);
    });

    test('custom icons can be set', () {
      const icons = CanvasEditorIcons(
        addLayer: Icons.add_circle,
        export: Icons.share,
      );
      expect(icons.addLayer, Icons.add_circle);
      expect(icons.export, Icons.share);
    });
  });

  group('CanvasToolbarConfig', () {
    test('default values are correct', () {
      const config = CanvasToolbarConfig();
      expect(config.mainItems, isEmpty);
      expect(config.showLabels, true);
      expect(config.itemSize, 40.0);
      expect(config.activeColor, null);
      expect(config.inactiveColor, null);
    });

    test('custom toolbar items work', () {
      const items = [
        CanvasToolbarItem(
          id: 'custom_tool',
          label: 'Custom',
          icon: Icons.widgets,
        ),
      ];
      const config = CanvasToolbarConfig(mainItems: items);
      expect(config.mainItems, hasLength(1));
      expect(config.mainItems.first.id, 'custom_tool');
    });

    test('itemById finds item by id', () {
      const items = [
        CanvasToolbarItem(id: 'tool_a', label: 'A', icon: Icons.a),
        CanvasToolbarItem(id: 'tool_b', label: 'B', icon: Icons.b),
      ];
      const config = CanvasToolbarConfig(mainItems: items);
      final found = config.itemById('tool_b', items);
      expect(found.id, 'tool_b');
      expect(found.label, 'B');
    });

    test('itemById throws StateError for missing id', () {
      const items = [
        CanvasToolbarItem(id: 'tool_a', label: 'A', icon: Icons.a),
      ];
      const config = CanvasToolbarConfig(mainItems: items);
      expect(() => config.itemById('missing', items), throwsStateError);
    });
  });

  group('SlotOverrides', () {
    test('default values are all null', () {
      const overrides = SlotOverrides();
      expect(overrides.layerCardBuilder, null);
      expect(overrides.textEditorBuilder, null);
      expect(overrides.exportResultBuilder, null);
      expect(overrides.featureLockedBuilder, null);
      expect(overrides.customSlotBuilder, null);
    });

    test('copyWith creates modified copy', () {
      const overrides = SlotOverrides();
      final updated = overrides.copyWith(
        layerCardBuilder: (layer, controller) => const SizedBox(),
      );
      expect(updated.layerCardBuilder, isNotNull);
      expect(updated.textEditorBuilder, null);
    });

    test('copyWith with no args returns same values', () {
      const overrides = SlotOverrides();
      final updated = overrides.copyWith();
      expect(updated.layerCardBuilder, overrides.layerCardBuilder);
    });
  });

  group('CanvasEditorLocalizations', () {
    test('default localizations have all strings', () {
      const loc = CanvasEditorLocalizations();
      expect(loc.undo, 'Undo');
      expect(loc.redo, 'Redo');
      expect(loc.export, 'Export');
      expect(loc.saveDraft, 'Save draft');
      expect(loc.layers, 'Layers');
      expect(loc.addLayer, 'Add layer');
      expect(loc.deleteLayer, 'Delete layer');
      expect(loc.duplicateLayer, 'Duplicate');
      expect(loc.textTool, 'Text');
      expect(loc.imageTool, 'Image');
      expect(loc.shapeTool, 'Shape');
      expect(loc.stickerTool, 'Sticker');
      expect(loc.paintTool, 'Paint');
      expect(loc.audioTool, 'Audio');
      expect(loc.videoTool, 'Video');
      expect(loc.cropTool, 'Crop');
      expect(loc.filterTool, 'Filter');
      expect(loc.removeBg, 'Remove background');
      expect(loc.brandFill, 'Brand fill');
      expect(loc.settings, 'Settings');
      expect(loc.close, 'Close');
      expect(loc.check, 'OK');
      expect(loc.more, 'More');
      expect(loc.exporting, 'Exporting...');
      expect(loc.featureLocked, 'Feature locked');
      expect(loc.layerCount, 'layers');
      expect(loc.selectAudio, 'Select audio');
      expect(loc.selectSticker, 'Select sticker');
      expect(loc.selectFont, 'Select font');
      expect(loc.selectColor, 'Select color');
      expect(loc.enterText, 'Enter text');
      expect(loc.tapToEdit, 'Tap to edit');
      expect(loc.noLayers, 'No layers');
      expect(loc.templateLoaded, 'Template loaded');
      expect(loc.draftSaved, 'Draft saved');
    });
  });
}
