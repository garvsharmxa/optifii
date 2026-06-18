class BrandModel {
  final String id;
  final String name;
  final double discountPercentage;
  final double startingPrice;
  final String themeColorHex;
  final String category;
  final String? logoUrl; // Fallback if images are used

  const BrandModel({
    required this.id,
    required this.name,
    required this.discountPercentage,
    required this.startingPrice,
    required this.themeColorHex,
    required this.category,
    this.logoUrl,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: json['id'] as String,
      name: json['name'] as String,
      discountPercentage: (json['discountPercentage'] as num).toDouble(),
      startingPrice: (json['startingPrice'] as num).toDouble(),
      themeColorHex: json['themeColorHex'] as String,
      category: json['category'] as String,
      logoUrl: json['logoUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'discountPercentage': discountPercentage,
      'startingPrice': startingPrice,
      'themeColorHex': themeColorHex,
      'category': category,
      'logoUrl': logoUrl,
    };
  }
}
