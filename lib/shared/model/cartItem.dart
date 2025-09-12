class CartItem {
  final String cartItemId;
  final String itemId;
  final String cartId;
  final String shopId;
  final bool isProduct;
  final double totalAmount;
  int quantity;

  CartItem({
    required this.cartItemId,
    required this.itemId,
    required this.cartId,
    required this.shopId,
    required this.isProduct,
    required this.totalAmount,
    required this.quantity,
  });

  void updateQuantity(int newQuantity) {
    // Assuming quantity is mutable for this example
    // In a real-world scenario, you might want to return a new instance instead
    // if you are following immutability principles.
    if (newQuantity < 0) {
      throw Exception('Quantity cannot be negative');
    }

    quantity = newQuantity; // Uncomment if quantity is mutable
  }
}
