import 'package:flutter/material.dart';
import '../../data/models/order_model.dart';
import '../../data/repositories/rewards_repository.dart';

class OrderHistoryViewModel extends ChangeNotifier {
  final RewardsRepository _repository = RewardsRepository();

  List<OrderModel> _orders = [];
  String _searchQuery = "";
  String _activeFilter = "All"; // "All", "Purchased", "Gifted"

  List<OrderModel> get orders => _orders;
  String get searchQuery => _searchQuery;
  String get activeFilter => _activeFilter;

  OrderHistoryViewModel() {
    loadOrders();
  }

  void loadOrders() {
    _orders = _repository.getOrders();
    notifyListeners();
  }

  void updateSearchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  void setFilter(String value) {
    _activeFilter = value;
    notifyListeners();
  }

  List<OrderModel> get filteredOrders {
    List<OrderModel> results = _orders;

    // Filter by type
    if (_activeFilter == "Purchased") {
      results = results.where((o) => !o.isGift).toList();
    } else if (_activeFilter == "Gifted") {
      results = results.where((o) => o.isGift).toList();
    }

    // Filter by search query
    if (_searchQuery.trim().isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      results = results.where((o) {
        return o.voucher.name.toLowerCase().contains(query) ||
            o.id.toLowerCase().contains(query) ||
            (o.giftDetails?.receiverName.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    // Sort by newest first
    results.sort((a, b) => b.purchaseDate.compareTo(a.purchaseDate));
    return results;
  }
}
