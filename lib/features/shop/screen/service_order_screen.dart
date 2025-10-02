import 'package:flutter/material.dart';
import 'package:myapp/core/currency_format.dart';
import 'package:myapp/data/mock/shops_mock.dart';
import 'package:myapp/features/shop/logic/shop_logic.dart';
// TODO: Comment out when API is ready
import 'package:myapp/data/service_locator.dart';
import 'package:myapp/route/navigate_helper.dart';
import 'package:myapp/shared/model/shop.dart';
import 'package:myapp/shared/model/product.dart';
import 'package:provider/provider.dart';

class ServiceOrderScreen extends StatefulWidget {
  final bool? directBuy;
  final Product? product;
  final String? datetime;
  final String? note;

  const ServiceOrderScreen({
    super.key,
    this.directBuy = false,
    this.product,
    this.datetime,
    this.note,
  });

  @override
  State<ServiceOrderScreen> createState() => _ServiceOrderScreenState();
}

class _ServiceOrderScreenState extends State<ServiceOrderScreen> {
  final String service = 'care';

  // Define theme colors
  final Color primaryColor = const Color(0xFF4CB9E7);
  final Color primaryLightColor = const Color(0xFFE6F4F7);

  @override
  void initState() {
    super.initState();
    // TODO: Replace with service call when API is ready
    _initializeData();
  }

  void _initializeData() async {
    try {
      final productService = ServiceLocator().productService;
      final products = await productService.getAllProducts();
      CartService().initializeProductData(products);
    } catch (e) {
      // Fallback to mock data if service fails
      // CartService().initializeProductData(mockProducts);
    }
  }

