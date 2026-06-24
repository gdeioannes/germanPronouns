import 'package:flutter/services.dart' show rootBundle;

import '../db/content_repository.dart';
import 'course_content_provider.dart';

/// [ContentSource] backed by the bundled `assets/content/` collection files.
/// This is the local stand-in for the future remote/download source: swapping
/// it for one that fetches a course over the network (and caches it) is the only
/// change needed to make `populated()` a real download-on-open.
class AssetContentSource implements ContentSource {
  const AssetContentSource();

  static const String _root = 'assets/content';

  @override
  Future<String> catalogJson() => rootBundle.loadString('$_root/catalog.json');

  @override
  Future<String> appConfigJson() => rootBundle.loadString('$_root/app.json');

  @override
  Future<String> courseJson(String courseId) =>
      rootBundle.loadString('$_root/courses/$courseId.json');

  @override
  Future<String> sharedNounsJson(String langCode) =>
      rootBundle.loadString('$_root/shared/nouns/$langCode.json');
}

/// [CourseBundleStore] backed by the shared content database, so teacher edits
/// persist on the device and override the shipped asset bundles. Read failures
/// (e.g. the DB can't open) degrade to null, falling back to the asset.
class RepositoryBundleStore implements CourseBundleStore {
  const RepositoryBundleStore();

  @override
  Future<Map<String, dynamic>?> read(String courseId) async {
    try {
      final raw = await (await contentRepository()).readBundle(courseId);
      return raw == null ? null : Map<String, dynamic>.from(raw);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> write(String courseId, Map<String, dynamic> json) async =>
      (await contentRepository()).writeBundle(
        courseId,
        Map<String, Object?>.from(json),
      );

  @override
  Future<void> remove(String courseId) async =>
      (await contentRepository()).removeBundle(courseId);
}

/// The app-wide content provider: reads the bundled assets, serves teacher
/// edits from the database when present, and caches per course. Shared.
final CachingCourseProvider courseContentProvider = CachingCourseProvider(
  const AssetContentSource(),
  store: const RepositoryBundleStore(),
);
