import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // Импорт для локализации
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/localization/language_provider.dart';

class DokkiApp extends ConsumerWidget {
  const DokkiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    // Подписываемся на изменение языка
    final currentLanguage = ref.watch(languageProvider);

    return MaterialApp.router(
      title: 'Dokki Business',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      themeMode: ThemeMode.light,
      // Устанавливаем текущую локаль (ru, en или ar)
      locale: Locale(currentLanguage.name),
      // Подключаем глобальные делегаты для поддержки RTL и нативных виджетов
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // Список всех языков, которые понимает приложение
      supportedLocales: const [
        Locale('en'),
        Locale('ru'),
        Locale('ar'),
      ],
      routerConfig: router,
    );
  }
}
