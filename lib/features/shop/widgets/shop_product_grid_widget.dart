import 'package:flutter/material.dart';
import 'package:myapp/core/currency_format.dart';
import 'package:myapp/features/shop/logic/shop_logic.dart';
import 'package:myapp/route/navigate_helper.dart';
import 'package:myapp/shared/model/product.dart';
import 'package:myapp/shared/widgets/common/notification.dart';
import 'package:provider/provider.dart';
import 'package:myapp/shared/widgets/cards/product_card.dart';

class ShopProductGridWidget extends StatefulWidget {
  final List<Product> productList;
  final Map<String, GlobalKey> productKeys;
  final TextEditingController searchController;
  final double paddingResponsive;
  final void Function()? openCart;
  final int crossAxisCount;
  final double childAspectRatio;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final bool isScrollable;

  const ShopProductGridWidget({
    super.key,
    required this.productList,
    required this.productKeys,
    required this.searchController,
    required this.paddingResponsive,
    this.openCart,
    this.crossAxisCount = 4,
    this.childAspectRatio = 0.6,
    this.crossAxisSpacing = 10,
    this.mainAxisSpacing = 16,
    this.isScrollable = false,
  });

  @override
  State<ShopProductGridWidget> createState() => _ShopProductGridWidgetState();
}

class _ShopProductGridWidgetState extends State<ShopProductGridWidget> {
  final ScrollController _scrollController = ScrollController();
  final int _itemsPerPage = 10;
  int _currentMaxItems = 10;
  bool _isLoading = false;
  List<Product> _displayedProducts = [];

  @override
  void initState() {
    super.initState();
    _loadInitialProducts();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(ShopProductGridWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.productList != widget.productList ||
        oldWidget.searchController.text != widget.searchController.text) {
      _loadInitialProducts();
    }
  }

  void _loadInitialProducts() {
    setState(() {
      _currentMaxItems = _itemsPerPage;
      _displayedProducts = _getFilteredProducts().take(_itemsPerPage).toList();
    });
  }

