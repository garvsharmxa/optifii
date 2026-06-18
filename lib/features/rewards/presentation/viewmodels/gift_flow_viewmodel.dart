import 'package:flutter/material.dart';
import '../../data/models/gift_details_model.dart';

class GiftFlowViewModel extends ChangeNotifier {
  bool _isGifting = false;
  String _receiverName = "";
  String _receiverPhone = "";
  String _receiverEmail = "";
  String _customMessage = "";
  int _selectedThemeIndex = 0;

  bool get isGifting => _isGifting;
  String get receiverName => _receiverName;
  String get receiverPhone => _receiverPhone;
  String get receiverEmail => _receiverEmail;
  String get customMessage => _customMessage;
  int get selectedThemeIndex => _selectedThemeIndex;

  final List<String> themeBanners = [
    "Purple Sparkle",
    "Golden Celebration",
    "Neon Abstract",
    "Classic Teal",
  ];

  void setGifting(bool value) {
    _isGifting = value;
    notifyListeners();
  }

  void updateReceiverName(String name) {
    _receiverName = name;
    notifyListeners();
  }

  void updateReceiverPhone(String phone) {
    _receiverPhone = phone;
    notifyListeners();
  }

  void updateReceiverEmail(String email) {
    _receiverEmail = email;
    notifyListeners();
  }

  void updateCustomMessage(String msg) {
    if (msg.length <= 200) {
      _customMessage = msg;
    }
    notifyListeners();
  }

  void selectTheme(int index) {
    _selectedThemeIndex = index;
    notifyListeners();
  }

  bool get isFormValid {
    if (!_isGifting) return true;
    return _receiverName.isNotEmpty &&
        _receiverPhone.isNotEmpty &&
        _receiverEmail.contains("@") &&
        _receiverEmail.isNotEmpty;
  }

  GiftDetailsModel? getGiftDetails() {
    if (!_isGifting) return null;
    return GiftDetailsModel(
      receiverName: _receiverName,
      receiverPhone: _receiverPhone,
      receiverEmail: _receiverEmail,
      customMessage: _customMessage,
      themeIndex: _selectedThemeIndex,
    );
  }

  void reset() {
    _isGifting = false;
    _receiverName = "";
    _receiverPhone = "";
    _receiverEmail = "";
    _customMessage = "";
    _selectedThemeIndex = 0;
    notifyListeners();
  }
}
