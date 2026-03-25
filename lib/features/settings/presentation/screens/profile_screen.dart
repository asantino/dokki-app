import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/providers/auth_providers.dart';
import '../../../../core/localization/language_provider.dart';
import '../../../../core/localization/app_strings.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final String currentEmail;

  const ProfileScreen({super.key, required this.currentEmail});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late AppStrings _s;

  void _notify(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.accent,
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
        title: Text(_s.profChangePass,
            style:
                const TextStyle(fontFamily: 'Inter', color: AppColors.textPrimary)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldPasswordController,
              obscureText: true,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                  labelText: _s.profCurrentPass,
                  labelStyle: const TextStyle(color: AppColors.textSecondary)),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                  labelText: _s.profNewPass,
                  labelStyle: const TextStyle(color: AppColors.textSecondary)),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                  labelText: _s.profRepeatPass,
                  labelStyle: const TextStyle(color: AppColors.textSecondary)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: Text(_s.profCancel,
                style: const TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () async {
              if (newPasswordController.text !=
                  confirmPasswordController.text) {
                _notify(_s.profPassMismatch, isError: true);
                return;
              }
              if (newPasswordController.text.length < 6) {
                _notify(_s.profPassLength, isError: true);
                return;
              }

              // TODO: Supabase.auth.updateUser(password: newPasswordController.text)

              Navigator.pop(c);
              _notify(_s.profPassSuccess);
            },
            child: Text(_s.profSave,
                style: const TextStyle(
                    color: AppColors.accent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    _s = s;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          s.profTitle,
          style: const TextStyle(
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 32),
          const Center(
            child: CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.accent,
              child: Icon(Icons.person, color: AppColors.surface, size: 40),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              widget.currentEmail,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                fontSize: 18,
                fontFamily: 'Inter',
              ),
            ),
          ),
          const SizedBox(height: 40),
          ListTile(
            tileColor: AppColors.surface,
            leading: const Icon(Icons.lock_outline, color: AppColors.accent),
            title: Text(
              s.profChangePass,
              style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter'),
            ),
            trailing:
                const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            onTap: _showChangePasswordDialog,
          ),
          const Divider(color: AppColors.border, height: 1),
          ListTile(
            tileColor: AppColors.surface,
            leading: const Icon(Icons.logout, color: AppColors.error),
            title: Text(
              s.profLogout,
              style: const TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter'),
            ),
            trailing:
                const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            onTap: () async {
              await ref.read(authRepositoryProvider).signOut();
            },
          ),
          const Divider(color: AppColors.border, height: 1),
        ],
      ),
    );
  }
}
