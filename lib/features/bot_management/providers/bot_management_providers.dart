import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/supabase/supabase_client.dart';
import '../domain/business.dart';
import '../domain/business_repository.dart';
import '../data/business_repository_impl.dart';
import '../data/telegram_repository.dart';
import '../data/appointments_repository.dart';

// 1. Провайдер Telegram API
final telegramRepositoryProvider = Provider<TelegramRepository>((ref) {
  return TelegramRepository();
});

// 2. Провайдер управления ботами
final businessRepositoryProvider = Provider<BusinessRepository>((ref) {
  return BusinessRepositoryImpl(ref.watch(supabaseClientProvider));
});

// 3. Провайдер списка подключенных ботов (НУЖЕН ДЛЯ КАТАЛОГА)
final connectedBotsProvider = FutureProvider<List<Business>>((ref) async {
  final repository = ref.watch(businessRepositoryProvider);
  return repository.getBusinesses();
});

// 4. Провайдер репозитория записей (TomatoAdmin)
final appointmentsRepositoryProvider =
    Provider.family<AppointmentsRepository, Business>((ref, business) {
  final client = SupabaseClient(
    business.botSupabaseUrl!,
    business.botSupabaseAnonKey!,
  );
  return AppointmentsRepository(client);
});

// 5. Провайдер списка записей
final appointmentsProvider =
    FutureProvider.family<List<Map<String, dynamic>>, Business>(
        (ref, business) async {
  return ref.watch(appointmentsRepositoryProvider(business)).getAppointments();
});
