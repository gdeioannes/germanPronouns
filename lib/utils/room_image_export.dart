/// Saving and copying a captured PNG of the room, with a web and an IO
/// implementation picked at compile time:
///
///  * **web** (the default) downloads the PNG and can write it to the system
///    clipboard, so it can be pasted straight into chats, docs, etc.;
///  * **IO** (desktop / mobile / tests) writes a file to the Downloads folder.
///    The OS clipboard can't take a raw image here, so [copyRoomImage] reports
///    that and the room hides the Copy button (see [canCopyRoomImage]).
///
/// Both return `(ok, message)` — never throw — so the caller can show the
/// message in a SnackBar regardless of platform or outcome.
library;

export 'room_image_export_web.dart'
    if (dart.library.io) 'room_image_export_io.dart';
