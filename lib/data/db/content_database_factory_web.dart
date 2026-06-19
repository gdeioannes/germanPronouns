import 'package:sembast_web/sembast_web.dart';

/// Opens the local content database backed by IndexedDB (web).
Future<Database> openContentDatabase() async {
  return databaseFactoryWeb.openDatabase('german_quiz_content.db');
}
