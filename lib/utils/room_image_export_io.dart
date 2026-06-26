/// Desktop / mobile / test implementation of the room image export: writes the
/// PNG to a file. The native clipboard can't hold a raw image here, so copying
/// is unsupported. See [room_image_export.dart] for the platform split.
library;

import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

/// IO platforms can't put an image on the clipboard, so the room hides Copy.
const bool canCopyRoomImage = false;

/// Writes [png] to a `my-room-*.png` file in the Downloads folder (falling back
/// to the app documents folder where Downloads isn't exposed) and returns its
/// path so the caller can tell the learner where it landed.
Future<(bool ok, String message)> saveRoomImage(Uint8List png) async {
  try {
    final dir =
        await getDownloadsDirectory() ?? await getApplicationDocumentsDirectory();
    final file = File(
      '${dir.path}${Platform.pathSeparator}'
      'my-room-${DateTime.now().millisecondsSinceEpoch}.png',
    );
    await file.writeAsBytes(png);
    return (true, 'Saved to ${file.path}');
  } catch (e) {
    return (false, "Couldn't save the image: $e");
  }
}

/// Unsupported on IO platforms — the room offers Save instead.
Future<(bool ok, String message)> copyRoomImage(Uint8List png) async {
  return (false, "Copying images isn't supported here — use Save instead.");
}
