import 'package:flutter/material.dart';
import '../../data/models/brand_model.dart';
import '../../data/models/category_model.dart';
import '../../data/repositories/rewards_repository.dart';

class SearchDiscoveryViewModel extends ChangeNotifier {
  final RewardsRepository _repository = RewardsRepository();

  List<String> _searchHistory = ["Flipkart", "Swiggy", "Fashion"];
  String _query = "";
  List<BrandModel> _matchingBrands = [];
  List<CategoryModel> _matchingCategories = [];

  List<String> get searchHistory => _searchHistory;
  String get query => _query;
  List<BrandModel> get matchingBrands => _matchingBrands;
  List<CategoryModel> get matchingCategories => _matchingCategories;

  void updateQuery(String value) {
    _query = value;
    _performSearch();
  }

  void addSearchHistory(String term) {
    if (term.trim().isEmpty) return;
    _searchHistory.remove(term);
    _searchHistory.insert(0, term);
    if (_searchHistory.length > 5) {
      _searchHistory.removeLast();
    }
    notifyListeners();
  }

  void clearHistory() {
    _searchHistory.clear();
    notifyListeners();
  }

  void deleteHistoryItem(String item) {
    _searchHistory.remove(item);
    notifyListeners();
  }

  void _performSearch() {
    if (_query.trim().isEmpty) {
      _matchingBrands = [];
      _matchingCategories = [];
      notifyListeners();
      return;
    }

    final lowerQuery = _query.toLowerCase();
    
    // Find matching brands
    _matchingBrands = _repository.getBrands().where((brand) {
      return brand.name.toLowerCase().contains(lowerQuery) ||
             brand.category.toLowerCase().contains(lowerQuery);
    }).toList();

    // Find matching categories
    _matchingCategories = _repository.getCategories().where((cat) {
      return cat.name.toLowerCase().contains(lowerQuery);
    }).toList();

    notifyListeners();
  }
}
