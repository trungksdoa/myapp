import 'package:myapp/features/shop/logic/shop_logic.dart';

class Cart {
  final String id;
  final String accountId;
  final double totalAmount;

  Cart(
    CartService cartService, {
    required this.id,
    required this.accountId,
    required this.totalAmount,
  });
}
