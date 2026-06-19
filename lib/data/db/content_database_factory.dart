// Cross-platform opener for the local content database. Picks the IndexedDB
// factory on web and the file factory on desktop/mobile via conditional import.
export 'content_database_factory_io.dart'
    if (dart.library.html) 'content_database_factory_web.dart';
