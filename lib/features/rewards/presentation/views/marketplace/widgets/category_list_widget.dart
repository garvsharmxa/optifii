import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/theme.dart';
import '../../../viewmodels/rewards_marketplace_viewmodel.dart';

class CategoryListWidget extends StatelessWidget {
  const CategoryListWidget({super.key});

  IconData _getIconData(String name) {
    switch (name) {
      case 'bolt':
        return Icons.bolt;
      case 'movie':
        return Icons.movie_outlined;
      case 'shopping_bag':
        return Icons.shopping_bag_outlined;
      case 'devices':
        return Icons.devices_other_outlined;
      case 'restaurant':
        return Icons.restaurant_outlined;
      default:
        return Icons.category_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RewardsMarketplaceViewModel>();
    final categories = viewModel.categories;

    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = viewModel.selectedCategoryId == category.id;

          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
              onTap: () => viewModel.selectCategory(category.id),
              borderRadius: BorderRadius.circular(24),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withOpacity(0.12)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isSelected ? Colors.white : Colors.white24,
                    width: 1.0,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getIconData(category.iconName),
                      color: isSelected ? Colors.white : Colors.white70,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      category.name,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white70,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
