import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/supabase/supabase_client.dart';
import '../domain/auth_repository.dart';
import '../data/auth_repository_impl.dart';
import '../domain/secure_storage_repository.dart';
import '../data/secure_storage_repository_impl.dart';

// 1. Хранилище
final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

// 2. Репозиторий хранилища (Data -> Domain)
final secureStorageRepositoryProvider =
    Provider<SecureStorageRepository>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return SecureStorageRepositoryImpl(secureStorage);
});

// 3. Основной репозиторий авторизации
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  final secureStorage = ref.watch(secureStorageRepositoryProvider);
  return AuthRepositoryImpl(supabase, secureStorage);
});

// 4. Стрим для UI (User?)
final authStateProvider = StreamProvider<User?>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.authStateChanges;
});

// 5. Стрим для Роутера (AuthState)
final supabaseAuthStateProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(supabaseClientProvider).auth.onAuthStateChange;
});
