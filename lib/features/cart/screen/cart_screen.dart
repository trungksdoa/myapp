import 'package:flutter/material.dart';
import 'package:myapp/core/currency_format.dart';
import 'package:myapp/features/cart/widgets/cart_empty_widget.dart';
import 'package:myapp/features/cart/widgets/cart_items_list_widget.dart';
import 'package:myapp/features/cart/widgets/cart_with_floating_buttons.dart';
import 'package:myapp/features/shop/logic/shop_logic.dart';
import 'package:myapp/route/navigate_helper.dart';
import 'package:myapp/shared/widgets/common/app_spacing.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService _cartService = CartService();
  final _scrollController = ScrollController();
  bool _showScrollButtons = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final show = _scrollController.offset > 100;
      if (show != _showScrollButtons) {
        setState(() => _showScrollButtons = show);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() => _scrollController.animateTo(
    0,
    duration: const Duration(milliseconds: 500),
    curve: Curves.easeInOut,
  );
  void _scrollToBottom() => _scrollController.animateTo(
    _scrollController.position.maxScrollExtent,
    duration: const Duration(milliseconds: 500),
    curve: Curves.easeInOut,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Giỏ hàng',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          // Clear cart button
          Consumer<CartService>(
            builder: (context, cartService, child) {
              if (cartService.getCartCount() == 0) {
                return const SizedBox.shrink();
              }
              return IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () => _showClearCartDialog(),
                tooltip: 'Xóa tất cả',
              );
            },
          ),
        ],
      ),
      // cart_screen.dart (phần body)
      body: Consumer<CartService>(
        builder: (context, cartService, child) {
          if (cartService.getCartCount() == 0) {
            // Trống: dùng SliverFillRemaining + child Box (đã sửa)
            return CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: CartEmptyWidget(),
                ),
              ],
            );
          }

          // Có hàng: một CustomScrollView duy nhất + Stack để đặt FAB
          return Stack(
            children: [
              CustomScrollView(
                controller:
                    _scrollController, // chuyển controller lên CartScreen (xem dưới)
                slivers: [
                  // Danh sách item (sliver)
                  CartItemsListWidget(
                    cartService: _cartService,
                  ), // trả về SliverList
                  // Footer thanh toán (Box -> bọc SliverToBoxAdapter)
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: SafeArea(
                        child: Column(
                          children: [
                            Selector<CartService, num>(
                              selector: (_, s) => s.getTotalAmount(),
                              builder: (context, totalAmount, __) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Tổng cộng',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      Currency.formatVND(
                                        totalAmount.toDouble(),
                                      ),
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green[700],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            AppSpacing.vertical(16),
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: () =>
                                    NavigateHelper.goToOrderScreen(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade600,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.shopping_cart_checkout,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Thanh toán',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Các nút nổi cuộn lên/xuống: đặt ở đây thay vì trong CartWithFloatingButtons
              if (_showScrollButtons) ...[
                Positioned(
                  right: 16,
                  top: 80,
                  child: FloatingActionButton.small(
                    onPressed: _scrollToTop,
                    backgroundColor: Colors.blue.shade100,
                    foregroundColor: Colors.blue.shade700,
                    heroTag: 'scroll_to_top',
                    child: const Icon(Icons.keyboard_arrow_up),
                  ),
                ),
                Positioned(
                  right: 16,
                  top: 140,
                  child: FloatingActionButton.small(
                    onPressed: _scrollToBottom,
                    backgroundColor: Colors.orange.shade100,
                    foregroundColor: Colors.orange.shade700,
                    heroTag: 'scroll_to_bottom',
                    child: const Icon(Icons.keyboard_arrow_down),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  void _showClearCartDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Xóa tất cả sản phẩm',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Bạn có chắc chắn muốn xóa tất cả sản phẩm trong giỏ hàng không?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                _cartService.clearCart();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đã xóa tất cả sản phẩm trong giỏ hàng'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text(
                'Xóa tất cả',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
