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
    final botsAsync = ref.watch(botsProvider);
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
        error: (err, stack) => Center(
          child: Text(
            'Ошибка: $err',
            style: const TextStyle(
              color: AppColors.error,
              fontFamily: 'Inter',
            ),
          ),
        ),
        data: (bots) {
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

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: bots.length,
            itemBuilder: (context, index) {
              final bot = bots[index];

              return BotCard(
                bot: bot,
                // Используем bot.categoryKey для роута конфигурации
                onConnect: () => context.push(
                  '/bot-config/${bot.id}/${bot.name}/${bot.categoryKey}',
                ),
              );
            },
          );
        },
      ),
    );
  }
}
