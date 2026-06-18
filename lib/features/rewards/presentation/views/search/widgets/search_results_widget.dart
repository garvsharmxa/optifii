import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/search_discovery_viewmodel.dart';
import '../../details/voucher_details_screen.dart';
import '../../marketplace/widgets/voucher_card_widget.dart';

class SearchResultsWidget extends StatelessWidget {
  const SearchResultsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SearchDiscoveryViewModel>();
    final query = viewModel.query;
    final brands = viewModel.matchingBrands;
    final categories = viewModel.matchingCategories;

    if (query.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    if (brands.isEmpty && categories.isEmpty) {
      return _buildEmptyState();
    }

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 40),
      children: [
        if (categories.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              "Matching Categories",
              style: GoogleFonts.outfit(
                color: Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...categories.map((cat) => ListTile(
                leading: const Icon(Icons.category, color: Colors.white70),
                title: Text(
                  cat.name,
                  style: GoogleFonts.outfit(color: Colors.white, fontSize: 15),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white30, size: 12),
                onTap: () {
                  // Simulate filtering search for category
                  viewModel.updateQuery(cat.name);
                },
              )),
          const Divider(color: Colors.white10),
        ],
        if (brands.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Text(
              "Matching Brands",
              style: GoogleFonts.outfit(
                color: Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.9,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: brands.length,
            itemBuilder: (context, index) {
              final brand = brands[index];
              return VoucherCardWidget(
                brand: brand,
                onTap: () {
                  // Add query to history
                  viewModel.addSearchHistory(brand.name);
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
        ]
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 48),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off,
                size: 64,
                color: Colors.white24,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "No results found",
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "We couldn't find any vouchers matching your search. Try another brand or category.",
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                color: Colors.white54,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
