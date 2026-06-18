import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../theme/theme.dart';
import '../../viewmodels/order_history_viewmodel.dart';
import 'widgets/order_history_card_widget.dart';
import 'order_history_detail_screen.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderHistoryViewModel>().loadOrders();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<OrderHistoryViewModel>();
    final orders = vm.filteredOrders;

    return Scaffold(
      body: Container(
        decoration: RewardsTheme.backgroundDecoration,
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                        child: const Icon(Icons.arrow_back,
                            color: Colors.white, size: 20),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Order History",
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Search + Filter Row
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.08)),
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: vm.updateSearchQuery,
                          style: GoogleFonts.outfit(
                              color: Colors.white, fontSize: 14),
                          decoration: InputDecoration(
                            hintText: "Search Transaction",
                            hintStyle: GoogleFonts.outfit(
                                color: Colors.white30, fontSize: 14),
                            prefixIcon: const Icon(Icons.search,
                                color: Colors.white30, size: 20),
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Filters popup
                    GestureDetector(
                      onTap: () => _showFilterMenu(context, vm),
                      child: Row(
                        children: [
                          Text(
                            "Filters",
                            style: GoogleFonts.outfit(
                              color: Colors.white54,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.tune, color: Colors.white54, size: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Orders list
              Expanded(
                child: orders.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.receipt_long,
                                color: Colors.white24, size: 64),
                            const SizedBox(height: 16),
                            Text(
                              "No orders yet",
                              style: GoogleFonts.outfit(
                                color: Colors.white54,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Your purchased vouchers will appear here",
                              style: GoogleFonts.outfit(
                                  color: Colors.white30, fontSize: 13),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          final order = orders[index];
                          return OrderHistoryCardWidget(
                            order: order,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      OrderHistoryDetailScreen(order: order),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterMenu(BuildContext context, OrderHistoryViewModel vm) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1B0F3A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Filter Orders",
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...["All", "Purchased", "Gifted"].map(
                (filter) => RadioListTile<String>(
                  title: Text(filter,
                      style: GoogleFonts.outfit(color: Colors.white)),
                  value: filter,
                  groupValue: vm.activeFilter,
                  activeColor: RewardsTheme.accentGreen,
                  onChanged: (val) {
                    if (val != null) {
                      vm.setFilter(val);
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }
}
