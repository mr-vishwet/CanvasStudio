import 'package:test/test.dart';
import 'package:canvas_studio/canvas_studio.dart';

void main() {
  group('BrandAutoFill', () {
    test('replaces placeholder text layers with brand values', () {
      final doc = CanvasDocument.empty(
        canvasSize: const Size(1080, 1080),
        layers: [
          TextLayer(
            id: 'l1',
            name: 'Business Name',
            position: const Offset(100, 100),
            size: const Size(400, 60),
            text: 'Your Business Name',
            placeholderName: 'business_name',
          ),
          TextLayer(
            id: 'l2',
            name: 'Phone',
            position: const Offset(100, 180),
            size: const Size(300, 40),
            text: '+91 00000 00000',
            placeholderName: 'phone',
          ),
          TextLayer(
            id: 'l3',
            name: 'Address',
            position: const Offset(100, 240),
            size: const Size(500, 40),
            text: 'Your Address',
            placeholderName: 'address',
          ),
        ],
      );

      final result = BrandAutoFill.apply(doc, const BrandProfile(
        businessName: 'Sharma Electronics',
        phone: '+91 98765 43210',
        address: 'Mumbai, India',
      ));

      expect(result.layers.length, 3);
      final l1 = result.layers[0] as TextLayer;
      final l2 = result.layers[1] as TextLayer;
      final l3 = result.layers[2] as TextLayer;
      expect(l1.text, 'Sharma Electronics');
      expect(l2.text, '+91 98765 43210');
      expect(l3.text, 'Mumbai, India');
    });

    test('replaces logo image layer with brand logo URL', () {
      final doc = CanvasDocument.empty(
        canvasSize: const Size(1080, 1080),
        layers: [
          ImageLayer(
            id: 'l1',
            name: 'Logo',
            position: const Offset(50, 50),
            size: const Size(100, 100),
            imageUrl: '',
            placeholderName: 'logo',
          ),
        ],
      );

      final result = BrandAutoFill.apply(doc, const BrandProfile(
        businessName: 'Test Co',
        phone: '123',
        address: 'Delhi',
        logoUrl: 'https://cdn.example.com/logo.png',
      ));

      final logoLayer = result.layers[0] as ImageLayer;
      expect(logoLayer.imageUrl, 'https://cdn.example.com/logo.png');
    });

    test('does not crash when tagline is null', () {
      final doc = CanvasDocument.empty(
        canvasSize: const Size(1080, 1080),
        layers: [
          TextLayer(
            id: 'l1',
            name: 'Tagline',
            position: const Offset(100, 100),
            size: const Size(400, 60),
            text: 'Your Tagline',
            placeholderName: 'tagline',
          ),
        ],
      );

      final result = BrandAutoFill.apply(doc, const BrandProfile(
        businessName: 'Test Co',
        phone: '123',
        address: 'Delhi',
      ));

      // tagline is null in profile, so placeholder should not be replaced
      final layer = result.layers[0] as TextLayer;
      expect(layer.text, 'Your Tagline');
    });

    test('replaces tagline when provided', () {
      final doc = CanvasDocument.empty(
        canvasSize: const Size(1080, 1080),
        layers: [
          TextLayer(
            id: 'l1',
            name: 'Tagline',
            position: const Offset(100, 100),
            size: const Size(400, 60),
            text: 'Your Tagline',
            placeholderName: 'tagline',
          ),
        ],
      );

      final result = BrandAutoFill.apply(doc, const BrandProfile(
        businessName: 'Test Co',
        phone: '123',
        address: 'Delhi',
        tagline: 'Quality Products Since 1990',
      ));

      final layer = result.layers[0] as TextLayer;
      expect(layer.text, 'Quality Products Since 1990');
    });

    test('leaves non-placeholder layers unchanged', () {
      final doc = CanvasDocument.empty(
        canvasSize: const Size(1080, 1080),
        layers: [
          TextLayer(
            id: 'l1',
            name: 'Regular Text',
            position: const Offset(100, 100),
            size: const Size(400, 60),
            text: 'Hello World',
          ),
        ],
      );

      final result = BrandAutoFill.apply(doc, const BrandProfile(
        businessName: 'Test Co',
        phone: '123',
        address: 'Delhi',
      ));

      final layer = result.layers[0] as TextLayer;
      expect(layer.text, 'Hello World');
    });

    test('returns new document (immutable)', () {
      final doc = CanvasDocument.empty(
        canvasSize: const Size(1080, 1080),
        layers: [
          TextLayer(
            id: 'l1',
            name: 'Business Name',
            position: const Offset(100, 100),
            size: const Size(400, 60),
            text: 'Your Business Name',
            placeholderName: 'business_name',
          ),
        ],
      );

      final result = BrandAutoFill.apply(doc, const BrandProfile(
        businessName: 'Test Co',
        phone: '123',
        address: 'Delhi',
      ));

      // Original document should be unchanged
      expect(doc.layers[0].text, 'Your Business Name');
      // Result should be different
      expect(result.layers[0].text, 'Test Co');
      expect(result.id, doc.id); // Same document id
    });

    test('handles empty document', () {
      final doc = CanvasDocument.empty(
        canvasSize: const Size(1080, 1080),
      );
      final result = BrandAutoFill.apply(doc, const BrandProfile(
        businessName: 'Test Co',
        phone: '123',
        address: 'Delhi',
      ));
      expect(result.layers, isEmpty);
    });
  });
}
