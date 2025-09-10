import 'package:flutter/material.dart';
import 'package:myapp/core/currency_format.dart';
import 'package:myapp/core/utils/device_size.dart';
import 'package:myapp/model/cartItem.dart';
import 'package:myapp/mock_data/shop_mock.dart';
import 'package:myapp/model/product.dart';
import 'package:myapp/widget/common/app_spacing.dart';
import 'package:flutter_product_card/flutter_product_card.dart';
import 'package:fly_to_cart/fly_to_cart.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key, required this.title});
  final String title;
  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Product> _productList = [];
  // Mock cart items
  // {productId: CartItem}
  final Map<String, CartItem> _cartItems = {};
  final Set<String> _processingIds = {};

  // Keys for product cards to get their positions
  final Map<String, GlobalKey> _productKeys = {};

  // Mock product price
  final double _productPrice = 50000;

  final Map<String, String> _productImages = {
    'prod_001': 'assets/images/Home1.png',
    'prod_002': 'assets/images/Home2.png',
    'prod_003': 'assets/images/Home3.png',
  };

  // Create a BuildContext field to store the context from build method

  @override
  void initState() {
    super.initState();
    for (var product in mockProducts) {
      _productKeys[product.productId] = GlobalKey();
    }

    // Initialize product list
    if (_productList.isEmpty) {
      _productList.addAll(mockProducts);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double paddingResponsive = DeviceSize.getResponsivePadding(width);
    return FlyToCartController<CartItem>(
      basketItems: _cartItems.values.toList(),
      processingItemIds: _processingIds,
      onViewBasket: () {
        /* Show cart */
        modalShow();
      },
      totalCalculator: (items) {
        /* Calculate total string */
        return Currency.formatVND(
          items.fold(0, (sum, item) => sum + item.totalAmount * item.quantity),
        );
      },
      basketItemBuilder: (context, item) {
        /* Build item preview */
        return ListTile(
          title: Text('Item ID: ${item.itemId}'),
          subtitle: Text('Quantity: ${item.quantity}'),
          trailing: Text(Currency.formatVND(item.totalAmount * item.quantity)),
        );
      },
      child: Builder(
        builder: (builderContext) {
          return Scaffold(
            appBar: AppBar(
              title: SizedBox(
                height: 40,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search products',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  ),
                  onChanged: (value) {
                    onSearch(value);
                  },
                ),
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.shopping_cart),
                        onPressed: () {
                          modalShow();
                        },
                      ),
                      if (_cartItems.isNotEmpty)
                        Positioned(
                          right: 6,
                          top: 6,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            constraints: const BoxConstraints(
                              minWidth: 20,
                              minHeight: 20,
                            ),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                _cartItems.length > 99
                                    ? '99+'
                                    : _cartItems.length.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            body: Padding(
              padding: EdgeInsets.all(paddingResponsive * 1.5),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Display 2 items per row
                  childAspectRatio:
                      0.7, // Adjust this ratio based on your card's dimensions
                  crossAxisSpacing: 10, // Horizontal spacing between items
                  mainAxisSpacing: 16, // Vertical spacing between items
                ),
                itemCount: _productList.length,
                itemBuilder: (context, index) {
                  final product = _productList[index];
                  if (_searchController.text.isNotEmpty &&
                      !product.productName.toLowerCase().contains(
                        _searchController.text.toLowerCase(),
                      )) {
                    return const SizedBox.shrink();
                  }
                  return ProductCard(
                    key: _productKeys[product.productId],
                    imageUrl:
                        //add your image url here
                        'https://encrypted-tbn3.gstatic.com/shopping?q=tbn:ANd9GcQndSK7hvssofrM2uzv75NxVjrkAwH3RwyqWcBesUsmq1ipmkuljRr6x_SRbCKaBXvjTR9CKfAaEFtmUFw-69o52wgVMgk2hp8KDYr4FvKtQ8ZfKewgOW4gDQ&usqp=CAE4',
                    categoryName: 'Pants',
                    productName: 'Men Linen Pants',
                    price: Currency.formatVND(product.productDetail!.price),
                    onTap: () {
                      // Handle card tap if needed
                    },
                    onFavoritePressed: () {
                      FlyToCartController.of(context).triggerAnimation(
                        itemKey: _productKeys[product.productId]!,
                        imageUrl: _productImages[product.productId]!,
                      );
                      // Also call your add to cart function
                      _addTosCart(product.productId, product.shopId);
                    },
                    shortDescription:
                        'comfortable & airy.', // Optional short description
                    rating: 4.2, // Optional rating
                    discountPercentage: 35.0, // Optional discount percentage
                    isAvailable: true, // Optional availability status
                    cardColor: Colors.white, // Optional card background color
                    textColor: Colors.black, // Optional text color
                    borderRadius: 8.0, // Optional border radius
                    // You may need to adjust width and height to fit the grid properly
                    width: double.infinity,
                    height: double.infinity,
                  );
                },
              ),
            ),
          );
        },
      ),
    );
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
            _cartItems.isEmpty
                ? SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.shopping_cart_outlined,
                              size: 64,
                              color: Colors.grey,
                            ),
                            AppSpacing.vertical(16),
                            const Text(
                              'Your cart is empty',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final cartItem = _cartItems.values.toList()[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey[200],
                                image: DecorationImage(
                                  image: AssetImage(
                                    _productImages[cartItem.itemId] ??
                                        'assets/images/default_group_avatar.png',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            AppSpacing.horizontal(12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Find product name from mock data
                                  Text(
                                    extractProductFromId(
                                      cartItem.itemId,
                                    ).productName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  AppSpacing.vertical(4),
                                  Text(
                                    Currency.formatVND(cartItem.totalAmount),
                                    style: TextStyle(
                                      color: Colors.green[700],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: () {
                                    setState(() {
                                      if (cartItem.quantity > 1) {
                                        cartItem.quantity -= 1;
                                      } else {
                                        _cartItems.remove(cartItem.itemId);
                                      }
                                      // Close and reopen the modal to refresh
                                      Navigator.of(context).pop();
                                      if (_cartItems.isNotEmpty) {
                                        modalShow();
                                      }
                                    });
                                  },
                                ),
                                Text(
                                  '${cartItem.quantity}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  onPressed: () {
                                    setState(() {
                                      cartItem.quantity += 1;
                                      // Close and reopen the modal to refresh
                                      Navigator.of(context).pop();
                                      modalShow();
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }, childCount: _cartItems.values.length),
                  ),
            if (_cartItems.isNotEmpty)
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
                            'Total',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            Currency.formatVND(
                              _cartItems.values.fold(
                                0,
                                (sum, item) =>
                                    sum + item.totalAmount * item.quantity,
                              ),
                            ),
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
                            // Handle checkout
                            Navigator.of(context).pop();
                            // You can navigate to checkout page here
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Checkout',
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

  Product extractProductFromId(String productId) {
    return _productList.firstWhere(
      (p) => p.productId == productId,
      orElse: () => Product(
        productId: '',
        productName: 'Unknown Product',
        description: '',
        shopId: '',
      ),
    );
  }

  void _addTosCart(String productId, String shopId) {
    final GlobalKey? itemKey = _productKeys[productId];
    final String? imageUrl = _productImages[productId];

    // First update the cart items
    setState(() {
      // Get the existing item or create a new one
      CartItem? existingItem = _cartItems[productId];
      if (existingItem != null) {
        // Increment quantity
        existingItem.quantity += 1;
      } else {
        // Create new cart item
        _cartItems[productId] = CartItem(
          itemId: productId,
          quantity: 1,
          totalAmount: _productPrice,
          cartItemId: '',
          cartId: '',
          shopId: '',
          isProduct: true,
        );
      }

      // Add to processing set to trigger animation
      _processingIds.add(productId);
    });

    // Remove from processing after animation completes
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _processingIds.remove(productId);
        });
      }
    });
  }
}
