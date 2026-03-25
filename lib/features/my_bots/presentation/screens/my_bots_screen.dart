import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/providers/auth_providers.dart';
import '../../../bot_management/providers/bot_management_providers.dart';
import '../widgets/business_card.dart';

class MyBotsScreen extends ConsumerWidget {
  const MyBotsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Сначала слушаем состояние авторизации
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Мои боты',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: authState.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
        error: (err, stack) => Center(
          child: Text('Ошибка: $err',
              style: const TextStyle(color: AppColors.error)),
        ),
        data: (user) {
          // 2. Если пользователь НЕ авторизован — показываем экран входа
          if (user == null) {
            return _buildLockedState(context);
          }

          // 3. Если авторизован — слушаем оригинальный провайдер ботов
          final connectedBotsAsync = ref.watch(connectedBotsProvider);

          return connectedBotsAsync.when(
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            ),
            error: (err, stack) => Center(
              child: Text('Ошибка: $err',
                  style: const TextStyle(color: AppColors.error)),
            ),
            data: (businesses) {
              // 4. Если список пуст — показываем Робота и переход в каталог
              if (businesses.isEmpty) {
                return _buildEmptyState(context);
              }

              // 5. Если боты есть — выводим список через оригинальный BusinessCard
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: businesses.length,
                itemBuilder: (context, index) {
                  final business = businesses[index];
                  return BusinessCard(
                    business: business,
                    onManage: () => context.push(
                      '/bot-management/${business.id}',
                      extra: business,
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

  // СОСТОЯНИЕ: Нужно войти (Замок)
  Widget _buildLockedState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline,
                size: 64, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            const Text(
              'Войдите, чтобы увидеть ваших ботов',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 200,
              height: 48,
              child: ElevatedButton(
                onPressed: () => context.push('/auth'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text(
                  'ВОЙТИ',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // СОСТОЯНИЕ: Список пуст (Робот)
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.smart_toy_outlined,
                size: 64, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            const Text(
              'У вас пока нет подключённых ботов',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 200,
              height: 48,
              child: OutlinedButton(
                onPressed: () => context.go('/'),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.accent, width: 1.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'ПЕРЕЙТИ В КАТАЛОГ',
                  style: TextStyle(
                    color: AppColors.accent,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
