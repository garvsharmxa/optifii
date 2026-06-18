import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../data/models/brand_model.dart';
import '../../../theme/theme.dart';

class VoucherCardWidget extends StatelessWidget {
  final BrandModel brand;
  final VoidCallback onTap;

  const VoucherCardWidget({
    super.key,
    required this.brand,
    required this.onTap,
  });

  Color _getThemeColor() {
    try {
      final hex = brand.themeColorHex.replaceAll('#', '');
      return Color(int.parse(hex, radix: 16));
    } catch (_) {
      return RewardsTheme.cardBackground;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = _getThemeColor();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF130926),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Inner brand-colored logo container
            AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                decoration: BoxDecoration(
                  color: themeColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: BrandLogoPresenter(brandId: brand.id, scale: 0.95),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Text Details Block
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          brand.name,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "${brand.discountPercentage.toInt()}% off",
                          style: GoogleFonts.outfit(
                            color: RewardsTheme.accentGreen,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white54,
                    size: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Brand Logo Widget Helper to draw high-fidelity logos from network URLs
class BrandLogoPresenter extends StatelessWidget {
  final String brandId;
  final double scale;

  const BrandLogoPresenter({
    super.key,
    required this.brandId,
    this.scale = 1.0,
  });

  static const Map<String, String> _logoUrls = {
    'BRD-FLIPKART': 'https://www.freelogovectors.net/wp-content/uploads/2025/07/flipkart-logo-icon-freelogovectors.net_.png',
    'BRD-SWIGGY': 'https://images.seeklogo.com/logo-png/63/1/swiggy-logo-png_seeklogo-634077.png',
    'BRD-MAKEMYTRIP': 'https://upload.wikimedia.org/wikipedia/commons/6/61/Makemytrip_logo.svg',
    'BRD-AMAZON': 'https://i0.wp.com/magzoid.com/wp-content/uploads/2025/05/amazon-rebrand-2025_dezeen_2364_col_1-1.webp?fit=2364%2C1330&ssl=1',
    'BRD-BIGBASKET': 'https://upload.wikimedia.org/wikipedia/en/thumb/1/1d/BigBasket_Logo.svg/1280px-BigBasket_Logo.svg.png',
    'BRD-LIFESTYLE': 'https://upload.wikimedia.org/wikipedia/commons/c/c2/Lifestyle_Stores_-_New.jpg',
  };

  @override
  Widget build(BuildContext context) {
    final url = _logoUrls[brandId];
    if (url != null) {
      final isSvg = url.toLowerCase().endsWith('.svg');
      return SizedBox(
        width: 110 * scale,
        height: 110 * scale,
        child: Padding(
          padding: EdgeInsets.all(0),
          child: Center(
            child: isSvg
                ? SvgPicture.network(
                    url,
                    fit: BoxFit.contain,
                    placeholderBuilder: (BuildContext context) => const Center(
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 1.5),
                      ),
                    ),
                  )
                : CachedNetworkImage(
                    imageUrl: url,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const Center(
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 1.5),
                      ),
                    ),
                    errorWidget: (context, url, error) => const Icon(Icons.broken_image, size: 20),
                  ),
          ),
        ),
      );
    }

    // Fallback Icon
    return Icon(
      Icons.card_membership_outlined,
      color: Colors.white54,
      size: 60 * scale,
    );
  }
}
