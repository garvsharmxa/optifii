class GiftDetailsModel {
  final String receiverName;
  final String receiverPhone;
  final String receiverEmail;
  final String customMessage;
  final int themeIndex;

  const GiftDetailsModel({
    required this.receiverName,
    required this.receiverPhone,
    required this.receiverEmail,
    required this.customMessage,
    required this.themeIndex,
  });

  factory GiftDetailsModel.fromJson(Map<String, dynamic> json) {
    return GiftDetailsModel(
      receiverName: json['receiverName'] as String,
      receiverPhone: json['receiverPhone'] as String,
      receiverEmail: json['receiverEmail'] as String,
      customMessage: json['customMessage'] as String,
      themeIndex: json['themeIndex'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'receiverName': receiverName,
      'receiverPhone': receiverPhone,
      'receiverEmail': receiverEmail,
      'customMessage': customMessage,
      'themeIndex': themeIndex,
    };
  }
}
