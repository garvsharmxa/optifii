import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RewardsTheme {
  // Brand Colors
  static const Color primaryPurple = Color(0xFF280B54);
  static const Color backgroundDark = Color(0xFF0A0416);
  static const Color accentGreen = Color(0xFF00E676); // Neon Green for discounts
  static const Color borderPurple = Color(0xFF3D1B75);
  static const Color cardBackground = Color(0xFF160A2B);
  
  // Custom brand colours for background cards
  static const Color flipkartBlue = Color(0xFF1E5AF1);
  static const Color swiggyOrange = Color(0xFFFF5200);
  static const Color makeMyTripBlue = Color(0xFFD6ECFF);
  static const Color amazonGrey = Color(0xFF232F3E);
  static const Color lifestyleWhite = Colors.white;
  static const Color lifestyleTextDark = Color(0xFF1A1A1A);
  static const Color bigBasketGreen = Color(0xFF84C225);

  // Gradient Background for the entire module
  static const BoxDecoration backgroundDecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        primaryPurple,
        backgroundDark,
      ],
      stops: [0.0, 0.85],
    ),
  );

  // Glassmorphic Card Decoration
  static BoxDecoration cardDecoration({
    Color color = const Color(0xFF1B0D36),
    double borderRadius = 16,
    double borderWidth = 1.0,
    Color borderColor = borderPurple,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: borderColor,
        width: borderWidth,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  // Text Styles
  static TextStyle headingLarge(BuildContext context) {
    return GoogleFonts.outfit(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
  }

  static TextStyle headingMedium(BuildContext context) {
    return GoogleFonts.outfit(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    );
  }

  static TextStyle bodyLarge(BuildContext context) {
    return GoogleFonts.outfit(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    );
  }

  static TextStyle bodyMedium(BuildContext context) {
    return GoogleFonts.outfit(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: Colors.white70,
    );
  }

  static TextStyle labelBold(BuildContext context) {
    return GoogleFonts.outfit(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
  }

  static TextStyle labelMedium(BuildContext context) {
    return GoogleFonts.outfit(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: Colors.white54,
    );
  }

  static TextStyle discountStyle(BuildContext context) {
    return GoogleFonts.outfit(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: accentGreen,
    );
  }
}
