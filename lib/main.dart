import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/env/env.dart';
import 'core/localization/language_provider.dart';
import 'app.dart';

void main() async {
  // 1. Инициализация движка Flutter (обязательно для доступа к платформенным плагинам до runApp)
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Предварительная загрузка SharedPreferences
  // Это гарантирует, что при создании LanguageNotifier данные уже будут в памяти
  final prefs = await SharedPreferences.getInstance();

  // 3. Инициализация Supabase
  await Supabase.initialize(
    url: Env.supabaseUrl,
    anonKey: Env.supabaseAnonKey,
  );

  runApp(
    ProviderScope(
      overrides: [
        // 4. Внедряем инициализированный экземпляр SharedPreferences в систему Riverpod
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      // Важно: убираем const у ProviderScope, так как overrides вычисляется в runtime
      child: const DokkiApp(),
    ),
  );
}
