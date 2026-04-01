import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Signed-in user for cloud sync (Microsoft Entra / MSAL). Null while not implemented or signed out.
@immutable
class CloudAuthUser {
  const CloudAuthUser({required this.id, this.displayLabel});

  final String id;
  final String? displayLabel;
}

/// Emits auth state for sync. Stays null until Entra + MSAL are wired (Phase 5).
final authSessionProvider = StreamProvider<CloudAuthUser?>((ref) {
  return Stream<CloudAuthUser?>.value(null);
});

/// Authenticated user id for sync (v1: one book per user). Null if not signed in.
final currentAuthUserIdProvider = Provider<String?>((ref) {
  return ref
      .watch(authSessionProvider)
      .maybeWhen(data: (u) => u?.id, orElse: () => null);
});
