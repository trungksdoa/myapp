import 'package:flutter/material.dart';
import 'package:myapp/features/cart/widgets/cart_items_list_widget.dart';
import 'package:myapp/features/shop/logic/shop_logic.dart';
import 'package:myapp/route/navigate_helper.dart';
import 'package:provider/provider.dart';

class CartWithFloatingButtons extends StatefulWidget {
  final CartService cartService;

  const CartWithFloatingButtons({super.key, required this.cartService});

  @override
  State<CartWithFloatingButtons> createState() =>
      _CartWithFloatingButtonsState();
}

class _CartWithFloatingButtonsState extends State<CartWithFloatingButtons> {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollButtons = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Show scroll buttons when not at the top
    final showButtons = _scrollController.offset > 100;
    if (showButtons != _showScrollButtons) {
      setState(() {
        _showScrollButtons = showButtons;
      });
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Selector<CartService, int>(
      selector: (context, cartService) => cartService.getCartCount(),
      builder: (context, cartCount, child) {
        return Stack(
          children: [
            // Main cart content
            CustomScrollView(
              controller: _scrollController,
              slivers: [CartItemsListWidget(cartService: widget.cartService)],
            ),

            // Floating buttons
            if (_showScrollButtons) ...[
              // Scroll to top button
              Positioned(
                right: 16,
                top: 80,
                child: FloatingActionButton.small(
                  onPressed: _scrollToTop,
                  backgroundColor: Colors.blue.shade100,
                  foregroundColor: Colors.blue.shade700,
                  heroTag: "scroll_to_top",
                  child: const Icon(Icons.keyboard_arrow_up),
                ),
              ),

              // Scroll to bottom button
              Positioned(
                right: 16,
                top: 140,
                child: FloatingActionButton.small(
                  onPressed: _scrollToBottom,
                  backgroundColor: Colors.orange.shade100,
                  foregroundColor: Colors.orange.shade700,
                  heroTag: "scroll_to_bottom",
                  child: const Icon(Icons.keyboard_arrow_down),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
