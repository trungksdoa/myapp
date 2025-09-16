import 'package:flutter/material.dart';
import 'package:flutter_cart/flutter_cart.dart' as cart_package;
import 'package:flutter_cart/model/cart_model.dart';
import 'package:myapp/shared/model/product.dart';

class CartService extends ChangeNotifier {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  final cart_package.FlutterCart _flutterCart = cart_package.FlutterCart();
  List<Product> _productList = [];

  final Map<String, String> _productImages = {
    'prod_001': 'assets/images/Home1.png',
    'prod_002': 'assets/images/Home2.png',
    'prod_003': 'assets/images/Home3.png',
  };

  // Initialize product data
  void initializeProductData(List<Product> products) {
    _productList = products;
  }

  // Getters
  List<CartModel> getCartItems() => _flutterCart.cartItemsList;
  int getCartCount() => _flutterCart.cartLength;
  double getTotalAmount() => _flutterCart.total;

  int getItemQuantity(String productId) {
    final item = _flutterCart.cartItemsList.firstWhere(
      (item) => item.productId == productId,
      orElse: () => CartModel(
        productId: '',
        productName: '',
        productImages: [],
        variants: [],
        productMeta: {},
        productDetails: '',
      ),
    );
    return item.quantity;
  }

  // Get product image by ID
  String getProductImage(String productId) {
    return _productImages.containsKey(productId)
        ? _productImages[productId]!
        : 'assets/images/default_group_avatar.png';
  }

  // Find product by ID
  Product getProductFromId(String productId) {
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

  // Add product to cart
  void addToCart(Product product, {Map<String, dynamic> options = const {}}) {
    final meta = <String, dynamic>{
      'items': product.toJson(),
      'services': options,
      'shopId': product.shopId, // Thêm shopId trực tiếp
    };
    try {
      _flutterCart.addToCart(
        cartModel: CartModel(
          productId: product.productId,
          productName: product.productName,
          productImages: [getProductImage(product.productId)],
          variants: [
            ProductVariant(price: product.productDetail?.price ?? 0.0),
          ],
          productMeta: meta, //Change from product product.toJson() to meta
          productDetails: '',
        ),
      );
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding to cart: $e');
      rethrow;
    }
  }

  // Remove item from cart
  void removeItemFromCart(CartModel item) {
    try {
      _flutterCart.removeItem(item.productId, item.variants);
      notifyListeners();
    } catch (e) {
      debugPrint('Error removing from cart: $e');
      rethrow;
    }
  }

  // Update quantity of item in cart
  void updateQuantity(CartModel item, int newQuantity) {
    try {
      if (newQuantity <= 0) {
        removeItemFromCart(item);
        return;
      }

      _flutterCart.updateQuantity(item.productId, item.variants, newQuantity);
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating quantity: $e');
      rethrow;
    }
  }

  // Clear entire cart
  void clearCart() {
    try {
      _flutterCart.clearCart();
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing cart: $e');
      rethrow;
    }
  }

  // Check if product is in cart
  bool isProductInCart(String productId) {
    return _flutterCart.cartItemsList.any(
      (item) => item.productId == productId,
    );
  }

  // Get quantity of specific product in cart
  int getProductQuantityInCart(String productId) {
    final cartItem = _flutterCart.cartItemsList
        .where((item) => item.productId == productId)
        .firstOrNull;

    return cartItem?.quantity ?? 0;
  }

  // Add multiple products to cart
  void addMultipleToCart(List<Product> products) {
    try {
      for (var product in products) {
        addToCart(product);
      }
    } catch (e) {
      debugPrint('Error adding multiple products to cart: $e');
      rethrow;
    }
  }

  // Get cart summary
  Map<String, dynamic> getCartSummary() {
    return {
      'totalItems': getCartCount(),
      'totalAmount': getTotalAmount(),
      'products': getCartItems()
          .map(
            (item) => {
              'productId': item.productId,
              'productName': item.productName,
              'quantity': item.quantity,
              'price': item.variants.first.price,
            },
          )
          .toList(),
    };
  }

  // Update product images
  void updateProductImages(Map<String, String> images) {
    _productImages.addAll(images);
    notifyListeners();
  }
}
