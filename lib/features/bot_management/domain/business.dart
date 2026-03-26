class Business {
  final String id;
  final String userId;
  final String botId;
  final String botToken;
  final String status;
  final String? telegramGroupId;
  final String? botSupabaseUrl;
  final String? botSupabaseAnonKey;
  final String? botBusinessId;
  final DateTime? createdAt;

  // Поля деплоя
  final String? clientRailwayToken;
  final String? clientRailwayWorkspaceId;

  // Данные из JOIN (bot_catalog)
  final String? botName;
  final String? botCategory;
  final String? specialization;
  final String? tier;
  final String? imageUrl;

  Business({
    required this.id,
    required this.userId,
    required this.botId,
    required this.botToken,
    required this.status,
    this.telegramGroupId,
    this.botSupabaseUrl,
    this.botSupabaseAnonKey,
    this.botBusinessId,
    this.createdAt,
    this.clientRailwayToken,
    this.clientRailwayWorkspaceId,
    this.botName,
    this.botCategory,
    this.specialization,
    this.tier,
    this.imageUrl,
  });

  factory Business.fromJson(Map<String, dynamic> json) {
    // Извлекаем вложенный объект из JOIN запроса Supabase
    final botData = json['bot_catalog'] as Map<String, dynamic>?;

    return Business(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      botId: json['bot_id'] as String,
      botToken: json['bot_token'] as String,
      status: json['status'] as String,
      telegramGroupId: json['telegram_group_id'] as String?,
      botSupabaseUrl: json['bot_supabase_url'] as String?,
      botSupabaseAnonKey: json['bot_supabase_anon_key'] as String?,
      botBusinessId: json['bot_business_id'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      clientRailwayToken: json['client_railway_token'] as String?,
      clientRailwayWorkspaceId: json['client_railway_workspace_id'] as String?,

      // Маппинг данных из bot_catalog
      botName: botData?['name'] as String?,
      botCategory: botData?['category'] as String?,
      specialization: botData?['specialization'] as String?,
      tier: botData?['tier'] as String?,
      imageUrl: botData?['image_url'] as String?,
    );
  }
}
