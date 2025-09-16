import 'package:flutter/material.dart';
import 'package:myapp/core/utils/device_size.dart';
import 'package:myapp/core/utils/performance_monitor.dart';
import 'package:myapp/features/cart/screen/cart_widget.dart';
import 'package:myapp/features/shop/logic/shop_logic.dart';
import 'package:myapp/features/shop/widgets/app_bar_shop_widget.dart';
import 'package:myapp/features/shop/widgets/shop_product_grid_widget.dart';
import 'package:myapp/features/shop/widgets/shop_service_list_widget.dart';
import 'package:myapp/mock_data/shop_mock.dart';
import 'package:myapp/shared/model/product.dart';
import 'package:myapp/shared/model/shop.dart';
import 'package:myapp/shared/widgets/common/app_spacing.dart';

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
  String? _selectedCategory;

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

    final filteredProducts = _selectedCategory == null
        ? _productList
        : _productList.where((p) => p.category == _selectedCategory).toList();

    final widget = Scaffold(
      appBar: ShopAppBarWidget(
        searchController: _searchController,
        onSearchChanged: onSearch,
        onCartPressed: () => CartWidget(
          _cartService,
        ).modalShowWithFloatingButtons(context, _cartService),
      ),
      body: Column(
        children: [
          ShopServiceListWidget(
            paddingResponsive: paddingResponsive,
            onServiceTap: (categoryKey) {
              setState(() {
                _selectedCategory = categoryKey;
              });
            },
          ),
          const Divider(height: 1),
          AppSpacing.vertical(4),
          Expanded(
            child: ShopProductGridWidget(
              productList: filteredProducts,
              productKeys: _productKeys,
              searchController: _searchController,
              paddingResponsive: paddingResponsive,
              openCart: () => CartWidget(
                _cartService,
              ).modalShowWithFloatingButtons(context, _cartService),
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
}
