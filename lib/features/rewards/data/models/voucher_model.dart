class VoucherModel {
  final String id;
  final String brandId;
  final String name;
  final int validityMonths;
  final double discountPercentage;
  final List<double> predefinedDenominations;
  final double minCustomAmount;
  final double maxCustomAmount;
  final List<String> termsAndConditions;
  final List<String> redemptionSteps;

  const VoucherModel({
    required this.id,
    required this.brandId,
    required this.name,
    required this.validityMonths,
    required this.discountPercentage,
    required this.predefinedDenominations,
    required this.minCustomAmount,
    required this.maxCustomAmount,
    required this.termsAndConditions,
    required this.redemptionSteps,
  });

  factory VoucherModel.fromJson(Map<String, dynamic> json) {
    return VoucherModel(
      id: json['id'] as String,
      brandId: json['brandId'] as String,
      name: json['name'] as String,
      validityMonths: json['validityMonths'] as int,
      discountPercentage: (json['discountPercentage'] as num).toDouble(),
      predefinedDenominations: (json['predefinedDenominations'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
      minCustomAmount: (json['minCustomAmount'] as num).toDouble(),
      maxCustomAmount: (json['maxCustomAmount'] as num).toDouble(),
      termsAndConditions: List<String>.from(json['termsAndConditions'] as List),
      redemptionSteps: List<String>.from(json['redemptionSteps'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brandId': brandId,
      'name': name,
      'validityMonths': validityMonths,
      'discountPercentage': discountPercentage,
      'predefinedDenominations': predefinedDenominations,
      'minCustomAmount': minCustomAmount,
      'maxCustomAmount': maxCustomAmount,
      'termsAndConditions': termsAndConditions,
      'redemptionSteps': redemptionSteps,
    };
  }
}
