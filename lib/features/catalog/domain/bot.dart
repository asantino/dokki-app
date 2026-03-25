class Bot {
  final String id;
  final String name;
  final String description;
  final String shortDescription;
  final String category;
  final String? imageUrl;
  final List<String>? features;
  final String? githubRepo;
  final double? priceMonthly;
  final double? priceYearly;
  final List<Map<String, dynamic>>? shortFeatures;

  Bot({
    required this.id,
    required this.name,
    required this.description,
    required this.shortDescription,
    required this.category,
    this.imageUrl,
    this.features,
    this.githubRepo,
    this.priceMonthly,
    this.priceYearly,
    this.shortFeatures,
  });

  factory Bot.fromJson(Map<String, dynamic> json) {
    return Bot(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      shortDescription: json['short_description'] as String? ?? '',
      category: json['category'] as String? ?? 'general',
      imageUrl: json['image_url'] as String?,
      features: (json['features'] as List?)?.map((e) => e.toString()).toList(),
      githubRepo: json['github_repo'] as String?,
      priceMonthly: (json['price_monthly'] as num?)?.toDouble(),
      priceYearly: (json['price_yearly'] as num?)?.toDouble() ??
          ((json['price_monthly'] as num?)?.toDouble() ?? 0) * 10,
      shortFeatures: (json['short_features'] as List?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
    );
  }
}
