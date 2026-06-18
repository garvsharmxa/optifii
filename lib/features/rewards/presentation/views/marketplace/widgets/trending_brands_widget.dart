import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/rewards_marketplace_viewmodel.dart';
import '../../details/voucher_details_screen.dart';
import 'voucher_card_widget.dart';

class TrendingBrandsWidget extends StatelessWidget {
  final bool isTrending; // true for Trending, false for Popular

  const TrendingBrandsWidget({
    super.key,
    required this.isTrending,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RewardsMarketplaceViewModel>();
    final brands = isTrending ? viewModel.trendingBrands : viewModel.popularBrands;

    if (brands.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24.0),
        child: Center(
          child: Text(
            "No brands found in this category",
            style: TextStyle(color: Colors.white54, fontSize: 13),
          ),
        ),
      );
    }

    return SizedBox(
      height: 190,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: brands.length,
        itemBuilder: (context, index) {
          final brand = brands[index];
          return VoucherCardWidget(
            brand: brand,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VoucherDetailsScreen(brandId: brand.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
