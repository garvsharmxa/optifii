import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../theme/theme.dart';
import '../../viewmodels/search_discovery_viewmodel.dart';
import 'widgets/search_history_widget.dart';
import 'widgets/search_results_widget.dart';


class SearchDiscoveryScreen extends StatefulWidget {
  final bool startWithCategories;

  const SearchDiscoveryScreen({
    super.key,
    this.startWithCategories = false,
  });

  @override
  State<SearchDiscoveryScreen> createState() => _SearchDiscoveryScreenState();
}

class _RewardsCategory {
  final String name;
  final String description;
  _RewardsCategory(this.name, this.description);
}

class _SearchDiscoveryScreenState extends State<SearchDiscoveryScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  final List<_RewardsCategory> _allCategories = [
    _RewardsCategory("Quick Commerce", "Grocery & daily essentials"),
    _RewardsCategory("Entertainment", "Movies, music, & gaming"),
    _RewardsCategory("Fashion", "Apparel & lifestyle brands"),
    _RewardsCategory("Electronics", "Gadgets & appliances"),
    _RewardsCategory("Food & Dining", "Restaurants & cafes"),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!widget.startWithCategories) {
        _focusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SearchDiscoveryViewModel>();
    final isQueryEmpty = viewModel.query.isEmpty;

    return Scaffold(
      body: Container(
        decoration: RewardsTheme.backgroundDecoration,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Header block
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        viewModel.updateQuery("");
                        Navigator.pop(context);
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
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: Colors.white.withOpacity(0.08)),
                        ),
                        child: TextField(
                          controller: _searchController,
                          focusNode: _focusNode,
                          onChanged: (val) => viewModel.updateQuery(val),
                          onSubmitted: (val) => viewModel.addSearchHistory(val),
                          style: GoogleFonts.outfit(color: Colors.white, fontSize: 14),
                          decoration: InputDecoration(
                            hintText: widget.startWithCategories ? "Search Category" : "Search Brands/ Categories",
                            hintStyle: GoogleFonts.outfit(color: Colors.white30, fontSize: 14),
                            prefixIcon: const Icon(Icons.search, color: Colors.white30, size: 20),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear, color: Colors.white60, size: 18),
                                    onPressed: () {
                                      _searchController.clear();
                                      viewModel.updateQuery("");
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Search Main Panel
              Expanded(
                child: isQueryEmpty
                    ? (widget.startWithCategories
                        ? _buildAllCategoriesList(viewModel)
                        : _buildHistoryAndDiscovery(viewModel))
                    : const SearchResultsWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAllCategoriesList(SearchDiscoveryViewModel viewModel) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Text(
            "All Categories",
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ..._allCategories.map((cat) => Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  title: Text(
                    cat.name,
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    cat.description,
                    style: GoogleFonts.outfit(
                      color: Colors.white38,
                      fontSize: 12,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white38,
                    size: 14,
                  ),
                  onTap: () {
                    // Set query to category name to perform filtered search
                    _searchController.text = cat.name;
                    viewModel.updateQuery(cat.name);
                  },
                ),
                Divider(color: Colors.white.withOpacity(0.04), height: 1),
              ],
            )),
      ],
    );
  }

  Widget _buildHistoryAndDiscovery(SearchDiscoveryViewModel viewModel) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        SearchHistoryWidget(
          onTermSelected: (term) {
            _searchController.text = term;
            viewModel.updateQuery(term);
          },
        ),
        
        // Quick discovery categories helper
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Text(
            "Quick Discovery",
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildDiscoveryChip("Flipkart", viewModel),
              _buildDiscoveryChip("Swiggy", viewModel),
              _buildDiscoveryChip("Amazon", viewModel),
              _buildDiscoveryChip("Fashion", viewModel),
              _buildDiscoveryChip("Electronics", viewModel),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDiscoveryChip(String name, SearchDiscoveryViewModel viewModel) {
    return InkWell(
      onTap: () {
        _searchController.text = name;
        viewModel.updateQuery(name);
        viewModel.addSearchHistory(name);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white12),
        ),
        child: Text(
          name,
          style: GoogleFonts.outfit(color: Colors.white70, fontSize: 13),
        ),
      ),
    );
  }
}
