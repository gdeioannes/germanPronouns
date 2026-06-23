import 'package:flutter_test/flutter_test.dart';
import 'package:german_pronouns_articles/data/content/asset_course_provider.dart';
import 'package:german_pronouns_articles/data/content/course_content_provider.dart';

/// Stage 4 gate: the runtime asset-backed read path works — the catalog and
/// every per-course bundle load through the provider from the real
/// `assets/content/` files and resolve their quizzes.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('asset provider loads the catalog and every course bundle', () async {
    final provider = CachingCourseProvider(const AssetContentSource());

    final catalog = await provider.catalog();
    expect(catalog.courses, hasLength(5));

    for (final card in catalog.courses) {
      final populated = await provider.populated(card.id);
      expect(populated.course.id, card.id);
      expect(populated.quizzes, isNotEmpty, reason: '${card.id} bundle quizzes');
    }
  });
}
