import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  final List<String> _languages = ['English', 'العربية', 'Русский'];
  String _selectedLanguage = 'Русский';

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Язык'),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: const BackButton(color: AppColors.textPrimary),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _languages.length,
        separatorBuilder: (context, index) => const Divider(
          color: AppColors.border,
          height: 1,
          indent: 16,
          endIndent: 16,
        ),
        itemBuilder: (context, index) {
          final language = _languages[index];
          return ListTile(
            tileColor: AppColors.surface,
            title: Text(
              language,
              style: textTheme.bodyLarge,
            ),
            trailing: _selectedLanguage == language
                ? const Icon(Icons.check, color: AppColors.accent)
                : null,
            onTap: () {
              setState(() => _selectedLanguage = language);
              // Возвращаем выбранное значение и закрываем экран
              Navigator.pop(context, language);
            },
          );
        },
      ),
    );
  }
}
