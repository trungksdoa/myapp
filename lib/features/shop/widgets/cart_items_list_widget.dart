import 'package:flutter/material.dart';
import 'package:myapp/core/currency_format.dart';
import 'package:myapp/features/shop/logic/shop_logic.dart';
import 'package:myapp/shared/widgets/common/app_spacing.dart';
import 'package:provider/provider.dart';

class CartItemsListWidget extends StatelessWidget {
  final CartService cartService;

  const CartItemsListWidget({super.key, required this.cartService});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final cartItem = cartService.getCartItems()[index];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                      cartService.getProductImage(cartItem.productId),
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
                    Text(
                      cartService
                          .getProductFromId(cartItem.productId)
                          .productName,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    AppSpacing.vertical(4),
                    Text(
                      Currency.formatVND(cartService.getTotalAmount()),
                      style: TextStyle(
                        color: Colors.green[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Consumer DEEPEST - chỉ cho quantity controls
              Consumer<CartService>(
                builder: (context, cartService, child) {
                  return Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          cartService.removeItemFromCart(cartItem);
                        },
                      ),
                      Text(
                        '${cartItem.quantity}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () {
                          cartService.updateQuantity(
                            cartItem,
                            cartItem.quantity + 1,
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      }, childCount: cartService.getCartCount()),
    );
  }
}
