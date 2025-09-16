import 'package:flutter/material.dart';
import 'package:myapp/features/shop/logic/shop_logic.dart';
import 'package:provider/provider.dart';

class CartIconWidget extends StatefulWidget {
  final void Function() onCartPressed;
  const CartIconWidget({super.key, required this.onCartPressed});

  @override
  State<CartIconWidget> createState() => _CartIconWidgetState();
}

class _CartIconWidgetState extends State<CartIconWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: widget.onCartPressed,
          ),

          // Consumer DEEP - chỉ cho cart badge
          Consumer<CartService>(
            builder: (context, cartService, child) {
              final cartCount = cartService.getCartCount();
              if (cartCount == 0) return const SizedBox.shrink();

              return Positioned(
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
                      cartCount > 99 ? '99+' : cartCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
