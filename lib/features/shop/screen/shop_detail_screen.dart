import 'package:flutter/material.dart';
import 'package:myapp/core/utils/device_size.dart';
import 'package:myapp/core/utils/performance_monitor.dart';
import 'package:myapp/features/cart/screen/cart_widget.dart';
import 'package:myapp/features/shop/logic/shop_logic.dart';
import 'package:myapp/features/shop/widgets/app_bar_shop_widget.dart';
import 'package:myapp/features/shop/widgets/shop_product_grid_widget.dart';
// TODO: Comment out when API is ready
import 'package:myapp/data/service_locator.dart';
import 'package:myapp/shared/model/product.dart';
import 'package:myapp/shared/model/shop.dart';
import 'package:myapp/shared/widgets/common/app_spacing.dart';

class ShopDetailScreen extends StatefulWidget {
  final String? shopId;

  const ShopDetailScreen({super.key, this.shopId});

  @override
  State<ShopDetailScreen> createState() => _ShopDetailScreenState();
}

class _ShopDetailScreenState extends State<ShopDetailScreen> {
  final TextEditingController _searchController = TextEditingController();
  final CartService _cartService = CartService();
  final List<Product> _productList = [];
  final List<Shop> _shopList = [];
  final Map<String, GlobalKey> _productKeys = {};
  String? _selectedCategory;
  String _selectedFilter = 'all'; // 'all', 'products', 'care'

  @override
  void initState() {
    super.initState();
    _initializeData();
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
      // for (var product in prod) {
      //   _productKeys[product.productId] = GlobalKey();
      // }

      // if (_productList.isEmpty) {
      //   _productList.addAll(mockProducts);
      // }

      // if (_shopList.isEmpty) {
      //   _shopList.addAll(mockShops);
      // }
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
        onCartPressed: () =>
            CartWidget(_cartService).modalShow(context, _cartService),
      ),
      body: Column(
        children: [
          const Divider(height: 1),
          AppSpacing.vertical(4),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Shop info section
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: paddingResponsive),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Shop avatar
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.blue[400]!, Colors.blue[600]!],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              Icons.store,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                        AppSpacing.horizontal(12),
                        // Shop info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'PetShop Việt Nam',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[900],
                                    ),
                                  ),
                                  AppSpacing.horizontal(4),
                                  Icon(
                                    Icons.verified,
                                    color: Colors.blue[600],
                                    size: 16,
                                  ),
                                ],
                              ),
                              AppSpacing.vertical(4),
                              Wrap(
                                spacing: 16,
                                runSpacing: 4,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 14,
                                      ),
                                      AppSpacing.horizontal(4),
                                      Text(
                                        '4.9',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.phone,
                                        color: Colors.grey[500],
                                        size: 14,
                                      ),
                                      AppSpacing.horizontal(4),
                                      Text(
                                        '1900 123 456',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              AppSpacing.vertical(6),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: Colors.grey[500],
                                    size: 14,
                                  ),
                                  AppSpacing.horizontal(4),
                                  Expanded(
                                    child: Text(
                                      '123 Đường ABC, Quận 1, TP.HCM',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),

                              // AppSpacing.vertical(1),
                            ],
                          ),
                        ),
                        // Follow button
                        InkWell(
                          onTap: () {
                            // TODO: Navigate to shop details page
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Chức năng xem thông tin cửa hàng đang được phát triển',
                                ),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).primaryColor.withOpacity(0.1),
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(
                                    context,
                                  ).primaryColor.withOpacity(0.2),
                                  spreadRadius: 0,
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Xem thông tin',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                AppSpacing.horizontal(4),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 12,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  // Filter tabs
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: paddingResponsive,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        _buildFilterTab(
                          title: 'Tất cả',
                          isSelected: _selectedFilter == 'all',
                          onTap: () => _updateFilter('all'),
                        ),
                        AppSpacing.horizontal(12),
                        _buildFilterTab(
                          title: 'Sản phẩm',
                          isSelected: _selectedFilter == 'products',
                          onTap: () => _updateFilter('products'),
                        ),
                        AppSpacing.horizontal(12),
                        _buildFilterTab(
                          title: 'Dịch vụ',
                          isSelected: _selectedFilter == 'care',
                          onTap: () => _updateFilter('care'),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  // Product grid
                  ShopProductGridWidget(
                    productList: _getFilteredProducts(),
                    productKeys: _productKeys,
                    searchController: _searchController,
                    paddingResponsive: paddingResponsive,
                    openCart: () => CartWidget(
                      _cartService,
                    ).modalShowWithFloatingButtons(context, _cartService),
                  ),
                ],
              ),
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

  Widget _buildFilterTab({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[800],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  void _updateFilter(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  List<Product> _getFilteredProducts() {
    if (_selectedFilter == 'all') {
      return _productList.where((product) {
        final searchTerm = _searchController.text.toLowerCase();
        return product.productName.toLowerCase().contains(searchTerm);
      }).toList();
    } else if (_selectedFilter == 'care') {
      return _productList.where((product) {
        final searchTerm = _searchController.text.toLowerCase();
        return product.category.toLowerCase() == 'care' &&
            product.productName.toLowerCase().contains(searchTerm);
      }).toList();
    } else {
      // Products (excluding care)
      return _productList.where((product) {
        final searchTerm = _searchController.text.toLowerCase();
        return product.category.toLowerCase() != 'care' &&
            product.productName.toLowerCase().contains(searchTerm);
      }).toList();
    }
  }
}
