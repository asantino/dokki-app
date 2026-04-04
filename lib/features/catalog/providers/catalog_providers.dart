import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/supabase/supabase_client.dart';
import '../domain/bot.dart';

/// Провайдер для получения всех ботов из базы данных (базовый поток данных)
final allBotsProvider = FutureProvider<List<Bot>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);

  try {
    // Запрашиваем всё. Если RLS настроен верно, придут все доступные строки.
    final response = await supabase
        .from('bot_catalog')
        .select('*')
        .order('price_monthly', ascending: true);

    final List data = response as List;

    // --- ГЛУБОКАЯ ДИАГНОСТИКА БАЗЫ ---
    debugPrint('🚀 [SUPABASE FETCH] Получено строк: ${data.length}');
    for (var i = 0; i < data.length; i++) {
      final item = data[i];
      debugPrint(
          '🤖 Бот #$i: ${item['name']} | Tier: ${item['tier']} | Category: ${item['category']} | URL: ${item['image_url']}');
    }

    return data.map((json) => Bot.fromJson(json)).toList();
  } catch (e, stack) {
    debugPrint('❌ ОШИБКА SUPABASE: $e');
    debugPrint(stack.toString());
    rethrow;
  }
});

/// Провайдер для отображения в магазине (без жестких фильтров)
final botsProvider = FutureProvider<List<Bot>>((ref) async {
  final allBots = await ref.watch(allBotsProvider.future);

  // ВРЕМЕННО: Убираем фильтр .where((bot) => bot.tier == 'basic')
  // чтобы увидеть ВСЕХ ботов, независимо от того, что прописано в колонке tier.
  final displayBots = List<Bot>.from(allBots);

  debugPrint(
      '📦 [DISPLAY LOGIC] Отображаем на экране: ${displayBots.length} ботов');

  // Сортировка по категориям (admin -> sales -> support)
  final categoryOrder = {'admin': 1, 'sales': 2, 'support': 3};

  displayBots.sort((a, b) {
    final priorityA = categoryOrder[a.categoryKey] ?? 999;
    final priorityB = categoryOrder[b.categoryKey] ?? 999;
    return priorityA.compareTo(priorityB);
  });

  return displayBots;
});

/// Провайдер конкретного бота по его ID
final botByIdProvider = FutureProvider.family<Bot?, String>((ref, id) async {
  final bots = await ref.watch(allBotsProvider.future);
  try {
    return bots.firstWhere((bot) => bot.id == id);
  } catch (_) {
    return null;
  }
});

/// Провайдер всех ботов одной категории
final botsByCategoryProvider =
    FutureProvider.family<List<Bot>, String>((ref, category) async {
  final bots = await ref.watch(allBotsProvider.future);
  return bots.where((bot) => bot.categoryKey == category).toList();
});
