import 'voucher_model.dart';
import 'gift_details_model.dart';

class OrderModel {
  final String id;
  final VoucherModel voucher;
  final int quantity;
  final double totalAmount;
  final double discountAmount;
  final double finalAmount;
  final DateTime purchaseDate;
  final bool isGift;
  final GiftDetailsModel? giftDetails;
  final String cardNumber;
  final String pinCode;
  final bool isRevealed;

  const OrderModel({
    required this.id,
    required this.voucher,
    required this.quantity,
    required this.totalAmount,
    required this.discountAmount,
    required this.finalAmount,
    required this.purchaseDate,
    required this.isGift,
    this.giftDetails,
    required this.cardNumber,
    required this.pinCode,
    required this.isRevealed,
  });

  OrderModel copyWith({
    bool? isRevealed,
  }) {
    return OrderModel(
      id: id,
      voucher: voucher,
      quantity: quantity,
      totalAmount: totalAmount,
      discountAmount: discountAmount,
      finalAmount: finalAmount,
      purchaseDate: purchaseDate,
      isGift: isGift,
      giftDetails: giftDetails,
      cardNumber: cardNumber,
      pinCode: pinCode,
      isRevealed: isRevealed ?? this.isRevealed,
    );
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      voucher: VoucherModel.fromJson(json['voucher'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      discountAmount: (json['discountAmount'] as num).toDouble(),
      finalAmount: (json['finalAmount'] as num).toDouble(),
      purchaseDate: DateTime.parse(json['purchaseDate'] as String),
      isGift: json['isGift'] as bool,
      giftDetails: json['giftDetails'] != null
          ? GiftDetailsModel.fromJson(json['giftDetails'] as Map<String, dynamic>)
          : null,
      cardNumber: json['cardNumber'] as String,
      pinCode: json['pinCode'] as String,
      isRevealed: json['isRevealed'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'voucher': voucher.toJson(),
      'quantity': quantity,
      'totalAmount': totalAmount,
      'discountAmount': discountAmount,
      'finalAmount': finalAmount,
      'purchaseDate': purchaseDate.toIso8601String(),
      'isGift': isGift,
      'giftDetails': giftDetails?.toJson(),
      'cardNumber': cardNumber,
      'pinCode': pinCode,
      'isRevealed': isRevealed,
    };
  }
}
