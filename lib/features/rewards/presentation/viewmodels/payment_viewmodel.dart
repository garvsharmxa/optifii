import 'dart:math';
import 'package:flutter/material.dart';
import '../../data/models/order_model.dart';
import '../../data/models/voucher_model.dart';
import '../../data/models/gift_details_model.dart';
import '../../data/repositories/rewards_repository.dart';

class PaymentViewModel extends ChangeNotifier {
  final RewardsRepository _repository = RewardsRepository();

  bool _isProcessing = false;
  OrderModel? _lastCreatedOrder;

  bool get isProcessing => _isProcessing;
  OrderModel? get lastCreatedOrder => _lastCreatedOrder;

  Future<bool> processPayment({
    required VoucherModel voucher,
    required int quantity,
    required double totalAmount,
    required double discountAmount,
    required double finalAmount,
    required bool isGift,
    GiftDetailsModel? giftDetails,
  }) async {
    _isProcessing = true;
    notifyListeners();

    // Simulate Payment gateway delay (Razorpay)
    await Future.delayed(const Duration(seconds: 2));

    // Generate random 16 digit card number and 6 digit pin
    final rand = Random();
    String cardNum = "";
    for (int i = 0; i < 4; i++) {
      cardNum += (1000 + rand.nextInt(9000)).toString();
      if (i < 3) cardNum += " ";
    }
    String pin = (100000 + rand.nextInt(900000)).toString();

    // Create Order
    final order = OrderModel(
      id: "ORD-${100000 + rand.nextInt(900000)}",
      voucher: voucher,
      quantity: quantity,
      totalAmount: totalAmount,
      discountAmount: discountAmount,
      finalAmount: finalAmount,
      purchaseDate: DateTime.now(),
      isGift: isGift,
      giftDetails: giftDetails,
      cardNumber: cardNum,
      pinCode: pin,
      isRevealed: false,
    );

    // Save order in history repo
    _repository.addOrder(order);
    _lastCreatedOrder = order;

    _isProcessing = false;
    notifyListeners();
    return true;
  }
}
