# OptiFii Rewards — Flutter Voucher & Rewards Marketplace

OptiFii Rewards is a pixel-perfect, highly responsive Flutter mobile application designed to deliver an premium voucher discovery, purchase, checkout, and gifting experience. 

Built with a modern, dark-themed glassmorphic design system and driven by robust state management, this project serves as a showcase of aesthetic design and clean mobile engineering.

---

## 📱 Recreated Screens & User Flows

The application covers the complete customer journey for rewards and voucher management, featuring:

1. **Rewards Marketplace (Home Screen):**
   * Pinned, custom-scrolling app bar with immersive category chips.
   * Auto-scrolling network-cached promotion banners with dynamic indicators.
   * Proportional-layout promotional cards with custom touch overlay bounds mapped directly to aspect ratios.
   * Categorized sections for "Trending Brands" and "Popular Brands" using custom brand-color cards.
   
2. **Search & Discovery Screen:**
   * Instant search filter for brand items with fuzzy matching.
   * Collapsible category dropdown sections.
   * Elegant error and empty states for searches with zero results.

3. **Voucher Details Screen:**
   * Dynamic hero brand headers matching the specific brand's corporate identity colors.
   * Flexible denomination selectors with both predefined options and a validated custom price input field.
   * Expanded, scrollable sections for Terms & Conditions and Redemption Steps.
   * Interactive sticky checkout footer showing real-time price changes.

4. **Gift Flow setup:**
   * A togglable toggle flow that shifts the order state to a gifting path.
   * Input forms for recipient details (name, email, phone) and personalized text card messages.
   * Custom theme selectors for gift wrap styling (Dynamic linear gradients).
   * **Gift Preview Dialog:** A premium-designed frosted-glass card with bokeh particles, subtle shimmer stripes, and scale-up entrance animations.

5. **Order Summary Screen:**
   * Order item breakdowns showing custom pricing, discount deductions, and final payable values.
   * Gift card summary info showcasing receiver details and personalized messages if the gift option is active.
   * Easy checkout trigger linking directly to the secure mock payment gateway.

6. **Secure Mock Payment Screen:**
   * Standard and simulated payment channels (UPI, Netbanking, Credit/Debit cards).
   * Real-time loading indicators simulating bank transactions.

7. **Success Screen:**
   * Dynamic payment success feedback with celebratory graphics.
   * Primary route triggers to either view order details, check history, or head back to the marketplace home.

8. **Order History & Post-Purchase Details:**
   * Order lists recording past purchases.
   * Post-purchase details screen featuring interactive PIN and card-number reveal cards.
   * Convenient one-tap clipboard copy actions for voucher numbers.

---

## 🎨 Design System & Visual Polish

* **Dark Glassmorphism:** Main screen backgrounds are built using custom linear gradients scaling from a deep imperial purple (`#280B54`) down to dark violet (`#0A0416`).
* **Micro-Animations:** Fluid view transitions, dialog scales (`GiftPreviewDialog` entrance transitions), and responsive button taps.
* **Network Caching:** Network banners utilize `cached_network_image` to avoid network delays, backed by premium error widgets.
* **Typography:** Beautiful layout pairing using Google Fonts' `Outfit` family.
* **Corporate Theme Colors:** Every brand card and header screen adjusts dynamically based on the brand's primary color palette (e.g. Swiggy Orange, Flipkart Blue, BigBasket Green).

---

## 🤖 AI Collaboration Details

This project was built in close collaboration with **Antigravity**, an agentic AI coding companion developed by the Google DeepMind team. The AI acted as a pair programmer, contributing to the development in the following key areas:

* **Aspect-Ratio Overlay Calculation:** Assisted in building the interactive coordinates mapping for the home page special banner (`special_banner.png`). Instead of rendering arbitrary overlay layers, the coordinates for the custom button were mapped proportionally based on the original asset resolution (`656x510`), preventing layout overflows on varying screen heights.
* **Clean MVVM Structuring:** Pair-programmed the separation of View, ViewModel, and Model layers, creating a unified state loop through Flutter's Provider packages.
* **Dynamic Form Validation:** Designed robust validators for custom denomination inputs (enforcing min/max boundaries per brand) and gift forms.
* **Responsive Layout Polish:** Suggested using constraints and LayoutBuilders to handle small and large screens natively.

---

## ⚙️ Architecture & Folder Structure

The app follows a modern Clean Architecture-inspired MVVM pattern, enabling easy testing and code reusability:

```text
lib/
├── main.dart                                # App entry point, MultiProvider initialization
└── features/
    └── rewards/
        ├── data/
        │   ├── models/                      # Domain entities (Brand, Voucher, Category, Order)
        │   ├── repositories/                # Rewards repository storing mock backend data
        │   └── sources/                     # Local and Remote mock source boundaries
        └── presentation/
            ├── theme/                       # Custom design tokens, fonts, and box decorations
            ├── viewmodels/                  # ViewModels managing states (Marketplace, Details, Payment, Gift, History)
            └── views/                       # Pure UI Screens and custom widgets
                ├── details/
                ├── gift/
                ├── history/
                ├── marketplace/
                ├── order_summary/
                ├── payment/
                ├── post_purchase/
                └── search/
```

---

## Getting Started

Follow these steps to run the application locally or install the pre-compiled builds.

### Prerequisites

* Flutter SDK (`>=3.12.0`)
* Dart SDK
* An Android/iOS Emulator or physical test device connected to your workstation.

### Step 1: Clone the Repository
```bash
git clone <repository_url>
cd optifii
```

### Step 2: Install Dependencies
```bash
flutter pub get
```

### Step 3: Run the Application
```bash
flutter run
```

---

## Download and Install Android APK

We have provided built artifacts within the repository. You can retrieve them directly:

* **Release APK Path:** `build/app/outputs/flutter-apk/app-release.apk`
* **Debug APK Path:** `build/app/outputs/flutter-apk/app-debug.apk`

To build a fresh APK build from scratch, execute:
```bash
flutter build apk --release
```
The compiled release artifact will be located in `build/app/outputs/flutter-apk/app-release.apk`.
