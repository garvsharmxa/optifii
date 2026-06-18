import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../theme/theme.dart';
import '../../viewmodels/voucher_details_viewmodel.dart';
import '../../viewmodels/gift_flow_viewmodel.dart';
import '../../viewmodels/order_summary_viewmodel.dart';
import '../marketplace/widgets/voucher_card_widget.dart';
import '../order_summary/order_summary_screen.dart';
import '../gift/send_gift_screen.dart';
import 'widgets/denomination_selector_widget.dart';
import 'widgets/pricing_calculation_widget.dart';

class VoucherDetailsScreen extends StatefulWidget {
  final String brandId;

  const VoucherDetailsScreen({
    super.key,
    required this.brandId,
  });

  @override
  State<VoucherDetailsScreen> createState() => _VoucherDetailsScreenState();
}

class _VoucherDetailsScreenState extends State<VoucherDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VoucherDetailsViewModel>().initialize(widget.brandId);
      context.read<GiftFlowViewModel>().reset();
    });
  }

  Color _getThemeColor(String? colorHex) {
    if (colorHex == null) return RewardsTheme.cardBackground;
    try {
      final hex = colorHex.replaceAll('#', '');
      return Color(int.parse(hex, radix: 16));
    } catch (_) {
      return RewardsTheme.cardBackground;
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<VoucherDetailsViewModel>();
    final brand = viewModel.brand;
    final voucher = viewModel.voucher;

    if (brand == null || voucher == null) {
      return Scaffold(
        body: Container(
          decoration: RewardsTheme.backgroundDecoration,
          child: const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
      );
    }

    final themeColor = _getThemeColor(brand.themeColorHex);

    return Scaffold(
      body: Container(
        decoration: RewardsTheme.backgroundDecoration,
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.06),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    Text(
                      "Rewards",
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 36), // Balanced spacing
                  ],
                ),
              ),

              // Scrollable screen body
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  children: [
                    const SizedBox(height: 8),
                    // Voucher Title and Discount row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              voucher.name,
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Validity: ${voucher.validityMonths} months",
                              style: GoogleFonts.outfit(
                                color: Colors.white38,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Discount",
                              style: GoogleFonts.outfit(
                                color: Colors.white38,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              "${voucher.discountPercentage.toInt()}%",
                              style: GoogleFonts.outfit(
                                color: RewardsTheme.accentGreen,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Main card visual representation
                    Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: themeColor,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: themeColor.withOpacity(0.15),
                            blurRadius: 20,
                            spreadRadius: 2,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Center(
                        child: BrandLogoPresenter(
                          brandId: brand.id,
                          scale: 2.2,
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Denominations selectors
                    const DenominationSelectorWidget(),

                    const SizedBox(height: 20),

                    // Quantity incrementer row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Quantity:",
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Row(
                          children: [
                            // Minus button
                            InkWell(
                              onTap: viewModel.decrementQuantity,
                              borderRadius: BorderRadius.circular(24),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white24),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.remove, color: Colors.white70, size: 18),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              viewModel.quantity.toString(),
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Plus button
                            InkWell(
                              onTap: viewModel.incrementQuantity,
                              borderRadius: BorderRadius.circular(24),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white24),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.add, color: Colors.white, size: 18),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),

              // Bottom sticky pricing overlay and Action buttons
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const PricingCalculationWidget(),
                  Container(
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 28),
                    color: const Color(0xFF0C051B),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: viewModel.activeAmount == 0.0
                                ? null
                                : () => _navigateToCheckout(context, viewModel, false),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              disabledBackgroundColor: Colors.white12,
                              disabledForegroundColor: Colors.white30,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(26),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              elevation: 0,
                            ),
                            child: Text(
                              "Buy Now",
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: viewModel.activeAmount == 0.0
                                ? null
                                : () => _navigateToCheckout(context, viewModel, true),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: BorderSide(
                                color: viewModel.activeAmount == 0.0
                                    ? Colors.white12
                                    : Colors.white30,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(26),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: Text(
                              "Send a Gift",
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToCheckout(
    BuildContext context,
    VoucherDetailsViewModel detailsVm,
    bool isGifting,
  ) {
    if (isGifting) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SendGiftScreen(
            voucher: detailsVm.voucher!,
            quantity: detailsVm.quantity,
            amount: detailsVm.activeAmount,
          ),
        ),
      );
    } else {
      // Direct checkout
      context.read<OrderSummaryViewModel>().setupSummary(
            voucher: detailsVm.voucher!,
            quantity: detailsVm.quantity,
            denominationAmount: detailsVm.activeAmount,
            isGift: false,
          );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const OrderSummaryScreen(),
        ),
      );
    }
  }
}
