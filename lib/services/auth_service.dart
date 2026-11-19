import 'package:giachero_gaia_yologo/models/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;

/* hide User -> used to hide the User class (the User class exists in the Supabase database); 
    in this file, the User class is mine alone. */

enum AuthStatus { success, invalidCredentials, error }

class AuthResult {
  final AuthStatus status;
  final User? user;

  const AuthResult(this.status, [this.user]);
}

class AuthService {
  static Future<AuthResult> signIn(String email, String password) async {
    final client = Supabase.instance.client;

    try {
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final authUser = response.user;
      if (authUser == null) {
        return const AuthResult(AuthStatus.error);
      }

      final profile = await client
          .from('profiles')
          .select()
          .eq('id', authUser.id)
          .maybeSingle();

      if (profile == null) {
        await client.auth.signOut();
        return const AuthResult(AuthStatus.error);
      }

      final user = User(
        id: authUser.id,
        email: email,
        username: profile['username'] as String,
        bio: profile['bio'] as String?,
      );

      return AuthResult(AuthStatus.success, user);
    } on AuthException catch (e) {
      if (e.code == 'invalid_credentials') {
        return const AuthResult(AuthStatus.invalidCredentials);
      }
      return const AuthResult(AuthStatus.error);
    } catch (_) {
      return const AuthResult(AuthStatus.error);
    }
  }

  static Future<void> signOut() async {
    await Supabase.instance.client.auth.signOut();
  }

  static Future<bool> updateProfile(
    String userId,
    String username,
    String? bio,
  ) async {
    try {
      await Supabase.instance.client
          .from('profiles')
          .update({'username': username, 'bio': bio})
          .eq('id', userId);
      return true;
    } catch (_) {
      return false;
    }
  }
}
