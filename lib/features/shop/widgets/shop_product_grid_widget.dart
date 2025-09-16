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
    this.crossAxisCount = 2,
    this.childAspectRatio = 0.7,
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
          child: Text(
            'Hiển thị ${_displayedProducts.length} / ${filteredProducts.length} sản phẩm',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
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
    return GridView.builder(
      controller: widget.isScrollable ? _scrollController : null,
      shrinkWrap: true,
      physics: widget.isScrollable
          ? const AlwaysScrollableScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.crossAxisCount,
        childAspectRatio: widget.childAspectRatio,
        crossAxisSpacing: widget.crossAxisSpacing,
        mainAxisSpacing: widget.mainAxisSpacing,
      ),
      itemCount: _displayedProducts.length + (_isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _displayedProducts.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final product = _displayedProducts[index];

        return ProductCard(
          key: widget.productKeys[product.productId],
          imageUrl:
              "https://cdn3.iconfinder.com/data/icons/it-and-ui-mixed-filled-outlines/48/default_image-1024.png",
          categoryName: 'Thực phẩm bổ sung cho thú cưng',
          productName: product.productName,
          price: Currency.formatVND(product.productDetail!.price),
          onTap: () {
            NavigateHelper.goToDetailProduct(
              context,
              product.productId,
              category: product.category,
            );
          },
          onFavoritePressed: () {
            context.read<CartService>().addToCart(product);
            NotificationUtils.showNotificationWithAction(
              context,
              "Đã thêm ${product.productName} vào giỏ hàng",
              actionLabel: "Xem giỏ hàng",
              onPressed: () {
                widget.openCart?.call();
              },
              actionTextColor: Colors.yellow,
            );
          },
          shortDescription: product.description,
          rating: 4.2,
          isAvailable: true,
          cardColor: Colors.white,
          textColor: Colors.black,
          borderRadius: 16.0,
        );
      },
    );
  }
}
