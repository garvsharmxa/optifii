import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// ViewModels
import 'features/rewards/presentation/viewmodels/rewards_marketplace_viewmodel.dart';
import 'features/rewards/presentation/viewmodels/search_discovery_viewmodel.dart';
import 'features/rewards/presentation/viewmodels/voucher_details_viewmodel.dart';
import 'features/rewards/presentation/viewmodels/gift_flow_viewmodel.dart';
import 'features/rewards/presentation/viewmodels/order_summary_viewmodel.dart';
import 'features/rewards/presentation/viewmodels/payment_viewmodel.dart';
import 'features/rewards/presentation/viewmodels/order_history_viewmodel.dart';
import 'features/rewards/presentation/viewmodels/voucher_post_purchase_viewmodel.dart';

// Home Screen
import 'features/rewards/presentation/views/marketplace/rewards_marketplace_screen.dart';

void main() {
  runApp(const OptifiiApp());
}

class OptifiiApp extends StatelessWidget {
  const OptifiiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RewardsMarketplaceViewModel()),
        ChangeNotifierProvider(create: (_) => SearchDiscoveryViewModel()),
        ChangeNotifierProvider(create: (_) => VoucherDetailsViewModel()),
        ChangeNotifierProvider(create: (_) => GiftFlowViewModel()),
        ChangeNotifierProvider(create: (_) => OrderSummaryViewModel()),
        ChangeNotifierProvider(create: (_) => PaymentViewModel()),
        ChangeNotifierProvider(create: (_) => OrderHistoryViewModel()),
        ChangeNotifierProvider(create: (_) => VoucherPostPurchaseViewModel()),
      ],
      child: MaterialApp(
        title: 'Optifii - Rewards',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF0A0416),
          textTheme: GoogleFonts.outfitTextTheme(
            ThemeData(brightness: Brightness.dark).textTheme,
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF5B11A8),
            brightness: Brightness.dark,
          ),
        ),
        home: const RewardsMarketplaceScreen(),
      ),
    );
  }
}
