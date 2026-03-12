import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/painting.dart';
import 'package:canvas_studio/canvas_studio.dart';

void main() {
  late CanvasController controller;

  setUp(() {
    controller = CanvasController.empty(canvasSize: const Size(1080, 1080));
  });

  tearDown(() => controller.dispose());

  TextLayer _makeTextLayer(String id) => TextLayer(
    id: id,
    name: 'Test Text',
    position: const Offset(100, 100),
    size: const Size(400, 60),
    text: 'Hello',
    fontFamily: 'Roboto',
    fontSize: 24,
  );

  group('Layer CRUD', () {
    test('addLayer increases layer count', () {
      controller.addLayer(_makeTextLayer('l1'));
      expect(controller.layers.length, 1);
    });

    test('removeLayer decreases layer count', () {
      controller.addLayer(_makeTextLayer('l1'));
      controller.removeLayer('l1');
      expect(controller.layers.length, 0);
    });

    test('updateLayer replaces layer in place', () {
      controller.addLayer(_makeTextLayer('l1'));
      final updated = _makeTextLayer('l1').copyWith(text: 'Updated');
      controller.updateLayer('l1', updated);
      final layer = controller.layers.first as TextLayer;
      expect(layer.text, 'Updated');
    });

    test('reorderLayers changes z-index', () {
      controller.addLayer(_makeTextLayer('l1'));
      controller.addLayer(_makeTextLayer('l2'));
      controller.reorderLayers(0, 2);
      expect(controller.layers.last.id, 'l1');
    });

    test('duplicateLayer adds a copy with new id', () {
      controller.addLayer(_makeTextLayer('l1'));
      controller.duplicateLayer('l1');
      expect(controller.layers.length, 2);
      expect(controller.layers[1].id, isNot('l1'));
    });

    test('toggleVisibility flips isVisible', () {
      controller.addLayer(_makeTextLayer('l1'));
      controller.toggleVisibility('l1');
      expect(controller.layers.first.isVisible, false);
    });
  });

  group('Selection', () {
    test('selectLayer sets selectedLayerId', () {
      controller.addLayer(_makeTextLayer('l1'));
      controller.selectLayer('l1');
      expect(controller.selectedLayerId, 'l1');
    });

    test('clearSelection resets selection', () {
      controller.addLayer(_makeTextLayer('l1'));
      controller.selectLayer('l1');
      controller.clearSelection();
      expect(controller.selectedLayerId, null);
    });
  });

  group('Undo / Redo', () {
    test('undo reverses addLayer', () {
      controller.addLayer(_makeTextLayer('l1'));
      controller.undo();
      expect(controller.layers.length, 0);
    });

    test('redo reapplies addLayer', () {
      controller.addLayer(_makeTextLayer('l1'));
      controller.undo();
      controller.redo();
      expect(controller.layers.length, 1);
    });

    test('10 step undo works correctly', () {
      for (int i = 0; i < 10; i++) {
        controller.addLayer(_makeTextLayer('l$i'));
      }
      for (int i = 0; i < 10; i++) {
        controller.undo();
      }
      expect(controller.layers.length, 0);
    });

    test('canUndo is false on fresh controller', () {
      expect(controller.canUndo, false);
    });

    test('canRedo is false on fresh controller', () {
      expect(controller.canRedo, false);
    });
  });

  group('Transform', () {
    test('moveLayer updates position', () {
      controller.addLayer(_makeTextLayer('l1'));
      controller.moveLayer('l1', const Offset(50, 50));
      expect(controller.layers.first.position, const Offset(150, 150));
    });

    test('locked layer ignores moveLayer', () {
      controller.addLayer(_makeTextLayer('l1'));
      controller.toggleLock('l1');
      controller.moveLayer('l1', const Offset(50, 50));
      expect(controller.layers.first.position, const Offset(100, 100));
    });

    test('rotateLayer sets rotation', () {
      controller.addLayer(_makeTextLayer('l1'));
      controller.rotateLayer('l1', 45.0);
      expect(controller.layers.first.rotation, 45.0);
    });
  });

  group('Brand auto-fill', () {
    test('applyBrandProfile replaces placeholder text', () {
      final layer = _makeTextLayer('l1').copyWith(
        placeholderName: 'business_name',
        text: 'Your Business Name',
      );
      controller.addLayer(layer);
      controller.applyBrandProfile(const BrandProfile(
        businessName: 'Sharma Electronics',
        phone: '+91 98765 43210',
        address: 'Mumbai',
      ));
      final updated = controller.layers.first as TextLayer;
      expect(updated.text, 'Sharma Electronics');
    });

    test('applyBrandProfile is a single undo step', () {
      final layer = _makeTextLayer('l1').copyWith(
        placeholderName: 'business_name',
      );
      controller.addLayer(layer);
      controller.applyBrandProfile(const BrandProfile(
        businessName: 'Test Co',
        phone: '1234567890',
        address: 'Delhi',
      ));
      controller.undo();
      final restored = controller.layers.first as TextLayer;
      expect(restored.text, 'Hello');
    });
  });

  group('Z-order', () {
    test('bringToFront moves layer to top', () {
      controller.addLayer(_makeTextLayer('l1'));
      controller.addLayer(_makeTextLayer('l2'));
      controller.bringToFront('l1');
      expect(controller.layers.last.id, 'l1');
    });

    test('sendToBack moves layer to bottom', () {
      controller.addLayer(_makeTextLayer('l1'));
      controller.addLayer(_makeTextLayer('l2'));
      controller.sendToBack('l2');
      expect(controller.layers.first.id, 'l2');
    });
  });

  group('Hit test', () {
    test('hitTest returns topmost layer at point', () {
      controller.addLayer(_makeTextLayer('l1'));
      final hit = controller.hitTest(const Offset(150, 120));
      expect(hit?.id, 'l1');
    });

    test('hitTest returns null outside all layers', () {
      controller.addLayer(_makeTextLayer('l1'));
      final hit = controller.hitTest(const Offset(900, 900));
      expect(hit, null);
    });

    test('hitTest skips invisible layers', () {
      controller.addLayer(_makeTextLayer('l1'));
      controller.toggleVisibility('l1');
      final hit = controller.hitTest(const Offset(150, 120));
      expect(hit, null);
    });
  });
}