  Future<String> _getShopName(String shopId) async {
    // TODO: Replace with service call when API is ready
    try {
      final shopService = ServiceLocator().shopService;
      final shop = await shopService.getShopById(shopId);
      return shop?.shopName ?? 'Unknown Shop';
    } catch (e) {
      // Fallback to mock data
      return 'Unknown Shop';
      // try {
      //   final shop = mockShops.firstWhere((shop) => shop.shopId == shopId);
      //   return shop.shopName;
      // } catch (e) {
      //   return 'Unknown Shop';
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Selector<CartService, int>(
      selector: (context, cartService) => cartService.getCartCount(),
      builder: (context, cartCount, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Xác nhận đơn dịch vụ',
              style: TextStyle(color: Colors.black87),
            ),
            backgroundColor: Colors.white,
            elevation: 0.5,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black87),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: 100, // Extra padding for fixed button
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Customer Info Section
                _buildCustomerInfoCard(),
                const SizedBox(height: 16),

                // Service Items
                _buildServiceItemsCard(),
                const SizedBox(height: 16),

                // Note Section (if note exists)
                if (widget.note != null && widget.note!.isNotEmpty)
                  _buildNoteCard(),
                if (widget.note != null && widget.note!.isNotEmpty)
                  const SizedBox(height: 16),

                // Total Section
                _buildTotalSection(),
              ],
            ),
          ),

          // Fixed bottom button
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle confirm action
                    _handleConfirmOrder();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Xác nhận đặt hàng',
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
            ),
          ),

          // Alternative: Floating Action Button (uncomment if preferred)
          // floatingActionButton: FloatingActionButton.extended(
          //   onPressed: () {
          //     _handleConfirmOrder();
          //   },
          //   backgroundColor: primaryColor,
          //   label: Text(
          //     'Xác nhận',
          //     style: TextStyle(
          //       fontWeight: FontWeight.bold,
          //       color: Colors.white,
          //     ),
          //   ),
          //   icon: Icon(
          //     Icons.check_circle_outline,
          //     color: Colors.white,
          //   ),
          // ),
          // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }

  void _handleConfirmOrder() {
    // Handle confirm action here
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Xác nhận đặt hàng',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text('Bạn có chắc chắn muốn đặt hàng không?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Hủy', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Process order here
                _processOrder();
              },
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
              child: Text('Xác nhận', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _processOrder() async {
    // Giả lập gọi server 1.2s
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await Future.delayed(const Duration(milliseconds: 1200));
      // server trả về orderId giả lập
      final String orderId = DateTime.now().millisecondsSinceEpoch.toString();

      if (!mounted) return;
      Navigator.of(context).pop(); // đóng loading

      // Điều hướng sang màn thành công
      NavigateHelper.goToOrderSuccess(context, orderId);
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop(); // đóng loading
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Có lỗi khi đặt hàng: $e')));
    }
  }

  Widget _buildCustomerInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            Text(
              'Thông tin khách hàng',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            _buildInfoRow('Tên khách hàng:', 'Mèo thần chết'),
            _buildInfoRow('Số điện thoại:', '0912345678'),
            _buildInfoRow('Địa chỉ:', 'Đại học fpt, Quận 9, tp Hồ Chí Minh'),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceItemsCard() {
    return Card(
      child: Consumer<CartService>(
        builder: (context, cartService, child) {
          // If direct buy, only show the selected product
          if (widget.directBuy == true && widget.product != null) {
            final product = widget.product!;
            final shopId = product.shopId;

            return FutureBuilder<String>(
              future: _getShopName(shopId),
              builder: (context, snapshot) {
                final shopName = snapshot.data ?? 'Loading...';

                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Shop Header
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: primaryLightColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.store, color: primaryColor),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            shopName,
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      if (product.category == 'care')
                        _buildServiceItem(
                          cartService.getProductImage(product.productId),
                          product.productName,
                          '60 phút',
                          Currency.formatVND(product.productDetail?.price ?? 0),
                          product.description,
                          DateTime.now().add(Duration(days: 1)).toString(),
                        )
                      else
                        _buildProductItem(
                          cartService.getProductImage(product.productId),
                          product.productName,
                          Currency.formatVND(product.productDetail?.price ?? 0),
                          1,
                        ),
                    ],
                  ),
                );
              },
            );
          }

          // Otherwise show all items from cart grouped by shop
          final cartItems = cartService.getCartItems();
          final Map<String, List<dynamic>> itemsByShop = {};

          // Group items by shop
          for (var item in cartItems) {
            final shopId = item.productMeta?['shopId'] ?? 'unknown';
            if (!itemsByShop.containsKey(shopId)) {
              itemsByShop[shopId] = [];
            }
            itemsByShop[shopId]!.add(item);
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...itemsByShop.entries.map((entry) {
                  final shopId = entry.key;
                  final shopItems = entry.value;
                  // TODO: Replace with service call when API is ready
                  final shopName = mockShops
                      .firstWhere(
                        (shop) => shop.shopId == shopId,
                        orElse: () => Shop(
                          shopId: shopId,
                          shopName: 'Unknown Shop',
                          description: '',
                          owner: '',
                          status: true,
                          workingDays: '',
                        ),
                      )
                      .shopName;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Shop Header
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: primaryLightColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.store, color: primaryColor),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            shopName,
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Items from this shop
                      ...shopItems.map((item) {
                        final product = cartService.getProductFromId(
                          item.productId,
                        );
                        final isService = product.category == 'care';

                        if (isService) {
                          return _buildServiceItem(
                            cartService.getProductImage(item.productId),
                            item.productName,
                            '60 phút', // Get from metadata if available
                            Currency.formatVND(
                              item.variants.first.price * item.quantity,
                            ),
                            product.description,
                            DateTime.now().add(Duration(days: 1)).toString(),
                          );
                        } else {
                          return _buildProductItem(
                            cartService.getProductImage(item.productId),
                            item.productName,
                            Currency.formatVND(
                              item.variants.first.price * item.quantity,
                            ),
                            item.quantity,
                          );
                        }
                      }),

                      const SizedBox(height: 16),
                    ],
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildServiceItem(
    String imagePath,
    String serviceName,
    String duration,
    String price,
    String description,
    String appointmentTime,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Flexible(
                        child: Text(
                          serviceName,
                          style: TextStyle(fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),

                    Text('x1', style: TextStyle(color: Colors.grey)),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(duration, style: TextStyle(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: primaryLightColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Lịch hẹn: $appointmentTime',
                    style: TextStyle(fontSize: 12, color: primaryColor),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  price,
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // New Product Item Widget - Simpler than Service Item
  Widget _buildProductItem(
    String imagePath,
    String productName,
    String price,
    int quantity,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'x$quantity',
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Consumer<CartService>(
          builder: (context, cartService, child) {
            final totalAmount =
                widget.directBuy == true && widget.product != null
                ? widget.product!.productDetail?.price ?? 0
                : cartService.getTotalAmount();

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Thành tiền',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text(
                  Currency.formatVND(totalAmount),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildNoteCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.note, color: primaryColor),
                const SizedBox(width: 8),
                Text('Ghi chú', style: TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: primaryLightColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                widget.note!,
                style: TextStyle(color: Colors.black87, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: TextStyle(color: Colors.grey.shade600)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
