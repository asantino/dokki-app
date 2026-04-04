import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/localization/language_provider.dart';
import '../../providers/catalog_providers.dart';
import '../widgets/bot_card.dart';

class CatalogScreen extends ConsumerWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Основной провайдер списка ботов
    final botsAsync = ref.watch(botsProvider);
    // Провайдер локализованных строк
    final s = ref.watch(stringsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          s.navShop,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: botsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
        error: (err, stack) {
          debugPrint('-----------------------------------------');
          debugPrint('❌ ОШИБКА ЗАГРУЗКИ КАТАЛОГА:');
          debugPrint('ОШИБКА: $err');
          debugPrint('СТЕКТРЕЙС: $stack');
          debugPrint('-----------------------------------------');

          return Center(
            child: Text(
              'Ошибка: $err',
              style: const TextStyle(
                color: AppColors.error,
                fontFamily: 'Inter',
              ),
            ),
          );
        },
        data: (bots) {
          // --- МОЩНЫЙ ДЕБАГ-ЛОГ ДЛЯ ПРОВЕРКИ КАРТИНОК ---
          debugPrint('-----------------------------------------');
          debugPrint('✅ ДАННЫЕ ПОЛУЧЕНЫ УСПЕШНО');
          debugPrint('✅ ЗАГРУЖЕНО БОТОВ: ${bots.length}');

          if (bots.isNotEmpty) {
            debugPrint('📦 ИМЕНА: ${bots.map((b) => b.name).toList()}');
            // Это самое важное: проверяем, что imageUrl у всех РАЗНЫЕ
            debugPrint(
                '🖼 URL КАРТИНОК: ${bots.map((b) => '${b.name}: ${b.imageUrl}').toList()}');
          } else {
            debugPrint(
                '⚠️ ПРЕДУПРЕЖДЕНИЕ: Список пуст. Проверь RLS или данные в БД.');
          }
          debugPrint('-----------------------------------------');

          if (bots.isEmpty) {
            return Center(
              child: Text(
                s.catEmpty,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontFamily: 'Inter',
                ),
              ),
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              // Адаптивное количество колонок (1 для моб, 2 для планшетов, 3 для десктопа)
              final int crossAxisCount = constraints.maxWidth > 1200
                  ? 3
                  : constraints.maxWidth > 800
                      ? 2
                      : 1;

              final double horizontalPadding =
                  constraints.maxWidth > 600 ? 24.0 : 16.0;

              return GridView.builder(
                padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding, vertical: 12),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  // Соотношение сторон: длиннее для списка, квадратнее для сетки
                  childAspectRatio: crossAxisCount == 1 ? 2.2 : 1.3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: bots.length,
                itemBuilder: (context, index) {
                  final bot = bots[index];
                  return BotCard(
                    bot: bot,
                    isGridMode: crossAxisCount > 1,
                    // Переход к деталям бота по ключу категории
                    onConnect: () => context.push(
                      '/bot-details/${bot.categoryKey}',
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
