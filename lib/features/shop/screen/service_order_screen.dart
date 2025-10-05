import 'package:flutter/material.dart';
import 'package:myapp/core/currency_format.dart';
import 'package:myapp/features/shop/logic/shop_logic.dart';
import 'package:myapp/shared/model/product.dart';
import 'package:myapp/route/navigate_helper.dart';
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
    _initializeData();
  }

  void _initializeData() async {
    try {
      // TODO: Replace with service call when API is ready
      // For now using mock data
      final List<Product> mockProducts = [
        Product(
          productId: 'product_1',
          productName: 'Dịch vụ spa thú cưng',
          description: 'Dịch vụ spa chuyên nghiệp',
          category: 'care',
          status: true,
          shopId: 'shop_1',
        ),
      ];
      CartService().initializeProductData(mockProducts);
    } catch (e) {
      // Handle error silently
    }
  }

  Future<String> _getShopName(String shopId) async {
    // TODO: Replace with service call when API is ready
    // Mock shop names for now
    final Map<String, String> shopNames = {
      'shop_1': 'Pet Care Center',
      'shop_2': 'Happy Pet Store',
      'shop_3': 'Veterinary Clinic Plus',
    };
    return shopNames[shopId] ?? 'Unknown Shop';
  }

  @override
  Widget build(BuildContext context) {
    return Selector<CartService, int>(
      selector: (context, cartService) => cartService.getCartCount(),
      builder: (context, cartCount, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
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
                _buildCustomerInfoCard(),
                const SizedBox(height: 16),
                _buildServiceItemsCard(),
                const SizedBox(height: 16),
                if (widget.note != null) _buildNoteCard(),
                const SizedBox(height: 16),
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
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    _handleConfirmOrder();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Xác nhận đặt hàng',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleConfirmOrder() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Xác nhận đặt hàng',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text('Bạn có chắc chắn muốn đặt hàng không?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Hủy', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _processOrder();
              },
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
              child: const Text(
                'Xác nhận',
                style: TextStyle(color: Colors.white),
              ),
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
            Row(
              children: [
                Icon(Icons.person, color: primaryColor),
                const SizedBox(width: 8),
                const Text(
                  'Thông tin khách hàng',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const Divider(),
            Text(
              'Thông tin giao hàng',
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
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      if (product.category == 'care')
                        _buildServiceItem(
                          'https://res.cloudinary.com/dc1piksu8/image/upload/v1756239589/9725.jpg',
                          product.productName,
                          '60 phút',
                          'Liên hệ',
                          product.description,
                          widget.datetime ?? 'Chưa chọn thời gian',
                        )
                      else
                        _buildProductItem(
                          'https://res.cloudinary.com/dc1piksu8/image/upload/v1756239589/9725.jpg',
                          product.productName,
                          'Liên hệ',
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
          if (cartItems.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Giỏ hàng trống'),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Dịch vụ trong giỏ hàng',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                ...cartItems.map((item) {
                  final product = cartService.getProductFromId(item.productId);
                  if (product.category == 'care') {
                    return _buildServiceItem(
                      'https://res.cloudinary.com/dc1piksu8/image/upload/v1756239589/9725.jpg',
                      product.productName,
                      '60 phút',
                      'Liên hệ',
                      product.description,
                      item.productMeta?['dateTime'] ?? 'Chưa chọn thời gian',
                    );
                  } else {
                    return _buildProductItem(
                      'https://res.cloudinary.com/dc1piksu8/image/upload/v1756239589/9725.jpg',
                      product.productName,
                      'Liên hệ',
                      item.quantity,
                    );
                  }
                }).toList(),
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
                image: NetworkImage(imagePath),
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
                  serviceName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Thời gian: $duration',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                Text(
                  'Giá: $price',
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
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
                    style: TextStyle(
                      fontSize: 12,
                      color: primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (description.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

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
                image: NetworkImage(imagePath),
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
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  price,
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'x$quantity',
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
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
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tổng cộng:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Liên hệ',
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
                const Text(
                  'Ghi chú',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(widget.note ?? ''),
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
