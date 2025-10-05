import 'package:flutter/material.dart';
import 'package:myapp/core/utils/device_size.dart';
import 'package:myapp/core/utils/performance_monitor.dart';
import 'package:myapp/features/cart/screen/cart_widget.dart';
import 'package:myapp/features/shop/logic/shop_logic.dart';
import 'package:myapp/features/shop/widgets/shop_product_grid_widget.dart';
import 'package:myapp/shared/model/product.dart';
import 'package:myapp/shared/model/shop.dart';
import 'package:myapp/shared/widgets/common/app_spacing.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ShopProductScreen extends StatefulWidget {
  final String? searchValue;
  const ShopProductScreen({super.key, required this.title, this.searchValue});
  final String title;

  @override
  State<ShopProductScreen> createState() => _ShopProductScreenState();
}

class _ShopProductScreenState extends State<ShopProductScreen> {
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
    // Using mock data for now
    try {
      final List<Product> mockProducts = [
        Product(
          productId: 'product_1',
          productName: 'Thức ăn cho chó Royal Canin',
          description: 'Thức ăn dinh dưỡng cao cấp cho chó',
          category: 'food',
          status: true,
          shopId: 'shop_1',
        ),
        Product(
          productId: 'product_2',
          productName: 'Đồ chơi bóng cao su',
          description: 'Đồ chơi an toàn cho thú cưng',
          category: 'toy',
          status: true,
          shopId: 'shop_1',
        ),
        Product(
          productId: 'product_3',
          productName: 'Vòng cổ da cao cấp',
          description: 'Phụ kiện thời trang cho thú cưng',
          category: 'accessory',
          status: true,
          shopId: 'shop_2',
        ),
        Product(
          productId: 'product_4',
          productName: 'Thuốc tẩy giun cho mèo',
          description: 'Thuốc y tế chuyên dụng',
          category: 'medicine',
          status: true,
          shopId: 'shop_2',
        ),
      ];

      final List<Shop> mockShops = [
        Shop(
          shopId: 'shop_1',
          owner: 'Nguyễn Văn A',
          shopName: 'Pet Care Center',
          description: 'Trung tâm chăm sóc thú cưng',
          status: true,
          workingDays: 'Thứ 2 - Chủ nhật',
        ),
      ];

      for (var product in mockProducts) {
        _productKeys[product.productId] = GlobalKey();
      }

      if (_productList.isEmpty) {
        _productList.addAll(mockProducts);
      }

      if (_shopList.isEmpty) {
        _shopList.addAll(mockShops);
      }

      if (widget.searchValue != null && widget.searchValue!.isNotEmpty) {
        _searchController.text = widget.searchValue!;
      }

      // Initialize cart service with product data
      _cartService.initializeProductData(_productList);
    } catch (e) {
      // Handle error silently
    }
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
      appBar: AppBar(
        title: const Text('Sản phẩm thú cưng'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          _buildProductCategoryFilter(paddingResponsive),
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

  Widget _buildProductCategoryFilter(double paddingResponsive) {
    final categories = [
      {'key': null, 'label': 'Tất cả'},
      {'key': 'food', 'label': 'Thức ăn'},
      {'key': 'toy', 'label': 'Đồ chơi'},
      {'key': 'accessory', 'label': 'Phụ kiện'},
      {'key': 'medicine', 'label': 'Y tế'},
    ];

    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: paddingResponsive),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedCategory == category['key'];

          return Padding(
            padding: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
            child: FilterChip(
              label: Text(category['label'] as String),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = selected ? category['key'] : null;
                });
              },
              backgroundColor: Colors.grey[200],
              selectedColor: Colors.blue[100],
              checkmarkColor: Colors.blue[600],
            ),
          );
        },
      ),
    );
  }
}
