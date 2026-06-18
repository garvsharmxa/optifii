import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../viewmodels/gift_flow_viewmodel.dart';

class GiftThemeSelector extends StatelessWidget {
  const GiftThemeSelector({super.key});

  // Theme Gradients
  static const List<LinearGradient> themeGradients = [
    LinearGradient(colors: [Color(0xFF5B11A8), Color(0xFF9E00FF)]), // Purple Sparkle
    LinearGradient(colors: [Color(0xFF8A2387), Color(0xFFF27121)]), // Golden Celebration
    LinearGradient(colors: [Color(0xFF00B4DB), Color(0xFF0083B0)]), // Classic Teal
    LinearGradient(colors: [Color(0xFF11998e), Color(0xFF38ef7d)]), // Vibrant Green
  ];

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<GiftFlowViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select Gift Card Theme",
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 64,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: themeGradients.length,
            itemBuilder: (context, index) {
              final isSelected = viewModel.selectedThemeIndex == index;
              final name = viewModel.themeBanners[index];

              return Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: GestureDetector(
                  onTap: () => viewModel.selectTheme(index),
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                      gradient: themeGradients[index],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? Colors.white : Colors.transparent,
                        width: 2.0,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: themeGradients[index].colors[1].withOpacity(0.4),
                                blurRadius: 8,
                                spreadRadius: 1,
                              )
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        name.split(" ")[0], // Short name
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
