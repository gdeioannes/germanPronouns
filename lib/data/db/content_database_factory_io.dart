import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';

/// Opens the local content database backed by a file in the app's documents
/// directory (desktop/mobile).
Future<Database> openContentDatabase() async {
  final dir = await getApplicationDocumentsDirectory();
  await dir.create(recursive: true);
  return databaseFactoryIo.openDatabase('${dir.path}/german_quiz_content.db');
}
