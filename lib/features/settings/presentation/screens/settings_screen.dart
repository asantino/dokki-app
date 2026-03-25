import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/providers/auth_providers.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/localization/language_provider.dart';
import '../../../../core/localization/app_strings.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final s = ref.watch(stringsProvider);
    final currentLang = ref.watch(languageProvider);

    // Маппинг для отображения названия текущего языка в субтитре
    final String langName = switch (currentLang) {
      AppLanguage.ru => 'Русский',
      AppLanguage.en => 'English',
      AppLanguage.ar => 'العربية',
    };

    final user = authState.when(
      data: (user) => user,
      loading: () => null,
      error: (_, __) => null,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          s.navSettings,
          style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter'),
        ),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: ListView(
        children: [
          _buildListTile(
            icon: FontAwesomeIcons.user,
            title: s.setAccount,
            subtitle: user?.email ?? s.authLogin,
            onTap: () {
              if (user == null) {
                context.push('/auth');
              } else {
                context.push('/profile', extra: user.email);
              }
            },
          ),
          const Divider(color: AppColors.border, height: 1),
          _buildListTile(
            icon: FontAwesomeIcons.globe,
            title: s.setLanguage,
            subtitle: langName,
            onTap: () => context.push('/language'),
          ),
          const Divider(color: AppColors.border, height: 1),
          _buildListTile(
            icon: FontAwesomeIcons.bell,
            title: s.setNotifications,
            subtitle: s.setNotifSettings,
            onTap: () => context.push('/notifications'),
          ),
          const Divider(color: AppColors.border, height: 1),
          _buildListTile(
            icon: FontAwesomeIcons.circleInfo,
            title: s.setAbout,
            subtitle: '${s.setVersion} 1.0.0',
            onTap: () => _showAboutDialog(s),
          ),
          const Divider(color: AppColors.border, height: 1),
        ],
      ),
    );
  }

  Widget _buildListTile({
    required dynamic icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Color? titleColor,
    Color? iconColor,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      tileColor: AppColors.surface,
      leading: SizedBox(
        width: 24,
        child: Center(
          child: FaIcon(icon, size: 20, color: iconColor ?? AppColors.accent),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: titleColor ?? AppColors.textPrimary,
          fontFamily: 'Inter',
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  fontFamily: 'Inter'),
            )
          : null,
      trailing: const Icon(Icons.chevron_right,
          color: AppColors.textSecondary, size: 20),
      onTap: onTap,
    );
  }

  void _showAboutDialog(AppStrings s) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(s.setAbout, style: const TextStyle(color: AppColors.textPrimary)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${s.setVersion} 1.0.0',
                style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _iconBtn(FontAwesomeIcons.telegram, 'Telegram'),
                _iconBtn(FontAwesomeIcons.instagram, 'Instagram'),
                _iconBtn(FontAwesomeIcons.tiktok, 'TikTok'),
                _iconBtn(FontAwesomeIcons.youtube, 'YouTube'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(s.profCancel, style: const TextStyle(color: AppColors.accent)))
        ],
      ),
    );
  }

  Widget _iconBtn(dynamic icon, String name) => IconButton(
        icon: FaIcon(icon, color: AppColors.accent, size: 24),
        onPressed: () {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Открыть $name')));
        },
      );
}
