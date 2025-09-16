import 'package:flutter/material.dart';
import 'package:flutter_cart/model/cart_model.dart';
import 'package:myapp/core/currency_format.dart';
import 'package:myapp/features/shop/logic/shop_logic.dart';
import 'package:myapp/shared/widgets/common/app_spacing.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatelessWidget {
  final CartModel cartItem;
  final CartService cartService;

  const ProductCard({
    super.key,
    required this.cartItem,
    required this.cartService,
  });

  @override
  Widget build(BuildContext context) {
    final product = cartService.getProductFromId(cartItem.productId);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          // Product image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[200],
              image: DecorationImage(
                image: AssetImage(
                  cartService.getProductImage(cartItem.productId),
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),

          AppSpacing.horizontal(12),

          // Product details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product name
                Text(
                  product.productName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                AppSpacing.vertical(4),

                // Product category badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Sản phẩm',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                AppSpacing.vertical(8),

                // Price
                Selector<CartService, double>(
                  selector: (context, cartService) =>
                      cartItem.variants.first.price * cartItem.quantity,
                  builder: (context, itemTotal, child) {
                    return Text(
                      Currency.formatVND(itemTotal),
                      style: TextStyle(
                        color: Colors.green[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Quantity controls
          Selector<CartService, int>(
            selector: (context, cartService) =>
                cartService.getItemQuantity(cartItem.productId),
            builder: (context, quantity, child) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      if (quantity <= 1) {
                        cartService.removeItemFromCart(cartItem);
                        return;
                      }
                      cartService.updateQuantity(cartItem, quantity - 1);
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(
                        Icons.remove,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  AppSpacing.horizontal(8),
                  Text(
                    '$quantity',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  AppSpacing.horizontal(8),
                  InkWell(
                    onTap: () {
                      cartService.updateQuantity(cartItem, quantity + 1);
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
