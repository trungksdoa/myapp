import 'package:flutter/material.dart';
import 'package:myapp/features/cart/widgets/cart_icon_widget.dart';
import 'package:myapp/features/shop/logic/shop_logic.dart';
import 'package:myapp/route/navigate_helper.dart';

class ShopAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController searchController;
  final Function(String) onSearchChanged;
  final VoidCallback onCartPressed;
  final CartService cartService = CartService();

  ShopAppBarWidget({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
    required this.onCartPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: SizedBox(
        height: 50,
        child: TextField(
          controller: searchController,
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
          onChanged: onSearchChanged,
        ),
      ),
      // actions: [
      //   CartIconWidget(onCartPressed: () => NavigateHelper.goToCart(context)),
      // ],
    );
  }

  //
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
