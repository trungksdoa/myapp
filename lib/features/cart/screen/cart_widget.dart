import 'package:myapp/features/cart/screen/cart_screen.dart';
import 'package:myapp/features/cart/widgets/cart_empty_widget.dart';
import 'package:myapp/features/cart/widgets/cart_with_floating_buttons.dart';
import 'package:myapp/features/shop/logic/shop_logic.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'package:flutter/material.dart';

class CartWidget {
  final CartService _cartService;

  CartWidget(this._cartService);

  // Navigate to full cart screen
  void goToCartScreen(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const CartScreen()));
  }

  void modalShow(BuildContext context, CartService cartServices) {
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
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                goToCartScreen(context);
                              },
                              child: const Text(
                                'Xem tất cả',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
      barrierDismissible: true,
      useSafeArea: true,
    );
  }

  // Alternative modal that includes the cart content with floating buttons
  void modalShowWithFloatingButtons(
    BuildContext context,
    CartService cartServices,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Your Cart',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            goToCartScreen(context);
                          },
                          child: const Text(
                            'Xem tất cả',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(),

              // Cart content with floating buttons
              Expanded(
                child: _cartService.getCartCount() == 0
                    ? const CartEmptyWidget()
                    : CartWithFloatingButtons(cartService: _cartService),
              ),
            ],
          ),
        );
      },
    );
  }
}
