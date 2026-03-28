import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import '../../../../core/theme/app_theme.dart';
import '../../domain/business.dart';

class BotConfigScreen extends ConsumerStatefulWidget {
  final Business business;

  const BotConfigScreen({super.key, required this.business});

  @override
  ConsumerState<BotConfigScreen> createState() => _BotConfigScreenState();
}

class _BotConfigScreenState extends ConsumerState<BotConfigScreen> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _apiKeyController = TextEditingController();
  final _businessNameController = TextEditingController();
  final _welcomeController = TextEditingController();
  final _promptController = TextEditingController();

  String? _usernameError;
  String? _apiKeyError;
  String? _businessNameError;

  bool _isLoading = false;
  bool _obscureApiKey = true;

  @override
  void initState() {
    super.initState();

    // Используем botName из твоей модели
    _businessNameController.text = widget.business.botName ?? "";

    _welcomeController.text =
        'Здравствуйте! Вас приветствует ${widget.business.botName ?? "наша компания"}. Чем могу помочь?';

    _promptController.text =
        '''Ты — консультант компании ${widget.business.botName ?? "Dokki Business"}.

Твоя задача:
- Помогать клиентам с выбором услуг/товаров
- Отвечать на вопросы о ценах
- Передавать сложные вопросы менеджеру

Стиль: дружелюбный, профессиональный.''';
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _apiKeyController.dispose();
    _businessNameController.dispose();
    _welcomeController.dispose();
    _promptController.dispose();
    super.dispose();
  }

  Future<void> _saveConfig() async {
    setState(() {
      _usernameError = null;
      _apiKeyError = null;
      _businessNameError = null;
    });

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      // ПРОВЕРЬ: Если в модели появится railwayUrl, замени botSupabaseUrl на него
      final baseUrl = widget.business.botSupabaseUrl ?? "";
      final url = Uri.parse('$baseUrl/api/config');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'telegram_username': _usernameController.text.trim(),
          'openai_key': _apiKeyController.text.trim(),
          'business_name': _businessNameController.text.trim(),
          'welcome_message': _welcomeController.text.trim(),
          'system_prompt': _promptController.text.trim(),
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        if (mounted) {
          context.pushReplacement(
            '/bot-management/${widget.business.id}',
            extra: widget.business,
          );
        }
      } else {
        final errorMessage = data['error'] ?? 'Ошибка сохранения';
        final errorField = data['field'];

        setState(() {
          if (errorField == 'telegram_username') {
            _usernameError = errorMessage;
          } else if (errorField == 'openai_key') {
            _apiKeyError = errorMessage;
          } else if (errorField == 'business_name') {
            _businessNameError = errorMessage;
          }
        });

        throw Exception(errorMessage);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  InputDecoration _buildDecor(String label, String hint, {Widget? suffix}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
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
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
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
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _usernameController,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration:
                    _buildDecor('Telegram Bot Username', '@my_sales_bot')
                        .copyWith(
                  errorText: _usernameError,
                ),
                onChanged: (v) {
                  if (_usernameError != null) {
                    setState(() => _usernameError = null);
                  }
                },
                validator: (v) => (v == null || !v.startsWith('@'))
                    ? 'Должен начинаться с @'
                    : null,
              ),
              const SizedBox(height: 20),
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
                onChanged: (v) {
                  if (_apiKeyError != null) {
                    setState(() => _apiKeyError = null);
                  }
                },
                validator: (v) => (v == null || !v.startsWith('sk-'))
                    ? 'Некорректный ключ OpenAI'
                    : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _businessNameController,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration:
                    _buildDecor('Название компании', 'Моя компания').copyWith(
                  errorText: _businessNameError,
                ),
                onChanged: (v) {
                  if (_businessNameError != null) {
                    setState(() => _businessNameError = null);
                  }
                },
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Введите название' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _welcomeController,
                maxLines: 3,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: _buildDecor(
                    'Приветственное сообщение', 'Введите текст приветствия...'),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _promptController,
                maxLines: 10,
                style:
                    const TextStyle(color: AppColors.textPrimary, height: 1.4),
                decoration:
                    _buildDecor('Системный промпт', 'Инструкции для ИИ...'),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveConfig,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'СОХРАНИТЬ И ПРОДОЛЖИТЬ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
