/// Web implementation of the room image export: downloads the PNG and can write
/// it to the browser clipboard. See [room_image_export.dart] for the split.
library;

import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

/// Modern browsers can put an image on the clipboard, so the room shows Copy.
const bool canCopyRoomImage = true;

web.Blob _pngBlob(Uint8List png) => web.Blob(
      <JSAny>[png.toJS].toJS,
      web.BlobPropertyBag(type: 'image/png'),
    );

/// Triggers a browser download of [png] via a temporary object URL.
Future<(bool ok, String message)> saveRoomImage(Uint8List png) async {
  final url = web.URL.createObjectURL(_pngBlob(png));
  web.HTMLAnchorElement()
    ..href = url
    ..download = 'my-room-${DateTime.now().millisecondsSinceEpoch}.png'
    ..click();
  web.URL.revokeObjectURL(url);
  return (true, 'Image downloaded.');
}

/// Writes [png] to the system clipboard as `image/png` so it can be pasted
/// elsewhere. Falls back to a "use Save" message if the browser blocks it
/// (e.g. clipboard permission denied, or an insecure context).
Future<(bool ok, String message)> copyRoomImage(Uint8List png) async {
  try {
    final item = web.ClipboardItem(
      <String, web.Blob>{'image/png': _pngBlob(png)}.jsify()! as JSObject,
    );
    await web.window.navigator.clipboard.write(<web.ClipboardItem>[item].toJS).toDart;
    return (true, 'Copied to clipboard — paste it anywhere!');
  } catch (_) {
    return (false, "Couldn't copy — try Save instead.");
  }
}
