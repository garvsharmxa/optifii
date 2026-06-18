import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../theme/theme.dart';
import '../../viewmodels/order_summary_viewmodel.dart';
import '../../viewmodels/payment_viewmodel.dart';
import '../marketplace/widgets/voucher_card_widget.dart';
import '../payment/payment_flow_screen.dart';

class OrderSummaryScreen extends StatefulWidget {
  const OrderSummaryScreen({super.key});

  @override
  State<OrderSummaryScreen> createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  int _activeTabIndex = 0; // 0 for T&C, 1 for How to Redeem

  Color _getThemeColor(String hexStr) {
    try {
      final hex = hexStr.replaceAll('#', '');
      return Color(int.parse(hex, radix: 16));
    } catch (_) {
      return RewardsTheme.cardBackground;
    }
  }

  @override
  Widget build(BuildContext context) {
    final summaryVm = context.watch<OrderSummaryViewModel>();
    final voucher = summaryVm.voucher;

    if (voucher == null) {
      return Scaffold(
        body: Container(
          decoration: RewardsTheme.backgroundDecoration,
          child: const Center(
            child: Text("No checkout items found", style: TextStyle(color: Colors.white)),
          ),
        ),
      );
    }

    final netVal = summaryVm.netValue.toInt();
    final discountVal = summaryVm.discountValue.toInt();
    final finalVal = summaryVm.finalPayableAmount.toInt();

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
                    const SizedBox(width: 12),
                    Text(
                      "Rewards",
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Scrollable Body
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  children: [
                    const SizedBox(height: 8),

                    // Order Summary Box Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: RewardsTheme.cardDecoration(
                        color: const Color(0xFF1B0F3A),
                        borderColor: Colors.white.withOpacity(0.08),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Order Summary",
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${voucher.name} (${summaryVm.quantity}x)",
                                style: GoogleFonts.outfit(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                "₹ ${summaryVm.denominationAmount.toInt() * summaryVm.quantity}",
                                style: GoogleFonts.outfit(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 14.0),
                            child: Divider(color: Colors.white12, height: 1),
                          ),

                          // Calculation list
                          _buildCostRow("Net order Value", "₹ $netVal"),
                          const SizedBox(height: 10),
                          _buildCostRow("Total Discount value", "- ₹ $discountVal", valueColor: RewardsTheme.accentGreen),
                          const SizedBox(height: 10),
                          _buildCostRow("Total Order Value (Inc. all Taxes)", "₹ $finalVal"),

                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 14.0),
                            child: Divider(color: Colors.white12, height: 1),
                          ),

                          // You Pay row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "You Pay",
                                style: GoogleFonts.outfit(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Rs. $netVal",
                                    style: GoogleFonts.outfit(
                                      color: Colors.white38,
                                      fontSize: 12,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Rs. $finalVal",
                                    style: GoogleFonts.outfit(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Woah Savings Banner
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                            decoration: BoxDecoration(
                              color: RewardsTheme.accentGreen.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                "Woah! You just received a total discount of ₹$discountVal",
                                style: GoogleFonts.outfit(
                                  color: RewardsTheme.accentGreen,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Safe secure badge
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.security, color: Colors.white38, size: 14),
                              const SizedBox(width: 6),
                              Text(
                                "Safe & secure payment",
                                style: GoogleFonts.outfit(color: Colors.white38, fontSize: 11),
                              ),
                              const SizedBox(width: 8),
                              // Razorpay logo mock
                              Text(
                                "Razorpay",
                                style: GoogleFonts.outfit(
                                  color: const Color(0xFF00A3FF),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Proceed to pay button
                    ElevatedButton(
                      onPressed: () => _triggerPayment(context, summaryVm),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                      ),
                      child: Text(
                        "Proceed to Pay",
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Lower Voucher Card thumbnail block
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E5AF1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: BrandLogoPresenter(brandId: "BRD-FLIPKART", scale: 0.8),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  voucher.name,
                                  style: GoogleFonts.outfit(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Quantity: ${summaryVm.quantity}",
                                  style: GoogleFonts.outfit(color: Colors.white38, fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Rs. $netVal",
                                style: GoogleFonts.outfit(color: Colors.white38, fontSize: 11, decoration: TextDecoration.lineThrough),
                              ),
                              Text(
                                "Rs. $finalVal",
                                style: GoogleFonts.outfit(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Tabs (T&C vs How to Redeem)
                    Row(
                      children: [
                        _buildTabButton("Term & Conditions", 0),
                        _buildTabButton("How to Redeem", 1),
                      ],
                    ),
                    const Divider(color: Colors.white12, height: 1),

                    const SizedBox(height: 16),

                    // Active Tab Text Content
                    _buildActiveTabContent(voucher),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCostRow(String title, String val, {Color valueColor = Colors.white70}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.outfit(color: Colors.white38, fontSize: 13),
        ),
        Text(
          val,
          style: GoogleFonts.outfit(
            color: valueColor,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTabButton(String label, int index) {
    final isSelected = _activeTabIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _activeTabIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? const Color(0xFF8A2387) : Colors.transparent,
                width: 2.0,
              ),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.outfit(
                color: isSelected ? Colors.white : Colors.white38,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveTabContent(voucher) {
    final List<String> items = _activeTabIndex == 0
        ? voucher.termsAndConditions
        : voucher.redemptionSteps;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        items.length,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${index + 1}. ",
                style: GoogleFonts.outfit(color: Colors.white54, fontSize: 13),
              ),
              Expanded(
                child: Text(
                  items[index],
                  style: GoogleFonts.outfit(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _triggerPayment(BuildContext context, OrderSummaryViewModel summaryVm) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentFlowScreen(
          voucher: summaryVm.voucher!,
          quantity: summaryVm.quantity,
          netValue: summaryVm.netValue,
          discountValue: summaryVm.discountValue,
          finalPayable: summaryVm.finalPayableAmount,
          isGift: summaryVm.isGift,
          giftDetails: summaryVm.giftDetails,
        ),
      ),
    );
  }
}
