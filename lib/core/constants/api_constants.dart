class ApiConstants {
  /// 🤖 URL основного бота (развёрнут на Fly.io)
  ///
  /// ВАЖНО: Это единственный сервер для ВСЕХ клиентов (multi-tenant)
  /// При переносе на другой хостинг — меняй только этот URL
  static const String botBaseUrl = 'https://dokki-sales-fly.fly.dev';

  static const String configEndpoint = '/api/config';

  static String get configUrl => '$botBaseUrl$configEndpoint';
}
