class CartItem {
  final String cartItemId;
  final String itemId;
  final String cartId;
  final String shopId;
  final bool isProduct;
  final double totalAmount;
  final int quantity;

  CartItem({
    required this.cartItemId,
    required this.itemId,
    required this.cartId,
    required this.shopId,
    required this.isProduct,
    required this.totalAmount,
    required this.quantity,
  });
}