import 'package:flutter/material.dart';
import 'package:myapp/core/utils/device_size.dart';
import 'package:myapp/core/utils/performance_monitor.dart';
import 'package:myapp/features/cart/screen/cart_widget.dart';
import 'package:myapp/features/shop/logic/shop_logic.dart';
import 'package:myapp/features/shop/widgets/shop_product_grid_widget.dart';
import 'package:myapp/features/shop/widgets/shop_service_list_widget.dart';
// TODO: Comment out when API is ready
import 'package:myapp/data/service_locator.dart';
import 'package:myapp/shared/model/product.dart';
import 'package:myapp/shared/model/shop.dart';
import 'package:myapp/shared/widgets/common/app_spacing.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ShopScreen extends StatefulWidget {
  final String? searchValue;
  const ShopScreen({super.key, required this.title, this.searchValue});
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

  bool _enabled = true;
  Future<void> _simulateLoading() async {
    await Future.delayed(const Duration(seconds: 20));
    if (mounted) {
      setState(() {
        _enabled = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
    _simulateLoading();

    _cartService.addListener(_onCartUpdated);
  }

  void _initializeData() async {
    // TODO: Replace with service calls when API is ready
    final productService = ServiceLocator().productService;
    final shopService = ServiceLocator().shopService;

    try {
      // Get data from services (currently using mock data)
      final products = await productService.getAllProducts();
      final shops = await shopService.getAllShops();

      for (var product in products) {
        _productKeys[product.productId] = GlobalKey();
      }

      if (_productList.isEmpty) {
        _productList.addAll(products);
      }

      if (_shopList.isEmpty) {
        _shopList.addAll(shops);
      }
    } catch (e) {
      // Fallback to mock data if service fails
      // for (var product in mockProducts) {
      //   _productKeys[product.productId] = GlobalKey();
      // }

      // if (_productList.isEmpty) {
      //   _productList.addAll(mockProducts);
      // }

      // if (_shopList.isEmpty) {
      //   _shopList.addAll(mockShops);
      // }
    }

    if (widget.searchValue != null && widget.searchValue!.isNotEmpty) {
      _searchController.text = widget.searchValue!;
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
      // appBar: ShopAppBarWidget(
      //   searchController: _searchController,
      //   onSearchChanged: onSearch,
      //   onCartPressed: () => CartWidget(
      //     _cartService,
      //   ).modalShowWithFloatingButtons(context, _cartService),
      // ),
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

    return Skeletonizer(enabled: _enabled, child: widget);
  }

  void onSearch(String name) {
    setState(() {});
  }
}
