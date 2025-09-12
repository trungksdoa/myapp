import 'package:flutter/material.dart';
import 'package:myapp/core/currency_format.dart';
import 'package:myapp/core/utils/device_size.dart';
import 'package:myapp/core/utils/performance_monitor.dart';
import 'package:myapp/features/shop/logic/shop_logic.dart';
import 'package:myapp/features/shop/widgets/app_bar_shop_widget.dart';
import 'package:myapp/features/shop/widgets/cart_empty_widget.dart';
import 'package:myapp/features/shop/widgets/cart_items_list_widget.dart';
import 'package:myapp/features/shop/widgets/shop_product_grid_widget.dart';
import 'package:myapp/features/shop/widgets/shop_service_list_widget.dart';
import 'package:myapp/mock_data/shop_mock.dart';
import 'package:myapp/shared/model/product.dart';
import 'package:myapp/shared/model/shop.dart';
import 'package:myapp/shared/widgets/common/app_spacing.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key, required this.title});
  final String title;

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final TextEditingController _searchController = TextEditingController();
  final CartService _cartService = CartService();
  final List<Product> _productList = [];
  final List<Shop> _shopList = [];
  final Map<String, GlobalKey> _productKeys = {};

  @override
  void initState() {
    super.initState();
    _initializeData();
    _cartService.addListener(_onCartUpdated);
  }

  void _initializeData() {
    for (var product in mockProducts) {
      _productKeys[product.productId] = GlobalKey();
    }

    if (_productList.isEmpty) {
      _productList.addAll(mockProducts);
    }

    if (_shopList.isEmpty) {
      _shopList.addAll(mockShops);
    }

    // Initialize cart service with product data
    _cartService.initializeProductData(_productList);
  }

  void _onCartUpdated() {
    setState(() {}); // Rebuild when cart changes
  }

  @override
  void dispose() {
    _searchController.dispose();
    _cartService.removeListener(_onCartUpdated);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PerformanceMonitor.start('Shop build');

    double width = MediaQuery.of(context).size.width;
    double paddingResponsive = DeviceSize.getResponsivePadding(width);

    final widget = Scaffold(
      appBar: ShopAppBarWidget(
        searchController: _searchController,
        onSearchChanged: onSearch,
        onCartPressed: () => modalShow(),
      ),
      body: Column(
        children: [
          // Service list - NO Consumer needed (static)
          ShopServiceListWidget(paddingResponsive: paddingResponsive),

          AppSpacing.vertical(4),
          const Divider(height: 1),
          AppSpacing.vertical(4),

          // Product grid - NO Consumer needed here
          Expanded(
            child: ShopProductGridWidget(
              productList: _productList,
              productKeys: _productKeys,
              searchController: _searchController,
              paddingResponsive: paddingResponsive,
            ),
          ),
        ],
      ),
    );

    PerformanceMonitor.stop('HomeScreen build');
    return widget;
  }

  void onSearch(String name) {
    setState(() {});
  }

  void modalShow() {
    WoltModalSheet.show(
      context: context,
      pageListBuilder: (bottomSheetContext) => [
        SliverWoltModalSheetPage(
          mainContentSliversBuilder: (context) => [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Your Cart',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                    const Divider(),
                  ],
                ),
              ),
            ),
            _cartService.getCartCount() == 0
                ? CartEmptyWidget()
                : CartItemsListWidget(cartService: _cartService),

            if (_cartService.getCartCount() > 0)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Tổng cộng',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            Currency.formatVND(_cartService.getTotalAmount()),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[700],
                            ),
                          ),
                        ],
                      ),
                      AppSpacing.vertical(24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            // Navigate to checkout page
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Thanh toán',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
          backgroundColor: Colors.white,
          forceMaxHeight: true,
        ),
      ],
    );
  }
}
