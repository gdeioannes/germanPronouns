import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Who is using the app. Learners get the quizzes; teachers also get the back
/// office for editing content.
enum UserRole { learner, teacher }

/// Holds the current sign-in state for the session, and remembers the last
/// chosen role across launches.
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

  static const String _roleKey = 'app_role';

  UserRole? _role;
  UserRole? _rememberedRole;
  bool _loaded = false;

  /// The role active in this session (null until signed in).
  UserRole? get role => _role;

  /// The last role the user chose, persisted across launches. Learners resume
  /// straight into the quizzes; a remembered teacher must still re-enter the
  /// passcode (so the login screen opens in teacher mode for them).
  UserRole? get rememberedRole => _rememberedRole;

  bool get isSignedIn => _role != null;

  /// Loads the remembered role. Learners are signed in automatically; teachers
  /// are only remembered (they re-enter the passcode each launch).
  Future<void> load() async {
    if (_loaded) return;
    final prefs = await SharedPreferences.getInstance();
    _rememberedRole = _roleFromName(prefs.getString(_roleKey));
    if (_rememberedRole == UserRole.learner) {
      _role = UserRole.learner;
    }
    _loaded = true;
    notifyListeners();
  }

  void signInAsLearner() {
    _role = UserRole.learner;
    _remember(UserRole.learner);
    notifyListeners();
  }

  /// Signs in as a teacher if [passcode] matches; returns whether it did.
  bool signInAsTeacher(String passcode) {
    if (passcode.trim() != teacherPasscode) return false;
    _role = UserRole.teacher;
    _remember(UserRole.teacher);
    notifyListeners();
    return true;
  }

  /// Signs out and forgets the remembered role, so the next launch shows the
  /// login screen.
  Future<void> signOut() async {
    _role = null;
    _rememberedRole = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_roleKey);
    notifyListeners();
  }

  Future<void> _remember(UserRole role) async {
    _rememberedRole = role;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_roleKey, role.name);
  }

  UserRole? _roleFromName(String? name) {
    for (final role in UserRole.values) {
      if (role.name == name) return role;
    }
    return null;
  }
}
