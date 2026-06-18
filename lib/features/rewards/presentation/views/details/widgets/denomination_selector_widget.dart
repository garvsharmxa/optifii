import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/voucher_details_viewmodel.dart';

class DenominationSelectorWidget extends StatefulWidget {
  const DenominationSelectorWidget({super.key});

  @override
  State<DenominationSelectorWidget> createState() => _DenominationSelectorWidgetState();
}

class _DenominationSelectorWidgetState extends State<DenominationSelectorWidget> {
  final TextEditingController _customController = TextEditingController();

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<VoucherDetailsViewModel>();
    final voucher = viewModel.voucher;

    if (voucher == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Enter Denomination",
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),

        // Grid of predefined denominations
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 2.1,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: voucher.predefinedDenominations.length,
          itemBuilder: (context, index) {
            final value = voucher.predefinedDenominations[index];
            final isSelected = viewModel.selectedDenomination == value;

            return InkWell(
              onTap: () {
                _customController.clear();
                viewModel.selectDenomination(value);
              },
              borderRadius: BorderRadius.circular(24),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isSelected ? Colors.white : Colors.white12,
                    width: 1.0,
                  ),
                ),
                child: Center(
                  child: Text(
                    value.toInt().toString(),
                    style: GoogleFonts.outfit(
                      color: isSelected ? Colors.black : Colors.white70,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 16),

        // Custom amount input row
        Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: viewModel.errorMessage.isNotEmpty
                  ? Colors.red.withOpacity(0.5)
                  : Colors.white12,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _customController,
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.outfit(color: Colors.white, fontSize: 14),
                  onChanged: (val) {
                    final amount = double.tryParse(val);
                    if (amount != null) {
                      viewModel.setCustomAmount(amount);
                    } else if (val.isEmpty) {
                      viewModel.clearCustomAmount();
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "Enter your amount",
                    hintStyle: GoogleFonts.outfit(color: Colors.white24, fontSize: 14),
                    border: InputBorder.none,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (viewModel.customAmount != null && viewModel.errorMessage.isEmpty) {
                    FocusScope.of(context).unfocus();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Custom amount ₹${viewModel.customAmount!.toInt()} selected"),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  }
                },
                child: Text(
                  "Add",
                  style: GoogleFonts.outfit(
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        // Helper limits text / error message
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            viewModel.errorMessage.isNotEmpty
                ? viewModel.errorMessage
                : "Min ₹ ${voucher.minCustomAmount.toInt()}. Max ₹ ${voucher.maxCustomAmount.toInt()}.",
            style: GoogleFonts.outfit(
              color: viewModel.errorMessage.isNotEmpty ? Colors.red : Colors.white38,
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }
}
