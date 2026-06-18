import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../theme/theme.dart';
import '../search/search_discovery_screen.dart';
import '../history/order_history_screen.dart';
import 'widgets/category_list_widget.dart';
import 'widgets/trending_brands_widget.dart';

class RewardsMarketplaceScreen extends StatefulWidget {
  const RewardsMarketplaceScreen({super.key});

  @override
  State<RewardsMarketplaceScreen> createState() => _RewardsMarketplaceScreenState();
}

class _RewardsMarketplaceScreenState extends State<RewardsMarketplaceScreen> {
  final PageController _bannerController = PageController();
  int _activeBannerIndex = 0;

  late final List<Map<String, dynamic>> _banners = [
    {
      'brandId': 'BRD-MAKEMYTRIP',
      'imageUrl': 'https://promos.makemytrip.com/Hotels_product/PhonePe/720x360-Affiliates-banner-1.jpg',
    },
    {
      'brandId': 'BRD-FLIPKART',
      'imageUrl': 'https://cdn.dribbble.com/userupload/10608480/file/original-2286c207033c127c7748fc391e852e75.png?resize=752x&vertical=center',
    },
    {
      'brandId': 'BRD-SWIGGY',
      'imageUrl': 'https://www.thearcweb.com/_next/image?url=https%3A%2F%2Fstatic.thearcweb.com%2Fimages%2FPROD%2FPROD-94d963ea-d966-47bf-a6a8-60518888a33e.jpeg%3Fw%3D90%26q%3D100&w=1024&q=100',
    },
    {
      'brandId': 'BRD-BIGBASKET',
      'imageUrl': 'https://www.fugenx.com/wp-content/uploads/2017/04/BigBasket-App-Development-banner-FuGenX.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      body: Container(
        decoration: RewardsTheme.backgroundDecoration,
        child: SafeArea(
          bottom: false,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── Pinned App Bar with Title + Menu ──
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  minHeight: 60,
                  maxHeight: 60,
                  child: Container(
                    color: RewardsTheme.primaryPurple,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Rewards",
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Builder(
                          builder: (ctx) => InkWell(
                            onTap: () => Scaffold.of(ctx).openDrawer(),
                            borderRadius: BorderRadius.circular(24),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.06),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white12),
                              ),
                              child: const Icon(Icons.menu, color: Colors.white, size: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Search Bar ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SearchDiscoveryScreen(),
                        ),
                      );
                    },
                    child: Container(
                      height: 52,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Colors.white38, size: 20),
                          const SizedBox(width: 12),
                          Text(
                            "Search Brands/ Categories",
                            style: GoogleFonts.outfit(color: Colors.white38, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ── Category Chips ──
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: 12, bottom: 12),
                  child: CategoryListWidget(),
                ),
              ),

              // ── Banner Slider ──
              SliverToBoxAdapter(child: _buildBannerSlider()),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 20),
                  child: _buildBannerIndicators(),
                ),
              ),

              // ── Trending Brands Header ──
              SliverToBoxAdapter(
                child: _buildSectionHeader("Trending Brands", onExplore: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchDiscoveryScreen(startWithCategories: true),
                    ),
                  );
                }),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 12)),
              const SliverToBoxAdapter(
                child: TrendingBrandsWidget(isTrending: true),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // ── OptiFii Special Banner ──
              SliverToBoxAdapter(child: _buildOptiFiiSpecialBanner(context)),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // ── Popular Brands Header ──
              SliverToBoxAdapter(
                child: _buildSectionHeader("Popular Brands", onExplore: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchDiscoveryScreen(startWithCategories: true),
                    ),
                  );
                }),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 12)),
              const SliverToBoxAdapter(
                child: TrendingBrandsWidget(isTrending: false),
              ),

              // Bottom padding
              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          ),
        ),
      ),
    );
  }

  // ── Drawer ──
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0xFF0F0624),
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF1B0B36),
                border: Border(bottom: BorderSide(color: Colors.white12)),
              ),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFF8A2387), Color(0xFFE94057)],
                        ),
                      ),
                      child: const Center(
                        child: Icon(Icons.star, color: Colors.white, size: 20),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "OptiFii Rewards",
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.card_giftcard, color: Colors.white70),
              title: Text("Vouchers Home", style: GoogleFonts.outfit(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.history, color: Colors.white70),
              title: Text("Order History", style: GoogleFonts.outfit(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OrderHistoryScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.category, color: Colors.white70),
              title: Text("All Categories", style: GoogleFonts.outfit(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchDiscoveryScreen(startWithCategories: true),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // ── Banner Slider ──
  Widget _buildBannerSlider() {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        controller: _bannerController,
        onPageChanged: (index) {
          setState(() {
            _activeBannerIndex = index;
          });
        },
        itemCount: _banners.length,
        itemBuilder: (context, index) {
          final banner = _banners[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl: banner['imageUrl'] as String,
                fit: BoxFit.fill,
                placeholder: (context, url) => Container(
                  color: Colors.white10,
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white38),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: const Color(0xFF1B0B36),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.image_not_supported, color: Colors.white24, size: 36),
                        const SizedBox(height: 8),
                        Text(
                          "Failed to load banner",
                          style: GoogleFonts.outfit(color: Colors.white30, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Banner Indicators ──
  Widget _buildBannerIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _banners.length,
        (index) => Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _activeBannerIndex == index ? Colors.white : Colors.white24,
          ),
        ),
      ),
    );
  }

  // ── Section Header ──
  Widget _buildSectionHeader(String title, {required VoidCallback onExplore}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          InkWell(
            onTap: onExplore,
            child: Row(
              children: [
                Text(
                  "Explore",
                  style: GoogleFonts.outfit(color: Colors.white54, fontSize: 12),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── OptiFii Promo Banner (fixed overflow) ──
  Widget _buildOptiFiiSpecialBanner(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AspectRatio(
        aspectRatio: 656 / 510,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final height = constraints.maxHeight;

              // Proportional coordinates from the 656x510 original image:
              // Left: 48 / 656
              // Bottom: (510 - 461) / 510 = 49 / 510
              // Width: (237 - 48) / 656 = 189 / 656
              // Height: (461 - 404) / 510 = 57 / 510
              final buttonLeft = width * (48 / 656);
              final buttonBottom = height * (49 / 510);
              final buttonWidth = width * (189 / 656);
              final buttonHeight = height * (57 / 510);

              return Stack(
                fit: StackFit.expand,
                children: [
                  // Background Image
                  Image.asset(
                    'assets/images/special_banner.png',
                    fit: BoxFit.fill,
                  ),
                  // Interactive button positioned over the pre-rendered button
                  Positioned(
                    left: buttonLeft,
                    bottom: buttonBottom,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SearchDiscoveryScreen(startWithCategories: true),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(buttonHeight / 2),
                        splashColor: Colors.black.withValues(alpha: 0.1),
                        highlightColor: Colors.black.withValues(alpha: 0.05),
                        child: Container(
                          width: buttonWidth,
                          height: buttonHeight,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(buttonHeight / 2),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// ── SliverPersistentHeader Delegate for pinned app bar ──
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}



