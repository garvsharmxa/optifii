import '../models/brand_model.dart';
import '../models/category_model.dart';

class RewardsRemoteDataSource {
  Future<List<BrandModel>> fetchBrands() async {
    // Simulating API latency
    await Future.delayed(const Duration(milliseconds: 600));
    return [];
  }

  Future<List<CategoryModel>> fetchCategories() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return [];
  }
}
