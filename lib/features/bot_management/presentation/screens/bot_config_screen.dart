import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/theme/app_theme.dart';

class BotConfigScreen extends ConsumerStatefulWidget {
  final String botId;
  final String botName;
  final String botCategory;

  const BotConfigScreen({
    super.key,
    required this.botId,
    required this.botName,
    required this.botCategory,
  });

  @override
  ConsumerState<BotConfigScreen> createState() => _BotConfigScreenState();
}

class _BotConfigScreenState extends ConsumerState<BotConfigScreen> {
  final _formKey = GlobalKey<FormState>();

  // Контроллеры ввода
  final _telegramUsernameController = TextEditingController();
  final _apiKeyController = TextEditingController();
  final _businessNameController = TextEditingController();
  final _welcomeController = TextEditingController();
  final _promptController = TextEditingController();

  // Состояния ошибок для конкретных полей (Error Mapping)
  String? _usernameError;
  String? _apiKeyError;
  String? _businessNameError;

  bool _isLoading = false;
  bool _obscureApiKey = true;

  @override
  void initState() {
    super.initState();
    _initializeDefaultValues();
  }

  void _initializeDefaultValues() {
    _businessNameController.text = widget.botName;
    _welcomeController.text =
        'Здравствуйте! Вас приветствует ${widget.botName}. Чем могу помочь?';

    _promptController.text = '''Ты — консультант компании ${widget.botName}.

Твоя задача:
- Помогать клиентам с выбором услуг/товаров
- Отвечать на вопросы о ценах
- Передавать сложные вопросы менеджеру

Стиль: дружелюбный, профессиональный.''';
  }

  @override
  void dispose() {
    _telegramUsernameController.dispose();
    _apiKeyController.dispose();
    _businessNameController.dispose();
    _welcomeController.dispose();
    _promptController.dispose();
    super.dispose();
  }

  Future<void> _saveConfig() async {
    // Сбрасываем ошибки перед новой попыткой
    setState(() {
      _usernameError = null;
      _apiKeyError = null;
      _businessNameError = null;
    });

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // 1. ОТПРАВКА КОНФИГУРАЦИИ НА БОТА
      final url = Uri.parse(ApiConstants.configUrl);
      debugPrint('🔵 Sending config to: $url');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'telegram_username': _telegramUsernameController.text.trim(),
          'openai_key': _apiKeyController.text.trim(),
          'business_name': _businessNameController.text.trim(),
          'welcome_message': _welcomeController.text.trim(),
          'system_prompt': _promptController.text.trim(),
        }),
      );

      final data = jsonDecode(response.body);

      // 2. ОБРАБОТКА ОТВЕТА
      if (response.statusCode == 200 && data['success'] == true) {
        // 3. СОХРАНЕНИЕ В SUPABASE
        final supabase = Supabase.instance.client;
        await supabase.from('businesses').insert({
          'user_id': supabase.auth.currentUser!.id,
          'bot_id': widget.botId,
          'bot_name': widget.botName,
          'bot_category': widget.botCategory,
          'telegram_username': _telegramUsernameController.text.trim(),
          'business_name': _businessNameController.text.trim(),
          'status': 'active',
          'created_at': DateTime.now().toIso8601String(),
        });

        // 4. ПОКАЗАТЬ SUCCESS DIALOG
        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: const Text('✅ Бот подключён!'),
              content: Text(
                'Ваш бот ${_telegramUsernameController.text.trim()} готов к работе.\n\nНапишите ему /start в Telegram для проверки.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Закрыть диалог
                    context.go('/'); // Вернуться на главный экран
                  },
                  child: const Text('Перейти к ботам'),
                ),
              ],
            ),
          );
        }
      } else {
        // Логика маппинга ошибок на поля ввода
        final errorMessage = data['error'] ?? 'Ошибка сохранения';
        final errorField =
            data['field']; // 'openai_key', 'telegram_username' и т.д.

        setState(() {
          if (errorField == 'telegram_username') _usernameError = errorMessage;
          if (errorField == 'openai_key') _apiKeyError = errorMessage;
          if (errorField == 'business_name') _businessNameError = errorMessage;
        });

        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('🔴 CONFIG SAVE ERROR: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  InputDecoration _buildDecor(String label, String hint, {Widget? suffix}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
      filled: true,
      fillColor: AppColors.card,
      suffixIcon: suffix,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.accent, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error, width: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Настройка ИИ'),
        centerTitle: false,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ИСПРАВЛЕНИЕ: Добавлен const
              const Card(
                margin: EdgeInsets.all(16),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.blue),
                          SizedBox(width: 8),
                          Text(
                            'Как подключить бота',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text('1. Откройте @BotFather в Telegram'),
                      Text('2. Отправьте команду /newbot'),
                      Text('3. Следуйте инструкциям'),
                      Text('4. Скопируйте токен бота'),
                      Text('5. Вставьте ниже вместе с другими данными'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Username Бота
              TextFormField(
                controller: _telegramUsernameController,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration:
                    _buildDecor('Telegram Bot Username', '@my_sales_bot')
                        .copyWith(
                  errorText: _usernameError,
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Введите username';
                  if (!v.trim().startsWith('@')) return 'Должен начинаться с @';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // OpenAI Key
              TextFormField(
                controller: _apiKeyController,
                obscureText: _obscureApiKey,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: _buildDecor(
                  'OpenAI API Key',
                  'sk-proj-...',
                  suffix: IconButton(
                    icon: Icon(
                        _obscureApiKey
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColors.textSecondary),
                    onPressed: () =>
                        setState(() => _obscureApiKey = !_obscureApiKey),
                  ),
                ).copyWith(errorText: _apiKeyError),
                validator: (v) {
                  final key = v?.trim() ?? "";
                  if (key.isEmpty) return 'Введите ключ API';
                  // ИСПРАВЛЕНИЕ: Добавлены фигурные скобки
                  if (!key.startsWith('sk-')) {
                    return 'Ключ должен начинаться с "sk-"';
                  }
                  if (key.length < 40) return 'Ключ слишком короткий';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Имя бизнеса
              TextFormField(
                controller: _businessNameController,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: _buildDecor('Название компании', 'Напр: Dokki Docs')
                    .copyWith(
                  errorText: _businessNameError,
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Введите название бизнеса'
                    : null,
              ),
              const SizedBox(height: 20),

              // Приветствие
              TextFormField(
                controller: _welcomeController,
                maxLines: 3,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration:
                    _buildDecor('Приветствие', 'Что бот скажет первым?'),
              ),
              const SizedBox(height: 20),

              // Промпт
              TextFormField(
                controller: _promptController,
                maxLines: 10,
                style: const TextStyle(
                    color: AppColors.textPrimary, height: 1.4, fontSize: 14),
                decoration: _buildDecor('Инструкции для ИИ (Промпт)',
                    'Опишите правила поведения бота...'),
              ),
              const SizedBox(height: 40),

              // Кнопка сохранения
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveConfig,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2.5),
                        )
                      : const Text(
                          'ПОДКЛЮЧИТЬ БОТА',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white),
                        ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
