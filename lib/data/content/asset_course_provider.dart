import 'package:flutter/services.dart' show rootBundle;

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
}

/// The app-wide content provider, reading from the bundled assets and caching
/// per course. Opened once and shared.
final CourseContentProvider courseContentProvider = CachingCourseProvider(
  const AssetContentSource(),
);
