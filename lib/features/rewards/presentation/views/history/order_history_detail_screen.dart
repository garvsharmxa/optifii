import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../data/models/order_model.dart';
import '../../theme/theme.dart';
import '../../viewmodels/voucher_post_purchase_viewmodel.dart';
import '../marketplace/widgets/voucher_card_widget.dart';

class OrderHistoryDetailScreen extends StatefulWidget {
  final OrderModel order;

  const OrderHistoryDetailScreen({
    super.key,
    required this.order,
  });

  @override
  State<OrderHistoryDetailScreen> createState() =>
      _OrderHistoryDetailScreenState();
}

class _OrderHistoryDetailScreenState extends State<OrderHistoryDetailScreen> {
  int _activeTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final voucher = order.voucher;

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

    final dateStr =
        "${order.purchaseDate.day.toString().padLeft(2, '0')}/${order.purchaseDate.month.toString().padLeft(2, '0')}/${order.purchaseDate.year}";
    final netVal = order.totalAmount.toInt();
    final discountVal = order.discountAmount.toInt();
    final finalVal = order.finalAmount.toInt();

    return Scaffold(
      body: Container(
        decoration: RewardsTheme.backgroundDecoration,
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Header
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                        child: const Icon(Icons.arrow_back,
                            color: Colors.white, size: 20),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Order Details",
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    const SizedBox(height: 8),

                    // Brand Card
                    Container(
                      height: 130,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: themeColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: themeColor.withOpacity(0.15),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Center(
                        child: BrandLogoPresenter(
                          brandId: voucher.brandId,
                          scale: 1.6,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Name + Rs Row
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
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text("Purchased on: $dateStr",
                                style: GoogleFonts.outfit(
                                    color: Colors.white38, fontSize: 12)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("Rs. $netVal",
                                style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text("Quantity: ${order.quantity}",
                                style: GoogleFonts.outfit(
                                    color: Colors.white38, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Gift recipient info
                    if (order.isGift && order.giftDetails != null) ...[
                      Text("Voucher Shared on",
                          style: GoogleFonts.outfit(
                              color: Colors.white60,
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w500)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Name",
                                    style: GoogleFonts.outfit(
                                        color: Colors.white38, fontSize: 12)),
                                const SizedBox(height: 4),
                                Text(order.giftDetails!.receiverName,
                                    style: GoogleFonts.outfit(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Phone",
                                    style: GoogleFonts.outfit(
                                        color: Colors.white38, fontSize: 12)),
                                const SizedBox(height: 4),
                                Text(order.giftDetails!.receiverPhone,
                                    style: GoogleFonts.outfit(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Email ID",
                              style: GoogleFonts.outfit(
                                  color: Colors.white38, fontSize: 12)),
                          const SizedBox(height: 4),
                          Text(order.giftDetails!.receiverEmail,
                              style: GoogleFonts.outfit(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Voucher Details (masked)
                    if (!order.isGift || order.giftDetails == null) ...[
                      Text("Voucher Details",
                          style: GoogleFonts.outfit(
                              color: Colors.white70,
                              fontSize: 14,
                              fontWeight: FontWeight.w500)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Card Number",
                                    style: GoogleFonts.outfit(
                                        color: Colors.white38, fontSize: 12)),
                                const SizedBox(height: 4),
                                Text(
                                    order.isRevealed
                                        ? order.cardNumber
                                        : "XXXX XXXX XXXX XXXX",
                                    style: GoogleFonts.outfit(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1.5)),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("PIN",
                                    style: GoogleFonts.outfit(
                                        color: Colors.white38, fontSize: 12)),
                                const SizedBox(height: 4),
                                Text(
                                    order.isRevealed
                                        ? order.pinCode
                                        : "XXXXX",
                                    style: GoogleFonts.outfit(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1.5)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Order Summary
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: RewardsTheme.cardDecoration(
                        color: const Color(0xFF1B0F3A),
                        borderColor: Colors.white.withOpacity(0.08),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Order Summary",
                              style: GoogleFonts.outfit(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(voucher.name,
                                  style: GoogleFonts.outfit(
                                      color: Colors.white70, fontSize: 14)),
                              Text("₹ $netVal",
                                  style: GoogleFonts.outfit(
                                      color: Colors.white, fontSize: 14)),
                            ],
                          ),
                          const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child:
                                  Divider(color: Colors.white12, height: 1)),
                          _buildRow("Net order Value", "₹ $netVal"),
                          const SizedBox(height: 8),
                          _buildRow(
                              "Total Discount value", "- ₹$discountVal",
                              valueColor: RewardsTheme.accentGreen),
                          const SizedBox(height: 8),
                          _buildRow("Total Order Value (Inc. all Taxes)",
                              "₹ $finalVal"),
                          const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child:
                                  Divider(color: Colors.white12, height: 1)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("You Paid",
                                  style: GoogleFonts.outfit(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              Row(
                                children: [
                                  Text("Rs. $netVal",
                                      style: GoogleFonts.outfit(
                                          color: Colors.white38,
                                          fontSize: 12,
                                          decoration:
                                              TextDecoration.lineThrough)),
                                  const SizedBox(width: 8),
                                  Text("Rs. $finalVal",
                                      style: GoogleFonts.outfit(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 12),
                            decoration: BoxDecoration(
                              color:
                                  RewardsTheme.accentGreen.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                "Woah! You just received a total discount of ₹$discountVal",
                                style: GoogleFonts.outfit(
                                    color: RewardsTheme.accentGreen,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Tabs
                    Row(
                      children: [
                        _buildTab("Term & Conditions", 0),
                        _buildTab("How to Redeem", 1),
                      ],
                    ),
                    Divider(
                        color: Colors.white.withOpacity(0.04), height: 1),
                    const SizedBox(height: 16),
                    _buildTabContent(voucher),

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

  Widget _buildRow(String label, String value,
      {Color valueColor = Colors.white70}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(label,
              style: GoogleFonts.outfit(color: Colors.white38, fontSize: 13)),
        ),
        Text(value,
            style: GoogleFonts.outfit(
                color: valueColor,
                fontSize: 13,
                fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildTab(String label, int index) {
    final isSelected = _activeTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeTabIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected
                    ? const Color(0xFF8A2387)
                    : Colors.transparent,
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

  Widget _buildTabContent(voucher) {
    final items = _activeTabIndex == 0
        ? voucher.termsAndConditions
        : voucher.redemptionSteps;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        items.length,
        (i) => Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Text(
            items[i],
            style: GoogleFonts.outfit(
                color: Colors.white70, fontSize: 13, height: 1.5),
          ),
        ),
      ),
    );
  }
}
