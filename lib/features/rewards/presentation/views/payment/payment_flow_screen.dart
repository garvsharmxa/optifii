import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../data/models/voucher_model.dart';
import '../../../data/models/gift_details_model.dart';
import '../../theme/theme.dart';
import '../../viewmodels/payment_viewmodel.dart';
import 'payment_success_screen.dart';

class PaymentFlowScreen extends StatefulWidget {
  final VoucherModel voucher;
  final int quantity;
  final double netValue;
  final double discountValue;
  final double finalPayable;
  final bool isGift;
  final GiftDetailsModel? giftDetails;

  const PaymentFlowScreen({
    super.key,
    required this.voucher,
    required this.quantity,
    required this.netValue,
    required this.discountValue,
    required this.finalPayable,
    required this.isGift,
    this.giftDetails,
  });

  @override
  State<PaymentFlowScreen> createState() => _PaymentFlowScreenState();
}

class _PaymentFlowScreenState extends State<PaymentFlowScreen> {
  @override
  void initState() {
    super.initState();
    _startPaymentSimulation();
  }

  Future<void> _startPaymentSimulation() async {
    final paymentVm = context.read<PaymentViewModel>();
    final success = await paymentVm.processPayment(
      voucher: widget.voucher,
      quantity: widget.quantity,
      totalAmount: widget.netValue,
      discountAmount: widget.discountValue,
      finalAmount: widget.finalPayable,
      isGift: widget.isGift,
      giftDetails: widget.giftDetails,
    );

    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const PaymentSuccessScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: RewardsTheme.backgroundDecoration,
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 64,
                    height: 64,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3.0,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    "Processing Payment...",
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Connecting securely with Razorpay gateway.\nDo not close this page or lock your screen.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      color: Colors.white54,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 48),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.lock_outline, color: Colors.white30, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        "PCI-DSS compliant connection",
                        style: GoogleFonts.outfit(color: Colors.white30, fontSize: 11),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
