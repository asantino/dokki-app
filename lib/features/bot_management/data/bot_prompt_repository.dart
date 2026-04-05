// lib/features/bot_management/data/bot_prompt_repository.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class BotPromptRepository {
  /// Отправляет POST запрос на индивидуальный инстанс бота для обновления системного промпта.
  /// [botUrl] — базовый URL бота (например, https://dokki-abc-production.up.railway.app).
  /// [telegramUsername] — юзернейм бота для идентификации в базе бота.
  /// [systemPrompt] — новый текст инструкций.
  Future<bool> updateSystemPrompt({
    required String botUrl,
    required String telegramUsername,
    required String systemPrompt,
  }) async {
    // Убеждаемся, что юзернейм начинается с @ для корректной работы API бота
    final String formattedUsername = telegramUsername.startsWith('@')
        ? telegramUsername
        : '@$telegramUsername';

    try {
      // Формируем URL к новому эндпоинту конфигурации
      final url = Uri.parse('$botUrl/api/config/system-prompt');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'telegram_username': formattedUsername,
          'system_prompt': systemPrompt.trim(),
        }),
      );

      // Возвращаем true только при успешном статус-коде 200
      return response.statusCode == 200;
    } catch (e) {
      // Используем debugPrint вместо print, чтобы линтер был доволен
      debugPrint('Error updating system prompt: $e');
      return false;
    }
  }
}
