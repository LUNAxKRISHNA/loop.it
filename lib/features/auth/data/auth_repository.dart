import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/auth_notifier.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

class AuthRepository {
  Future<UserModel> getCurrentUser() async {
    // Mock user
    return UserModel(
      id: 'mock-user-id-1234',
      name: 'Krishna',
      email: 'krishna@loopit.test',
      phone: '+1234567890',
      createdAt: DateTime.now(),
    );
  }

  Future<void> signIn(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
