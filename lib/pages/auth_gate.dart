import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../app_router.dart';
import '../models/app_session.dart';

/// Signs out and returns to the login screen.
///
/// The auth gate itself now lives in the router (see [appRouter]); signing out
/// notifies [AppSession], which the router listens to and redirects to `/login`
/// automatically. The explicit `go('/login')` makes the transition immediate
/// (and harmless if the redirect already fired).
Future<void> signOutToLogin(BuildContext context) async {
  await AppSession.instance.signOut();
  if (context.mounted) context.go('/login');
}
