import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/models/user_model.dart';
import '../../../core/providers/supabase_providers.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(supabaseClientProvider));
});

class AuthRepository {
  final SupabaseClient _client;

  AuthRepository(this._client);

  /// Signs in with email and password via Supabase Auth.
  Future<void> signIn(String email, String password) async {
    await _client.auth.signInWithPassword(email: email, password: password);
  }

  /// Signs in with Google restricted to @cvv.ac.in accounts.
  Future<void> signInWithGoogle() async {
    final webClientId = dotenv.env['GOOGLE_WEB_CLIENT_ID'];

    final GoogleSignIn googleSignIn = GoogleSignIn(
      serverClientId: webClientId,
      hostedDomain: 'cvv.ac.in',
    );

    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      // User cancelled sign in
      return;
    }

    final email = googleUser.email.trim().toLowerCase();
    if (!email.endsWith('@cvv.ac.in')) {
      await googleSignIn.signOut();
      throw Exception(
        'Access Restricted: Only @cvv.ac.in accounts are permitted to sign in.',
      );
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final idToken = googleAuth.idToken;
    final accessToken = googleAuth.accessToken;

    if (idToken == null) {
      throw Exception('Could not retrieve Google ID Token for authentication.');
    }

    await _client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );

    final currentUser = _client.auth.currentUser;
    if (currentUser?.email != null &&
        !currentUser!.email!.trim().toLowerCase().endsWith('@cvv.ac.in')) {
      await _client.auth.signOut();
      await googleSignIn.signOut();
      throw Exception(
        'Access Restricted: Only @cvv.ac.in accounts are permitted to sign in.',
      );
    }
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }
    } catch (_) {}
    await _client.auth.signOut();
  }

  /// Fetches the current user's profile from public.users using the auth uid.
  Future<UserModel?> getCurrentUser() async {
    final authUser = _client.auth.currentUser;
    if (authUser == null) return null;

    final response = await _client
        .from('users')
        .select()
        .eq('id', authUser.id)
        .maybeSingle();

    if (response != null) {
      return UserModel.fromJson(response);
    }

    // Handle initial login: provision/upsert missing profile in public.users
    final newUserMap = {
      'id': authUser.id,
      'email': authUser.email,
      'name': authUser.userMetadata?['full_name'] as String? ??
          authUser.userMetadata?['name'] as String?,
      'created_at': DateTime.now().toIso8601String(),
    };

    try {
      final upsertedResponse = await _client
          .from('users')
          .upsert(newUserMap)
          .select()
          .maybeSingle();

      if (upsertedResponse != null) {
        return UserModel.fromJson(upsertedResponse);
      }
    } catch (_) {
      // Fall back if database trigger/policy handles insertion asynchronously
    }

    return UserModel(
      id: authUser.id,
      email: authUser.email,
      name: authUser.userMetadata?['full_name'] as String? ??
          authUser.userMetadata?['name'] as String?,
      createdAt: DateTime.now(),
    );
  }
}
