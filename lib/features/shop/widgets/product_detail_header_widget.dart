import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:myapp/features/cart/widgets/cart_icon_widget.dart';
import 'package:myapp/features/cart/screen/cart_widget.dart';
import 'package:myapp/features/shop/logic/shop_logic.dart';

class ProductDetailHeaderWidget extends StatelessWidget {
  final double padding;
  final VoidCallback? onBackPressed;
  final VoidCallback? onFavoritePressed;
  final CartService _cartService = CartService();

  ProductDetailHeaderWidget({
    super.key,
    required this.padding,
    this.onBackPressed,
    this.onFavoritePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: onBackPressed,
            icon: const Icon(Ionicons.arrow_back, color: Colors.black),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              shadowColor: Colors.black12,
              elevation: 2,
            ),
          ),
          CartIconWidget(
            onCartPressed: () =>
                CartWidget(_cartService).goToCartScreen(context),
          ),
        ],
      ),
    );
  }
}
