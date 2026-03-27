import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/localization/language_provider.dart';
import '../../../../core/localization/app_strings.dart';

class LanguageScreen extends ConsumerStatefulWidget {
  const LanguageScreen({super.key});

  @override
  ConsumerState<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends ConsumerState<LanguageScreen> {
  // Порядок изменен: English, العربية, Русский
  final List<String> _languages = ['English', 'العربية', 'Русский'];

  AppLanguage _languageByLabel(String label) {
    switch (label) {
      case 'English':
        return AppLanguage.en;
      case 'العربية':
        return AppLanguage.ar;
      default:
        return AppLanguage.ru;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentLang = ref.watch(languageProvider);
    final s = ref.watch(stringsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(s.setLanguage),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: const BackButton(color: AppColors.textPrimary),
      ),
      body: ListView.separated(
        itemCount: _languages.length,
        separatorBuilder: (context, index) =>
            const Divider(color: AppColors.border, height: 1),
        itemBuilder: (context, index) {
          final language = _languages[index];
          final isSelected = currentLang == _languageByLabel(language);

          return ListTile(
            tileColor: AppColors.surface,
            title: Text(
              language,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontFamily: 'Inter',
              ),
            ),
            trailing: isSelected
                ? const Icon(Icons.check, color: AppColors.accent)
                : null,
            onTap: () {
              final selected = _languageByLabel(language);
              ref.read(languageProvider.notifier).setLanguage(selected);
              Navigator.pop(context, language);
            },
          );
        },
      ),
    );
  }
}
