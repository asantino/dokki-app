import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/localization/language_provider.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  bool _pushEnabled = true;
  bool _emailEnabled = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final s = ref.watch(stringsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(s.setNotifications),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: const BackButton(color: AppColors.textPrimary),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            activeThumbColor: AppColors.accent,
            tileColor: AppColors.surface,
            title: Text(s.notifPush, style: textTheme.bodyLarge),
            subtitle: Text(
              s.notifPushSub,
              style:
                  textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
            value: _pushEnabled,
            onChanged: (bool value) => setState(() => _pushEnabled = value),
          ),
          const Divider(color: AppColors.border, height: 1),
          SwitchListTile(
            activeThumbColor: AppColors.accent,
            tileColor: AppColors.surface,
            title: Text(s.notifEmail, style: textTheme.bodyLarge),
            subtitle: Text(
              s.notifEmailSub,
              style:
                  textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
            value: _emailEnabled,
            onChanged: (bool value) => setState(() => _emailEnabled = value),
          ),
          const Divider(color: AppColors.border, height: 1),
        ],
      ),
    );
  }
}
