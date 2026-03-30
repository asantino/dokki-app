class Business {
  final String id;
  final String userId;
  final String botId;
  final String botToken;
  final String status;
  final String? telegramGroupId;
  final String? botBusinessId;
  final DateTime? createdAt;

  // Основные данные бота
  final String botName;
  final String botCategory;
  final String telegramUsername;
  final String businessName;

  // Опциональные поля для будущего
  final String? telegramToken;
  final String? openaiKey;

  // Данные из каталога (для отображения)
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
    this.botBusinessId,
    this.createdAt,
    required this.botName,
    required this.botCategory,
    required this.telegramUsername,
    required this.businessName,
    this.telegramToken,
    this.openaiKey,
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
      botBusinessId: json['bot_business_id'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      botName: (botData?['name'] ?? json['bot_name'] ?? '') as String,
      botCategory:
          (botData?['category'] ?? json['bot_category'] ?? '') as String,
      telegramUsername: json['telegram_username'] as String? ?? '',
      businessName: json['business_name'] as String? ?? '',
      telegramToken: json['telegram_token'] as String?,
      openaiKey: json['openai_key'] as String?,
      specialization: botData?['specialization'] as String?,
      tier: botData?['tier'] as String?,
      imageUrl: botData?['image_url'] as String?,
    );
  }

  Business copyWith({
    String? id,
    String? userId,
    String? botId,
    String? botToken,
    String? status,
    String? telegramGroupId,
    String? botBusinessId,
    DateTime? createdAt,
    String? botName,
    String? botCategory,
    String? telegramUsername,
    String? businessName,
    String? telegramToken,
    String? openaiKey,
    String? specialization,
    String? tier,
    String? imageUrl,
  }) {
    return Business(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      botId: botId ?? this.botId,
      botToken: botToken ?? this.botToken,
      status: status ?? this.status,
      telegramGroupId: telegramGroupId ?? this.telegramGroupId,
      botBusinessId: botBusinessId ?? this.botBusinessId,
      createdAt: createdAt ?? this.createdAt,
      botName: botName ?? this.botName,
      botCategory: botCategory ?? this.botCategory,
      telegramUsername: telegramUsername ?? this.telegramUsername,
      businessName: businessName ?? this.businessName,
      telegramToken: telegramToken ?? this.telegramToken,
      openaiKey: openaiKey ?? this.openaiKey,
      specialization: specialization ?? this.specialization,
      tier: tier ?? this.tier,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
