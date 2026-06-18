import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../theme/theme.dart';
import '../../../viewmodels/voucher_details_viewmodel.dart';

class PricingCalculationWidget extends StatelessWidget {
  const PricingCalculationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<VoucherDetailsViewModel>();
    
    // Hide if no amount is selected
    if (viewModel.activeAmount == 0.0) {
      return const SizedBox.shrink();
    }

    final netVal = viewModel.netOrderValue.toInt();
    final discountVal = viewModel.discountValue.toInt();
    final finalVal = viewModel.finalPayableAmount.toInt();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2E1557), Color(0xFF160A2A)],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "You Saved Rs. $discountVal",
                style: GoogleFonts.outfit(
                  color: RewardsTheme.accentGreen,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                "Rs. $netVal",
                style: GoogleFonts.outfit(
                  color: Colors.white38,
                  fontSize: 14,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                "Rs. $finalVal",
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
