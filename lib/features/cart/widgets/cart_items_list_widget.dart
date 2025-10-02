import 'package:flutter/material.dart';
import 'package:myapp/data/mock/shops_mock.dart';
import 'package:myapp/features/cart/widgets/product_card.dart';
import 'package:myapp/features/cart/widgets/service_card.dart';
import 'package:myapp/features/shop/logic/shop_logic.dart';
import 'package:myapp/shared/model/shop.dart';
import 'package:myapp/shared/widgets/common/app_spacing.dart';
import 'package:provider/provider.dart';

class CartItemsListWidget extends StatefulWidget {
  final CartService cartService;

  const CartItemsListWidget({super.key, required this.cartService});

  @override
  State<CartItemsListWidget> createState() => _CartItemsListWidgetState();
}

class _CartItemsListWidgetState extends State<CartItemsListWidget> {
  String _selectedCategory = 'all'; // 'all', 'service', 'product'

  // Method to get shop name from shopId
  String _getShopName(String shopId) {
    final shop = mockShops.firstWhere(
      (shop) => shop.shopId == shopId,
      orElse: () => Shop(
        shopId: shopId,
        owner: '',
        shopName: 'Unknown Shop',
        description: '',
        status: true,
        workingDays: '',
      ),
    );
    return shop.shopName;
  }

  // Filter cart items by category
  List<dynamic> _filterItemsByCategory(List<dynamic> cartItems) {
    if (_selectedCategory == 'all') {
      return cartItems;
    }

    return cartItems.where((item) {
      // Get product from cart item to check its category
      final product = widget.cartService.getProductFromId(item.productId);
      final category = product.category;

      if (_selectedCategory == 'service') {
        // Dịch vụ: care, medical
        return category == 'care' || category == 'medical';
      } else if (_selectedCategory == 'product') {
        // Sản phẩm: food, accessory, health, other
        return category == 'food' ||
            category == 'accessory' ||
            category == 'health' ||
            category == 'other';
      }

      return false;
    }).toList();
  }

  // Group cart items by shop
  Map<String, List<dynamic>> _groupItemsByShop(List<dynamic> cartItems) {
    final groupedItems = <String, List<dynamic>>{};

    for (final item in cartItems) {
      final shopId = item.productMeta?['shopId'] ?? 'unknown';
      final shopName = _getShopName(shopId);

      if (!groupedItems.containsKey(shopName)) {
        groupedItems[shopName] = [];
      }
      groupedItems[shopName]!.add(item);
    }

    return groupedItems;
  }

  @override
  Widget build(BuildContext context) {
    return Selector<CartService, int>(
      selector: (context, cartService) => cartService.getCartCount(),
      builder: (context, cartCount, child) {
        final cartItems = widget.cartService.getCartItems();
        final filteredItems = _filterItemsByCategory(cartItems);
        final groupedItems = _groupItemsByShop(filteredItems);

        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            // First item: Filter buttons
            if (index == 0) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Filter buttons
                  Container(
                    height: 50,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      children: [
                        // All button
                        _buildFilterButton('Tất cả', 'all'),
                        // Service button
                        _buildFilterButton('Dịch vụ', 'service'),
                        // Product button
                        _buildFilterButton('Sản phẩm', 'product'),
                      ],
                    ),
                  ),
                  const Divider(),
                ],
              );
            }

            // Shop sections
            final shopNames = groupedItems.keys.toList();
            final currentShopName =
                shopNames[index - 1]; // -1 vì index 0 là filter buttons
            final shopItems = groupedItems[currentShopName]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Shop header
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  color: Colors.grey[100],
                  child: Row(
                    children: [
                      Icon(Icons.store, size: 20, color: Colors.grey[700]),
                      AppSpacing.horizontal(8),
                      Text(
                        currentShopName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                // Shop items - using specific cards for services and products
                ...shopItems.map((cartItem) {
                  // Get product to determine if it's a service or product
                  final product = widget.cartService.getProductFromId(
                    cartItem.productId,
                  );
                  final isService =
                      product.category == 'care' ||
                      product.category == 'medical';

                  if (isService) {
                    return ServiceCard(
                      cartItem: cartItem,
                      cartService: widget.cartService,
                    );
                  } else {
                    return ProductCard(
                      cartItem: cartItem,
                      cartService: widget.cartService,
                    );
                  }
                }),
              ],
            );
          }, childCount: groupedItems.length + 1), // +1 cho filter buttons
        );
      },
    );
  }

  Widget _buildFilterButton(String label, String category) {
    final isSelected = _selectedCategory == category;
    return Container(
      margin: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategory = category;
          });
        },
        backgroundColor: Colors.grey[200],
        selectedColor: Colors.blue[100],
        checkmarkColor: Colors.blue[600],
      ),
    );
  }
}
