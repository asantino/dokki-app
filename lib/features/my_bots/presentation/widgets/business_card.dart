import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_theme.dart';
// Путь к модели в другом модуле
import '../../../bot_management/domain/business.dart';

class BusinessCard extends StatelessWidget {
  final Business business;
  final VoidCallback onManage;

  const BusinessCard({
    super.key,
    required this.business,
    required this.onManage,
  });

  @override
  Widget build(BuildContext context) {
    // Маппинг для Storage: dokki-admin -> bot_admin
    final botImageName = business.botId.replaceAll('dokki-', 'bot_');
    final imageUrl =
        'https://cjjdkrsqrtfirywrmrxu.supabase.co/storage/v1/object/public/bot-images/$botImageName.png';

    return SizedBox(
      height: 160,
      width: double.infinity,
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // ЛЕВЫЙ БЛОК: Иллюстрация 160x160
            SizedBox(
              width: 160,
              height: 160,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  placeholder: (context, url) => Container(
                    color: AppColors.background,
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.accent,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: AppColors.background,
                    child: const Icon(
                      Icons.smart_toy_outlined,
                      size: 48,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),

            // ПРАВЫЙ БЛОК: Контент с padding 12
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Название
                    Text(
                      _formatBotId(business.botId),
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        letterSpacing: 0.2,
                        fontFamily: 'Inter 18pt',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),

                    // 2. Специализация (Маппинг)
                    Text(
                      _getBotCategory(business.botId),
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        fontFamily: 'Inter 18pt',
                      ),
                    ),
                    const SizedBox(height: 4),

                    // 3. Статус (Точка + Текст)
                    _buildStatusRow(),

                    const Spacer(),

                    // 4. Кнопка Управление
                    SizedBox(
                      width: double.infinity,
                      height: 32,
                      child: OutlinedButton(
                        onPressed: onManage,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.accent),
                          foregroundColor: AppColors.accent,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Управление',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter 18pt',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Форматирование ID (dokki-sales -> Dokki Sales)
  String _formatBotId(String botId) {
    if (botId.isEmpty) return 'Робот';
    return botId
        .split('-')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  // Маппинг специализаций
  String _getBotCategory(String botId) {
    const categoryMap = {
      'dokki-admin': 'Администратор',
      'dokki-sales': 'Продавец',
      'dokki-support': 'Поддержка',
    };
    return categoryMap[botId.trim()] ?? '';
  }

  // Логика статуса
  Widget _buildStatusRow() {
    Color dotColor;
    String statusText;

    if (business.status == 'active' && business.telegramGroupId != null) {
      dotColor = AppColors.success;
      statusText = 'В работе';
    } else if (business.status == 'active' &&
        business.telegramGroupId == null) {
      dotColor = AppColors.warning;
      statusText = 'Настройка';
    } else {
      dotColor = AppColors.error;
      statusText = 'Отключён';
    }

    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: dotColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          statusText,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
            fontFamily: 'Inter 18pt',
          ),
        ),
      ],
    );
  }
}
