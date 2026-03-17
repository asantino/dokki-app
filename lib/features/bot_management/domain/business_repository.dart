import 'business.dart';

abstract class BusinessRepository {
  /// Получить список всех ботов пользователя
  Future<List<Business>> getBusinesses();

  /// Подключить нового бота
  Future<Business> connectBot({
    required String botId,
    required String botToken,
  });

  /// Обновить данные существующего бота (например, статус или telegram_group_id)
  Future<Business> updateBusiness(String id, Map<String, dynamic> data);
}
