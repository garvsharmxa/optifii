import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../data/models/voucher_model.dart';
import '../../theme/theme.dart';
import '../../viewmodels/gift_flow_viewmodel.dart';
import '../../viewmodels/order_summary_viewmodel.dart';
import '../order_summary/order_summary_screen.dart';
import 'widgets/gift_theme_selector.dart';
import 'widgets/gift_preview_dialog.dart';

class SendGiftScreen extends StatefulWidget {
  final VoucherModel voucher;
  final int quantity;
  final double amount;

  const SendGiftScreen({
    super.key,
    required this.voucher,
    required this.quantity,
    required this.amount,
  });

  @override
  State<SendGiftScreen> createState() => _SendGiftScreenState();
}

class _SendGiftScreenState extends State<SendGiftScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<GiftFlowViewModel>();
      vm.reset();
      vm.setGifting(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<GiftFlowViewModel>();

    return Scaffold(
      body: Container(
        decoration: RewardsTheme.backgroundDecoration,
        child: SafeArea(
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
                      "Gift Voucher Info",
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Form Scrollable Container
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    children: [
                      // Subtitle Info
                      Text(
                        "Gifting details for ${widget.voucher.name}",
                        style: GoogleFonts.outfit(color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(height: 20),

                      // Name Field
                      _buildTextField(
                        label: "Receiver Name",
                        hint: "Enter receiver's name",
                        icon: Icons.person_outline,
                        onChanged: viewModel.updateReceiverName,
                        validator: (val) => val == null || val.isEmpty ? "Name is required" : null,
                      ),
                      const SizedBox(height: 16),

                      // Phone Field
                      _buildTextField(
                        label: "Phone Number",
                        hint: "Enter 10-digit mobile number",
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        onChanged: viewModel.updateReceiverPhone,
                        validator: (val) => val == null || val.length < 10 ? "Enter valid phone number" : null,
                      ),
                      const SizedBox(height: 16),

                      // Email Field
                      _buildTextField(
                        label: "Email ID",
                        hint: "Enter receiver's email address",
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: viewModel.updateReceiverEmail,
                        validator: (val) => val == null || !val.contains("@") ? "Enter valid email address" : null,
                      ),
                      const SizedBox(height: 16),

                      // Custom Message Field with counter
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Custom Message (Optional)",
                                style: GoogleFonts.outfit(color: Colors.white70, fontSize: 13),
                              ),
                              Text(
                                "${viewModel.customMessage.length} / 200",
                                style: GoogleFonts.outfit(color: Colors.white38, fontSize: 11),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.04),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white12),
                            ),
                            child: TextFormField(
                              maxLength: 200,
                              maxLines: 3,
                              style: GoogleFonts.outfit(color: Colors.white, fontSize: 14),
                              onChanged: viewModel.updateCustomMessage,
                              decoration: InputDecoration(
                                hintText: "Write a message for your recipient...",
                                hintStyle: GoogleFonts.outfit(color: Colors.white24, fontSize: 13),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(12),
                                counterText: "", // Hide default counter
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Theme Selector Widget
                      const GiftThemeSelector(),

                      const SizedBox(height: 24),

                      // Preview Button
                      OutlinedButton.icon(
                        onPressed: () => _openPreview(context, viewModel),
                        icon: const Icon(Icons.remove_red_eye_outlined, size: 18),
                        label: Text(
                          "Preview Gift Card",
                          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white30),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),

              // Persistent Checkout Button
              Container(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 28),
                color: const Color(0xFF0C051B),
                child: ElevatedButton(
                  onPressed: () => _proceedToSummary(context, viewModel),
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
                      "Proceed to Order Summary",
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

  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
    required Function(String) onChanged,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(color: Colors.white70, fontSize: 13),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white12),
          ),
          child: TextFormField(
            keyboardType: keyboardType,
            style: GoogleFonts.outfit(color: Colors.white, fontSize: 14),
            onChanged: onChanged,
            validator: validator,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.outfit(color: Colors.white24, fontSize: 13),
              prefixIcon: Icon(icon, color: Colors.white38, size: 20),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ],
    );
  }

  void _openPreview(BuildContext context, GiftFlowViewModel giftVm) {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => GiftPreviewDialog(
          receiverName: giftVm.receiverName,
          message: giftVm.customMessage,
          themeIndex: giftVm.selectedThemeIndex,
          brandId: widget.voucher.brandId,
          amount: widget.amount,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please correct the form fields before previewing"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  void _proceedToSummary(BuildContext context, GiftFlowViewModel giftVm) {
    if (_formKey.currentState!.validate()) {
      // Setup Checkout data
      context.read<OrderSummaryViewModel>().setupSummary(
            voucher: widget.voucher,
            quantity: widget.quantity,
            denominationAmount: widget.amount,
            isGift: true,
            giftDetails: giftVm.getGiftDetails(),
          );

      // Navigate to Summary Screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const OrderSummaryScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please complete the form fields first"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }
}
