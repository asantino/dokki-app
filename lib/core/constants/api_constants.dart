class ApiConstants {
  // URL основного бота (легко меняется)
  static const String botBaseUrl =
      'https://dokki-sales-bot-production.up.railway.app';
  static const String configEndpoint = '/api/config';
  static String get configUrl => '$botBaseUrl$configEndpoint';
}
