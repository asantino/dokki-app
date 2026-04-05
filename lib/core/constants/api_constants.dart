class ApiConstants {
  /// URL оркестратора деплоя на Railway
  static const String deployServiceUrl =
      'https://dokki-deploy-service-production-a748.up.railway.app';

  /// Конечная точка для деплоя нового бота
  static String get deployUrl => '$deployServiceUrl/deploy';

  /// Генерирует URL индивидуального бота на основе ID бизнеса.
  /// Railway использует shortId (первые 8 символов UUID без дефисов).
  static String getBotUrl(String businessId) {
    if (businessId.isEmpty) return '';
    final shortId = businessId.replaceAll('-', '').substring(0, 8);
    return 'https://dokki-$shortId-production.up.railway.app';
  }
}
