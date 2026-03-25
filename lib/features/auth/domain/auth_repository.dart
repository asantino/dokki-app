import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRepository {
  Future<void> signUp({required String email, required String password});
  Future<void> signIn({required String email, required String password});
  Future<void> signOut();
  Stream<User?> get authStateChanges;
  User? get currentUser;
}
