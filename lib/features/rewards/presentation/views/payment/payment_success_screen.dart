import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../theme/theme.dart';
import '../../viewmodels/payment_viewmodel.dart';
import '../post_purchase/voucher_post_purchase_screen.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final paymentVm = context.watch<PaymentViewModel>();
    final order = paymentVm.lastCreatedOrder;
    final voucherName = order?.voucher.name ?? "Voucher";

    return Scaffold(
      body: Container(
        decoration: RewardsTheme.backgroundDecoration,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header close arrow
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: InkWell(
                  onTap: () {
                    // Navigate back to marketplace home
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
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
              ),

              // Success Illustration & Message
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Dynamic Programmatic Success Checkmark Illustration matching Image 3
                        SizedBox(
                          width: 200,
                          height: 200,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Particle Dots (celebration visual)
                              ..._buildParticles(),
                              
                              // Main Checkmark Circle
                              Container(
                                width: 84,
                                height: 84,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.08),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white24, width: 1.5),
                                ),
                              ),
                              Container(
                                width: 64,
                                height: 64,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.check,
                                    color: Color(0xFF160A2B),
                                    size: 36,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        Text(
                          "Purchase Successful",
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          "Yahoo! You have successfully purchased an $voucherName",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.outfit(
                            color: Colors.white70,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Sticky "View Voucher" Action Button
              Container(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 28),
                color: const Color(0xFF0C051B),
                child: ElevatedButton(
                  onPressed: () {
                    if (order != null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VoucherPostPurchaseScreen(order: order),
                        ),
                      );
                    } else {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                  ),
                  child: Center(
                    child: Text(
                      "View Voucher",
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Generate particle dots coordinates around checkmark
  List<Widget> _buildParticles() {
    final List<Map<String, double>> coordinates = [
      {'top': 20, 'left': 40, 'size': 6},
      {'top': 30, 'right': 30, 'size': 14},
      {'bottom': 36, 'left': 26, 'size': 10},
      {'bottom': 42, 'right': 42, 'size': 6},
      {'top': 80, 'left': 16, 'size': 8},
      {'top': 94, 'right': 14, 'size': 4},
      {'bottom': 14, 'left': 72, 'size': 6},
    ];

    return coordinates.map((coord) {
      return Positioned(
        top: coord['top'],
        bottom: coord['bottom'],
        left: coord['left'],
        right: coord['right'],
        child: Container(
          width: coord['size'],
          height: coord['size'],
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      );
    }).toList();
  }
}
