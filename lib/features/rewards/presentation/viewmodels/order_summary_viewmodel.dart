import 'package:flutter/material.dart';
import '../../data/models/voucher_model.dart';
import '../../data/models/gift_details_model.dart';

class OrderSummaryViewModel extends ChangeNotifier {
  VoucherModel? _voucher;
  int _quantity = 1;
  double _denominationAmount = 0.0;
  bool _isGift = false;
  GiftDetailsModel? _giftDetails;

  VoucherModel? get voucher => _voucher;
  int get quantity => _quantity;
  double get denominationAmount => _denominationAmount;
  bool get isGift => _isGift;
  GiftDetailsModel? get giftDetails => _giftDetails;

  double get netValue => _denominationAmount * _quantity;
  double get discountValue {
    if (_voucher == null) return 0.0;
    return netValue * (_voucher!.discountPercentage / 100.0);
  }
  double get finalPayableAmount => netValue - discountValue;

  void setupSummary({
    required VoucherModel voucher,
    required int quantity,
    required double denominationAmount,
    required bool isGift,
    GiftDetailsModel? giftDetails,
  }) {
    _voucher = voucher;
    _quantity = quantity;
    _denominationAmount = denominationAmount;
    _isGift = isGift;
    _giftDetails = giftDetails;
    notifyListeners();
  }
}
