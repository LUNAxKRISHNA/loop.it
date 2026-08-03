import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_repository.dart';

// Simple mock user model (no Freezed)
class UserModel {
  final String id;
  final String? name;
  final String? email;
  final String? phone;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    this.name,
    this.email,
    this.phone,
    required this.createdAt,
  });
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>((ref) {
  return AuthNotifier(ref.read(authRepositoryProvider));
});

class AuthNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AsyncLoading()) {
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    try {
      final user = await _repository.getCurrentUser();
      state = AsyncData(user);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();
    try {
      await _repository.signIn(email, password);
      final user = await _repository.getCurrentUser();
      state = AsyncData(user);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    try {
      await _repository.signOut();
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
