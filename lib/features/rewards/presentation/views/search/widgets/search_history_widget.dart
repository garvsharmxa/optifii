import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/search_discovery_viewmodel.dart';

class SearchHistoryWidget extends StatelessWidget {
  final Function(String) onTermSelected;

  const SearchHistoryWidget({
    super.key,
    required this.onTermSelected,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SearchDiscoveryViewModel>();
    final history = viewModel.searchHistory;

    if (history.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Recent Searches",
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () => viewModel.clearHistory(),
                child: Text(
                  "Clear all",
                  style: GoogleFonts.outfit(
                    color: Colors.white38,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: history.length,
          itemBuilder: (context, index) {
            final term = history[index];
            return ListTile(
              leading: const Icon(Icons.history, color: Colors.white30, size: 20),
              title: Text(
                term,
                style: GoogleFonts.outfit(color: Colors.white70, fontSize: 14),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.close, color: Colors.white30, size: 16),
                onPressed: () => viewModel.deleteHistoryItem(term),
              ),
              onTap: () => onTermSelected(term),
            );
          },
        ),
      ],
    );
  }
}
