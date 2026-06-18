import 'package:flutter/material.dart';
import '../../data/models/order_model.dart';
import '../../data/repositories/rewards_repository.dart';

class VoucherPostPurchaseViewModel extends ChangeNotifier {
  final RewardsRepository _repository = RewardsRepository();

  OrderModel? _order;
  int _activeTabIndex = 0; // 0 for T&C, 1 for How to Redeem

  OrderModel? get order => _order;
  int get activeTabIndex => _activeTabIndex;

  void initialize(OrderModel order) {
    _order = order;
    _activeTabIndex = 0;
    notifyListeners();
  }

  void setTab(int index) {
    _activeTabIndex = index;
    notifyListeners();
  }

  void revealVoucher() {
    if (_order != null) {
      _repository.revealOrderVoucher(_order!.id);
      _order = _order!.copyWith(isRevealed: true);
      notifyListeners();
    }
  }
}
