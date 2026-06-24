import 'package:german_pronouns_articles/data/content/course_content_provider.dart';

/// In-memory [ContentSource] for provider/editor tests — serves fixed JSON for
/// the catalog, app config, and (one) course bundle.
class InMemoryContentSource implements ContentSource {
  InMemoryContentSource(
    this.courseStr, {
    this.catalogStr = '{"version":"t","courses":[]}',
    this.appStr = '{"version":"t"}',
    this.sharedNounsStr = '{"nouns":[]}',
  });

  final String courseStr;
  final String catalogStr;
  final String appStr;
  final String sharedNounsStr;

  @override
  Future<String> catalogJson() async => catalogStr;
  @override
  Future<String> appConfigJson() async => appStr;
  @override
  Future<String> courseJson(String courseId) async => courseStr;
  @override
  Future<String> sharedNounsJson(String langCode) async => sharedNounsStr;
}

/// In-memory [CourseBundleStore] for editor tests — captures teacher edits.
class InMemoryBundleStore implements CourseBundleStore {
  final Map<String, Map<String, dynamic>> data = {};

  @override
  Future<Map<String, dynamic>?> read(String id) async => data[id];
  @override
  Future<void> write(String id, Map<String, dynamic> json) async =>
      data[id] = json;
  @override
  Future<void> remove(String id) async => data.remove(id);
}
