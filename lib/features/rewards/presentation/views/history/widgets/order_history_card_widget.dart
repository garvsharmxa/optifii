import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../data/models/order_model.dart';
import '../../../theme/theme.dart';
import '../../marketplace/widgets/voucher_card_widget.dart';

class OrderHistoryCardWidget extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onTap;

  const OrderHistoryCardWidget({
    super.key,
    required this.order,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final voucher = order.voucher;
    final dateStr =
        "${order.purchaseDate.day.toString().padLeft(2, '0')}/${order.purchaseDate.month.toString().padLeft(2, '0')}/${order.purchaseDate.year}";

    // Resolve brand colour
    Color themeColor;
    switch (voucher.brandId) {
      case 'BRD-FLIPKART':
        themeColor = const Color(0xFF1E5AF1);
        break;
      case 'BRD-SWIGGY':
        themeColor = const Color(0xFFFF5200);
        break;
      case 'BRD-LIFESTYLE':
        themeColor = Colors.white;
        break;
      case 'BRD-AMAZON':
        themeColor = const Color(0xFF232F3E);
        break;
      case 'BRD-BIGBASKET':
        themeColor = const Color(0xFF84C225);
        break;
      default:
        themeColor = const Color(0xFF1E5AF1);
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.white.withOpacity(0.05)),
          ),
        ),
        child: Row(
          children: [
            // Brand logo thumbnail
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: themeColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: BrandLogoPresenter(
                  brandId: voucher.brandId,
                  scale: 0.7,
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Name + Date
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    voucher.name.replaceAll(" Voucher", ""),
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dateStr,
                    style: GoogleFonts.outfit(
                      color: Colors.white38,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            // Amount
            Text(
              "Rs. ${order.totalAmount.toInt()}",
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
