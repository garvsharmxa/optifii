import 'package:flutter/material.dart';
import '../../data/models/brand_model.dart';
import '../../data/models/voucher_model.dart';
import '../../data/repositories/rewards_repository.dart';

class VoucherDetailsViewModel extends ChangeNotifier {
  final RewardsRepository _repository = RewardsRepository();

  BrandModel? _brand;
  VoucherModel? _voucher;
  double? _selectedDenomination;
  double? _customAmount;
  int _quantity = 1;
  String _errorMessage = "";

  BrandModel? get brand => _brand;
  VoucherModel? get voucher => _voucher;
  double? get selectedDenomination => _selectedDenomination;
  double? get customAmount => _customAmount;
  int get quantity => _quantity;
  String get errorMessage => _errorMessage;

  double get activeAmount {
    if (_selectedDenomination != null) {
      return _selectedDenomination!;
    }
    return _customAmount ?? 0.0;
  }

  double get netOrderValue {
    return activeAmount * _quantity;
  }

  double get discountValue {
    if (_voucher == null) return 0.0;
    return netOrderValue * (_voucher!.discountPercentage / 100.0);
  }

  double get finalPayableAmount {
    return netOrderValue - discountValue;
  }

  void initialize(String brandId) {
    final brands = _repository.getBrands();
    _brand = brands.firstWhere((element) => element.id == brandId);
    _voucher = _repository.getVoucherByBrandId(brandId);
    
    // Default to the first predefined denomination
    if (_voucher != null && _voucher!.predefinedDenominations.isNotEmpty) {
      _selectedDenomination = _voucher!.predefinedDenominations[0];
    }
    _customAmount = null;
    _quantity = 1;
    _errorMessage = "";
    notifyListeners();
  }

  void selectDenomination(double value) {
    _selectedDenomination = value;
    _customAmount = null;
    _errorMessage = "";
    notifyListeners();
  }

  void setCustomAmount(double value) {
    if (_voucher == null) return;
    if (value < _voucher!.minCustomAmount || value > _voucher!.maxCustomAmount) {
      _errorMessage = "Amount must be between ₹${_voucher!.minCustomAmount.toInt()} and ₹${_voucher!.maxCustomAmount.toInt()}";
    } else {
      _errorMessage = "";
    }
    _customAmount = value;
    _selectedDenomination = null;
    notifyListeners();
  }

  void clearCustomAmount() {
    _customAmount = null;
    _errorMessage = "";
    notifyListeners();
  }

  void incrementQuantity() {
    _quantity++;
    notifyListeners();
  }

  void decrementQuantity() {
    if (_quantity > 1) {
      _quantity--;
      notifyListeners();
    }
  }
}
