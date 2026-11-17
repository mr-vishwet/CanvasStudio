import '../models/template_manifest.dart';

abstract class TemplateProvider {
  Future<List<TemplateManifest>> fetchTemplates({
    String? category,
    TemplateAspectRatio? ratio,
    int page = 1,
  });

  Future<TemplateManifest?> fetchTemplateById(String id);
}
