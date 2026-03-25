import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final String currentEmail;

  const ProfileScreen({super.key, required this.currentEmail});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.currentEmail);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _notify(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : Colors.green,
      ),
    );
  }

  void _showChangePasswordDialog() {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        backgroundColor: AppColors.surface,
        title:
            const Text('Сменить пароль', style: TextStyle(fontFamily: 'Inter')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Текущий пароль'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Новый пароль'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration:
                  const InputDecoration(labelText: 'Повторите новый пароль'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: const Text('Отмена',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () async {
              if (newPasswordController.text !=
                  confirmPasswordController.text) {
                _notify('Пароли не совпадают', isError: true);
                return;
              }
              if (newPasswordController.text.length < 6) {
                _notify('Пароль должен быть минимум 6 символов', isError: true);
                return;
              }

              // TODO: Supabase.auth.updateUser(password: newPasswordController.text)

              Navigator.pop(c);
              _notify('Пароль успешно изменён');
            },
            child: const Text('Сохранить',
                style: TextStyle(
                    color: AppColors.accent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _saveEmail() {
    final email = _emailController.text.trim();
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (email.isEmpty || !emailRegex.hasMatch(email)) {
      _notify('Введите корректный email', isError: true);
      return;
    }

    // TODO: Supabase.auth.updateUser(email: email)
    _notify('Email обновлён');
    Navigator.pop(context, email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Профиль',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Email',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(
                fontSize: 18,
                color: AppColors.textPrimary,
                fontFamily: 'Inter',
              ),
              decoration: InputDecoration(
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: AppColors.textSecondary.withValues(alpha: 0.3),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(color: AppColors.accent, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Кнопка сохранения Email
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _saveEmail,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text(
                  'СОХРАНИТЬ EMAIL',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Кнопка смены пароля
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                onPressed: _showChangePasswordDialog,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.accent, width: 1.5),
                  foregroundColor: AppColors.accent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'СМЕНИТЬ ПАРОЛЬ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    letterSpacing: 0.5,
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
