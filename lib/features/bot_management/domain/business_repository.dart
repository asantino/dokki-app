import 'business.dart';

abstract class BusinessRepository {
  Future<Business> connectBot({
    required String botId,
    required String botToken,
    required String railwayToken,
    required String railwayWorkspaceId,
  });
  Future<List<Business>> getConnectedBots();
  Future<Business?> getBusinessById(String id);

  // Новый метод для обновления URL
  Future<void> updateRailwayUrl(String businessId, String railwayUrl);
}
