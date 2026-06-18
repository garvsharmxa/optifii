import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RevealVoucherWidget extends StatefulWidget {
  final String cardNumber;
  final String pin;
  final String expiryDate;
  final bool isRevealed;
  final VoidCallback onReveal;

  const RevealVoucherWidget({
    super.key,
    required this.cardNumber,
    required this.pin,
    required this.expiryDate,
    required this.isRevealed,
    required this.onReveal,
  });

  @override
  State<RevealVoucherWidget> createState() => _RevealVoucherWidgetState();
}

class _RevealVoucherWidgetState extends State<RevealVoucherWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    if (widget.isRevealed) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant RevealVoucherWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRevealed && !oldWidget.isRevealed) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _maskCardNumber(String cardNumber) {
    return cardNumber.replaceAll(RegExp(r'\d'), 'X');
  }

  String _maskPin(String pin) {
    return pin.replaceAll(RegExp(r'\d'), 'X');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Voucher Details",
          style: GoogleFonts.outfit(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),

        // Card Number & PIN display
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Card Number",
                    style: GoogleFonts.outfit(color: Colors.white38, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Text(
                        widget.isRevealed
                            ? widget.cardNumber
                            : _maskCardNumber(widget.cardNumber),
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.5,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "PIN",
                    style: GoogleFonts.outfit(color: Colors.white38, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Text(
                        widget.isRevealed
                            ? widget.pin
                            : _maskPin(widget.pin),
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.5,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Reveal / Copy button
        if (!widget.isRevealed)
          Center(
            child: ElevatedButton.icon(
              onPressed: widget.onReveal,
              icon: const Icon(Icons.visibility_outlined, size: 18),
              label: Text(
                "Tap to Reveal",
                style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5B11A8),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                elevation: 0,
              ),
            ),
          )
        else
          ScaleTransition(
            scale: _scaleAnimation,
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCopyButton(context, "Copy Card No.", widget.cardNumber),
                  const SizedBox(width: 12),
                  _buildCopyButton(context, "Copy PIN", widget.pin),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCopyButton(BuildContext context, String label, String value) {
    return OutlinedButton.icon(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("$label copied to clipboard"),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      icon: const Icon(Icons.copy, size: 14),
      label: Text(
        label,
        style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w600),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white70,
        side: const BorderSide(color: Colors.white24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}
