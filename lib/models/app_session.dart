import 'package:flutter/foundation.dart';

/// Who is using the app. Learners get the quizzes; teachers also get the back
/// office for editing content.
enum UserRole { learner, teacher }

/// Holds the current sign-in state for the session.
///
/// This is a purely client-side gate: on static hosting (GitHub Pages) there
/// is no server, so the teacher passcode only hides the back office in the UI —
/// it is NOT real security. Anyone with the code or device can get in. Treat it
/// as a "staff door", not a vault.
class AppSession extends ChangeNotifier {
  AppSession._();

  static final AppSession instance = AppSession._();

  /// Local passcode that unlocks teacher mode. Change this before publishing.
  /// (Still client-side only — see the class note.)
  static const String teacherPasscode = 'teacher';

  UserRole? _role;
  UserRole? get role => _role;
  bool get isSignedIn => _role != null;

  void signInAsLearner() {
    _role = UserRole.learner;
    notifyListeners();
  }

  /// Signs in as a teacher if [passcode] matches; returns whether it did.
  bool signInAsTeacher(String passcode) {
    if (passcode.trim() != teacherPasscode) return false;
    _role = UserRole.teacher;
    notifyListeners();
    return true;
  }

  void signOut() {
    _role = null;
    notifyListeners();
  }
}