  List<Product> _getFilteredProducts() {
    if (widget.searchController.text.isEmpty) {
      return widget.productList;
    }
    return widget.productList
        .where(
          (product) => product.productName.toLowerCase().contains(
            widget.searchController.text.toLowerCase(),
          ),
        )
        .toList();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading) {
      _loadMoreProducts();
    }
  }

  void _loadMoreProducts() {
    final filteredProducts = _getFilteredProducts();

    if (_currentMaxItems >= filteredProducts.length) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate network delay for better UX
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      setState(() {
        _currentMaxItems += _itemsPerPage;
        _displayedProducts = filteredProducts.take(_currentMaxItems).toList();
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _getFilteredProducts();
    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Products count info
        Padding(
          padding: EdgeInsets.all(widget.paddingResponsive * 1.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Hiển thị ${_displayedProducts.length} / ${filteredProducts.length} sản phẩm',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (_isLoading)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
            ],
          ),
        ),

        // Product Grid
        widget.isScrollable
            ? Expanded(child: _buildGridView())
            : _buildGridView(),
      ],
    );

    return widget.isScrollable
        ? content
        : SingleChildScrollView(child: content);
  }

  Widget _buildGridView() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final availableWidth = screenWidth - (widget.paddingResponsive * 2);

    // Calculate responsive grid parameters
    int crossAxisCount;
    double childAspectRatio;

    if (screenWidth < 360) {
      // Very small screens (phones in portrait)
      crossAxisCount = 2;
      childAspectRatio = 0.65; // Taller cards for more content space
    } else if (screenWidth < 600) {
      // Small screens (normal phones)
      crossAxisCount = 2;
      childAspectRatio = 0.7;
    } else if (screenWidth < 900) {
      // Medium screens (tablets portrait)
      crossAxisCount = 3;
      childAspectRatio = 0.75;
    } else {
      // Large screens (tablets landscape, desktop)
      crossAxisCount = 4;
      childAspectRatio = 0.8;
    }

    // Calculate card dimensions to prevent overflow
    final cardWidth =
        (availableWidth - (widget.crossAxisSpacing * (crossAxisCount - 1))) /
        crossAxisCount;
    final cardHeight = cardWidth / childAspectRatio;

    // Ensure minimum card height for content
    final minCardHeight = 280.0;
    if (cardHeight < minCardHeight) {
      childAspectRatio = cardWidth / minCardHeight;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.builder(
          controller: widget.isScrollable ? _scrollController : null,
          shrinkWrap: true,
          physics: widget.isScrollable
              ? const AlwaysScrollableScrollPhysics()
              : const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: widget.paddingResponsive),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: childAspectRatio,
            crossAxisSpacing: widget.crossAxisSpacing,
            mainAxisSpacing: widget.mainAxisSpacing,
          ),
          itemCount:
              _displayedProducts.length +
              (_isLoading && widget.isScrollable ? 1 : 0),
          itemBuilder: (context, index) {
            // Loading indicator at the end
            if (index == _displayedProducts.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 8),
                      Text(
                        'Đang tải...',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              );
            }

            final product = _displayedProducts[index];

            return ProductCard(
              key: widget.productKeys[product.productId],
              id: product.productId,
              imageUrl:
                  "https://cdn3.iconfinder.com/data/icons/it-and-ui-mixed-filled-outlines/48/default_image-1024.png",
              categoryName: _getCategoryDisplayName(product.category),
              productName: product.productName,
              price: Currency.formatVND(
                product.productDetail!.price,
              ).replaceAll('₫', ''),
              currency: '₫',
              originalPrice: Currency.formatVND(product.productDetail!.price),
              // discountPercentage: _calculateDiscountPercentage(
              //   product.productDetail!.originalPrice,
              //   product.productDetail!.price,
              // ),
              rating: 4.2,
              reviewCount: 42,
              isAvailable: true,
              isFavorite: false, // TODO: Implement favorite logic
              badge: _getProductBadge(product),
              onTap: () {
                NavigateHelper.goToDetailProduct(
                  context,
                  product.productId,
                  category: product.category,
                );
              },
              onFavoritePressed: () {
                // TODO: Implement favorite logic
                _toggleFavorite(product);
              },
              onAddToCart: () {
                _addToCart(product);
              },
              showAddToCartButton: false,
              borderRadius: 12.0,
              cardColor: Colors.white,
              textColor: Colors.black87,
            );
          },
        );
      },
    );
  }

  String _getCategoryDisplayName(String? category) {
    if (category == null || category.isEmpty) {
      return 'Thú cưng';
    }

    // Map category codes to display names
    final categoryMap = {
      'food': 'Thức ăn',
      'toy': 'Đồ chơi',
      'medicine': 'Y tế',
      'accessory': 'Phụ kiện',
      'grooming': 'Chăm sóc',
    };

    return categoryMap[category.toLowerCase()] ?? 'Thú cưng';
  }

  double? _calculateDiscountPercentage(
    double? originalPrice,
    double currentPrice,
  ) {
    if (originalPrice == null || originalPrice <= currentPrice) {
      return null;
    }
    return ((originalPrice - currentPrice) / originalPrice) * 100;
  }

  String? _getProductBadge(Product product) {
    // if (product.isNew == true) {
    //   return 'Mới';
    // }
    // if (product.isBestSeller == true) {
    //   return 'Bán chạy';
    // }
    // if (product.isPopular == true) {
    //   return 'Phổ biến';
    // }
    return 'Mới';
  }

  void _toggleFavorite(Product product) {
    // TODO: Implement favorite toggle logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã thêm ${product.productName} vào yêu thích'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _addToCart(Product product) {
    try {
      context.read<CartService>().addToCart(product);

      if (!mounted) return;

      NotificationUtils.showNotificationWithAction(
        context,
        "Đã thêm ${product.productName} vào giỏ hàng",
        actionLabel: "Xem giỏ hàng",
        onPressed: () {
          widget.openCart?.call();
        },
        actionTextColor: Colors.yellow,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Không thể thêm sản phẩm vào giỏ hàng'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }
}
