import '../models/brand_model.dart';
import '../models/category_model.dart';
import '../models/voucher_model.dart';
import '../models/order_model.dart';

class RewardsRepository {
  // Singleton Pattern
  static final RewardsRepository _instance = RewardsRepository._internal();
  factory RewardsRepository() => _instance;
  RewardsRepository._internal();

  // In-memory order storage
  final List<OrderModel> _orders = [
    // Pre-populated mock order to show in history
    OrderModel(
      id: "ORD-984310",
      voucher: VoucherModel(
        id: "VOU-F10",
        brandId: "BRD-FLIPKART",
        name: "Flipkart Voucher",
        validityMonths: 6,
        discountPercentage: 5.0,
        predefinedDenominations: [500, 1000, 1500, 2000, 2500, 5000],
        minCustomAmount: 100,
        maxCustomAmount: 10000,
        termsAndConditions: [
          "This Gift Card is usable at Flipkart.com and mobile app.",
          "Validity: 6 months from purchase date.",
          "Gift Cards cannot be redeemed for cash or credit.",
          "Flipkart is not responsible if a card is lost or stolen."
        ],
        redemptionSteps: [
          "Go to Flipkart.com or open the Flipkart App.",
          "Add items to your cart and proceed to checkout.",
          "Select 'Gift Card' as the payment option.",
          "Enter your 16-digit Card Number and 6-digit PIN."
        ],
      ),
      quantity: 1,
      totalAmount: 1000.0,
      discountAmount: 50.0,
      finalAmount: 950.0,
      purchaseDate: DateTime.now().subtract(const Duration(days: 2)),
      isGift: false,
      cardNumber: "1234567890123456",
      pinCode: "987654",
      isRevealed: false,
    )
  ];

  final List<CategoryModel> _categories = const [
    CategoryModel(id: "CAT-QC", name: "Quick Commerce", iconName: "bolt"),
    CategoryModel(id: "CAT-ENT", name: "Entertainment", iconName: "movie"),
    CategoryModel(id: "CAT-FSH", name: "Fashion", iconName: "shopping_bag"),
    CategoryModel(id: "CAT-ELC", name: "Electronics", iconName: "devices"),
    CategoryModel(id: "CAT-FOD", name: "Food", iconName: "restaurant"),
  ];

  final List<BrandModel> _brands = const [
    BrandModel(
      id: "BRD-FLIPKART",
      name: "Flipkart",
      discountPercentage: 6.0,
      startingPrice: 500.0,
      themeColorHex: "FF1E5AF1", // ARGB format Hex
      category: "CAT-QC",
    ),
    BrandModel(
      id: "BRD-SWIGGY",
      name: "Swiggy",
      discountPercentage: 6.0,
      startingPrice: 100.0,
      themeColorHex: "FFFF5200",
      category: "CAT-QC",
    ),
    BrandModel(
      id: "BRD-LIFESTYLE",
      name: "Lifestyle",
      discountPercentage: 6.0,
      startingPrice: 500.0,
      themeColorHex: "FFFFFFFF",
      category: "CAT-FSH",
    ),
    BrandModel(
      id: "BRD-AMAZON",
      name: "Amazon",
      discountPercentage: 6.0,
      startingPrice: 200.0,
      themeColorHex: "FF232F3E",
      category: "CAT-QC",
    ),
    BrandModel(
      id: "BRD-BIGBASKET",
      name: "BigBasket",
      discountPercentage: 6.0,
      startingPrice: 100.0,
      themeColorHex: "FF84C225",
      category: "CAT-QC",
    ),
  ];

  List<CategoryModel> getCategories() => _categories;

  List<BrandModel> getBrands() => _brands;

  VoucherModel? getVoucherByBrandId(String brandId) {
    if (brandId == "BRD-FLIPKART") {
      return VoucherModel(
        id: "VOU-FLIPKART",
        brandId: "BRD-FLIPKART",
        name: "Flipkart Voucher",
        validityMonths: 6,
        discountPercentage: 3.0, // Matching the details screenshot (Discount 3%)
        predefinedDenominations: const [500, 1000, 1500, 2000, 2500, 5000],
        minCustomAmount: 100,
        maxCustomAmount: 10000,
        termsAndConditions: const [
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla facilisi. Vivamus lacinia odio vitae vestibulum vestibulum. Cras venenatis euismod malesuada. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium.",
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla facilisi. Vivamus lacinia odio vitae vestibulum vestibulum. Cras venenatis euismod malesuada. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium.",
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla facilisi. Vivamus lacinia odio vitae vestibulum vestibulum. Cras venenatis euismod malesuada. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium."
        ],
        redemptionSteps: const [
          "Go to Flipkart.com or open the mobile application.",
          "Select the items you wish to purchase and proceed to checkout.",
          "In the payment options, choose 'Gift Cards'.",
          "Enter your 16-digit Card Number and 6-digit PIN to apply the voucher value."
        ],
      );
    }
    
    // Default fallback for other brands
    final brand = _brands.firstWhere((element) => element.id == brandId);
    return VoucherModel(
      id: "VOU-${brand.name.toUpperCase()}",
      brandId: brand.id,
      name: "${brand.name} Voucher",
      validityMonths: 12,
      discountPercentage: brand.discountPercentage,
      predefinedDenominations: const [200, 500, 1000, 2000, 5000],
      minCustomAmount: 100,
      maxCustomAmount: 10000,
      termsAndConditions: const [
        "This voucher is issued by the brand and can be used on their platforms.",
        "Valid for 12 months from the date of purchase.",
        "Cannot be clubbed with other offers or refunded."
      ],
      redemptionSteps: const [
        "Visit the brand portal or retail outlet.",
        "Present/input this voucher during payments.",
        "Verify details and pay any balance using standard options."
      ],
    );
  }

  List<OrderModel> getOrders() => _orders;

  void addOrder(OrderModel order) {
    _orders.add(order);
  }

  void revealOrderVoucher(String orderId) {
    final index = _orders.indexWhere((element) => element.id == orderId);
    if (index != -1) {
      _orders[index] = _orders[index].copyWith(isRevealed: true);
    }
  }
}
