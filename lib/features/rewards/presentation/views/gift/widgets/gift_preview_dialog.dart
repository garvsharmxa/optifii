import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'gift_theme_selector.dart';
import '../../marketplace/widgets/voucher_card_widget.dart';

const _kCardRadius = 28.0;
const _kAnimDuration = Duration(milliseconds: 500);

class GiftPreviewDialog extends StatefulWidget {
  final String receiverName;
  final String message;
  final int themeIndex;
  final String brandId;
  final double amount;

  const GiftPreviewDialog({
    super.key,
    required this.receiverName,
    required this.message,
    required this.themeIndex,
    required this.brandId,
    required this.amount,
  });

  @override
  State<GiftPreviewDialog> createState() => _GiftPreviewDialogState();
}

class _GiftPreviewDialogState extends State<GiftPreviewDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animCtrl;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: _kAnimDuration);
    _scale = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutBack);
    _opacity = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: FadeTransition(
        opacity: _opacity,
        child: ScaleTransition(
          scale: _scale,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildCard(),
              const SizedBox(height: 24),
              _buildCloseButton(),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Card
  // ---------------------------------------------------------------------------

  Widget _buildCard() {
    final gradient = GiftThemeSelector.themeGradients[widget.themeIndex];
    final start = gradient.colors.first;
    final end = gradient.colors.last;
    final mid = Color.lerp(start, end, 0.5)!;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [start, mid, end],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(_kCardRadius),
            boxShadow: [
              BoxShadow(
                color: end.withOpacity(0.35),
                blurRadius: 32,
                offset: const Offset(0, 14),
                spreadRadius: -4,
              ),
              BoxShadow(
                color: start.withOpacity(0.2),
                blurRadius: 60,
                offset: const Offset(0, 4),
                spreadRadius: -8,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(_kCardRadius),
            child: Stack(
              children: [
                // background decorations
                _buildBokehCircle(top: -40, right: -30, size: 140, alpha: 0.06),
                _buildBokehCircle(bottom: -50, left: -20, size: 180, alpha: 0.04),
                _buildBokehCircle(top: 60, left: -40, size: 100, alpha: 0.05),
                _buildShimmerStripe(),

                // foreground content
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 28),
                      _buildBrandLogo(),
                      const SizedBox(height: 28),
                      _buildDivider(),
                      const SizedBox(height: 20),
                      _buildGreeting(),
                      const SizedBox(height: 18),
                      _buildFooter(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // floating badge
        _buildPreviewBadge(),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Header – "GIFT VOUCHER" label + amount pill
  // ---------------------------------------------------------------------------

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // label with accent bar
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'GIFT VOUCHER',
              style: GoogleFonts.outfit(
                color: Colors.white70,
                fontSize: 10,
                letterSpacing: 3,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 28,
              height: 2.5,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),

        // amount pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: _frostedDecoration(radius: 20),
          child: Text(
            '₹${widget.amount.toInt()}',
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Brand logo inside a frosted container
  // ---------------------------------------------------------------------------

  Widget _buildBrandLogo() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.white.withOpacity(0.18),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: BrandLogoPresenter(brandId: widget.brandId, scale: 0.7),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Decorative divider with gift icon
  // ---------------------------------------------------------------------------

  Widget _buildDivider() {
    final line = Expanded(
      child: Container(
        height: 0.8,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.0),
              Colors.white.withOpacity(0.3),
              Colors.white.withOpacity(0.0),
            ],
          ),
        ),
      ),
    );

    return Row(
      children: [
        line,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Icon(
            Icons.card_giftcard_rounded,
            color: Colors.white.withOpacity(0.5),
            size: 16,
          ),
        ),
        line,
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Greeting section
  // ---------------------------------------------------------------------------

  Widget _buildGreeting() {
    final displayMsg = widget.message.isNotEmpty
        ? widget.message
        : 'Hope you enjoy this special gift voucher!';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hey ${widget.receiverName},',
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          displayMsg,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.outfit(
            color: Colors.white.withOpacity(0.8),
            fontSize: 13,
            fontStyle: FontStyle.italic,
            height: 1.5,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Footer – sender info + branding
  // ---------------------------------------------------------------------------

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'From: OptiFii User',
              style: GoogleFonts.outfit(
                color: Colors.white.withOpacity(0.55),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Text(
          'optifii',
          style: GoogleFonts.outfit(
            color: Colors.white.withOpacity(0.25),
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // "PREVIEW" floating badge
  // ---------------------------------------------------------------------------

  Widget _buildPreviewBadge() {
    return Positioned(
      top: -6,
      left: 24,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.auto_awesome, size: 12, color: Color(0xFFFF9800)),
            const SizedBox(width: 4),
            Text(
              'PREVIEW',
              style: GoogleFonts.outfit(
                color: Colors.black87,
                fontSize: 9,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Close button
  // ---------------------------------------------------------------------------

  Widget _buildCloseButton() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
        decoration: _frostedDecoration(radius: 50),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.close_rounded,
              color: Colors.white.withOpacity(0.8),
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              'Close Preview',
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Shared frosted-glass decoration used by the amount pill and close button.
  BoxDecoration _frostedDecoration({required double radius}) {
    return BoxDecoration(
      color: Colors.white.withOpacity(0.15),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: Colors.white.withOpacity(0.2)),
    );
  }

  /// Soft out-of-focus circle placed behind card content for depth.
  Widget _buildBokehCircle({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required double size,
    required double alpha,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(alpha),
        ),
      ),
    );
  }

  /// Angled translucent stripe that adds a subtle shine to the card.
  Widget _buildShimmerStripe() {
    return Positioned(
      top: -20,
      left: -60,
      child: Transform.rotate(
        angle: -pi / 6,
        child: Container(
          width: 60,
          height: 500,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.0),
                Colors.white.withOpacity(0.04),
                Colors.white.withOpacity(0.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
