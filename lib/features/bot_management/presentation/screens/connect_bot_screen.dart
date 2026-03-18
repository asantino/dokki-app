import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/bot_management_providers.dart';
import '../../../../core/theme/app_theme.dart'; // Импорт темы

class ConnectBotScreen extends ConsumerStatefulWidget {
  final String botId;
  final String botName;

  const ConnectBotScreen({
    super.key,
    required this.botId,
    required this.botName,
  });

  @override
  ConsumerState<ConnectBotScreen> createState() => _ConnectBotScreenState();
}

class _ConnectBotScreenState extends ConsumerState<ConnectBotScreen> {
  // Поле пустое, токен не хардкодим
  final _tokenController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  // ЛОГИКА ОСТАВЛЕНА БЕЗ ИЗМЕНЕНИЙ
  Future<void> _connect() async {
    final token = _tokenController.text.trim();
    if (token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пожалуйста, введите токен')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Валидация нового (отозванного и перевыпущенного) токена
      final botInfo =
          await ref.read(telegramRepositoryProvider).validateToken(token);

      // 2. Сохранение в Supabase
      final result = await ref.read(businessRepositoryProvider).connectBot(
            botId: widget.botId,
            botToken: token,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Бот @${botInfo['username']} успешно подключён!'),
            backgroundColor: Colors.green,
          ),
        );

        context.pushReplacement(
          '/bot-management/${result.id}',
          extra: result,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Ошибка: ${e.toString().replaceAll('Exception: ', '')}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Хелпер для стиля поля ввода
  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.textSecondary),
      filled: true,
      fillColor: AppColors.card,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.accent, width: 2),
      ),
      prefixIcon:
          const Icon(Icons.vpn_key_rounded, color: AppColors.textSecondary),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // Тёмный фон
      appBar: AppBar(
        title: Text('Подключение ${widget.botName}'),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ИНСТРУКЦИЯ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: AppColors.textSecondary,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),

            // Инструкция в стилизованном контейнере
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border, width: 1),
              ),
              child: const Text(
                '1. Откройте @BotFather.\n'
                '2. Сгенерируйте НОВЫЙ токен (Revoke), если старый был скомпрометирован.\n'
                '3. Вставьте новый токен в поле ниже.',
                style: TextStyle(
                  height: 1.6,
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),

            const SizedBox(height: 32),

            const Text(
              'API ТОКЕН',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: AppColors.textSecondary,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),

            // Поле ввода токена
            TextField(
              controller: _tokenController,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              decoration: _buildInputDecoration('Bot API Token'),
              enabled: !_isLoading,
              autocorrect: false,
            ),

            const SizedBox(height: 40),

            // Акцентная кнопка
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _connect,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'ПРОВЕРИТЬ И ПОДКЛЮЧИТЬ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
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
