import 'package:flutter/material.dart';
import '../../data/models/brand_model.dart';
import '../../data/models/category_model.dart';
import '../../data/repositories/rewards_repository.dart';

class RewardsMarketplaceViewModel extends ChangeNotifier {
  final RewardsRepository _repository = RewardsRepository();

  List<CategoryModel> _categories = [];
  List<BrandModel> _brands = [];
  String? _selectedCategoryId;
  bool _isLoading = false;

  List<CategoryModel> get categories => _categories;
  List<BrandModel> get brands => _brands;
  String? get selectedCategoryId => _selectedCategoryId;
  bool get isLoading => _isLoading;

  RewardsMarketplaceViewModel() {
    loadMarketplaceData();
  }

  void loadMarketplaceData() {
    _isLoading = true;
    notifyListeners();

    _categories = _repository.getCategories();
    _brands = _repository.getBrands();

    _isLoading = false;
    notifyListeners();
  }

  void selectCategory(String? categoryId) {
    if (_selectedCategoryId == categoryId) {
      _selectedCategoryId = null; // Toggle off filter
    } else {
      _selectedCategoryId = categoryId;
    }
    notifyListeners();
  }

  List<BrandModel> get filteredBrands {
    if (_selectedCategoryId == null) {
      return _brands;
    }
    return _brands.where((b) => b.category == _selectedCategoryId).toList();
  }

  List<BrandModel> get trendingBrands {
    // Return a subset or sorted list as trending
    return filteredBrands.take(3).toList();
  }

  List<BrandModel> get popularBrands {
    // Return popular brands
    return filteredBrands.reversed.toList();
  }
}
