import 'package:flutter/material.dart';

class OrderDetailScreen extends StatelessWidget {
  final String orderId;
  final bool isService; // true: đơn dịch vụ, false: đơn sản phẩm

  const OrderDetailScreen({
    super.key,
    required this.orderId,
    this.isService = false,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: thay bằng data thực (fetch theo orderId)
    // Dưới đây là UI “hao hao” ServiceOrder nhưng ở chế độ xem chi tiết (read-only)
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết đơn hàng'),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          Row(
            children: [
              Icon(
                isService ? Icons.design_services : Icons.shopping_bag,
                color: Colors.blueAccent,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isService ? 'Đơn dịch vụ' : 'Đơn sản phẩm',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Đã xác nhận',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('Mã đơn: $orderId', style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 16),

          // Thông tin cửa hàng/nhà cung cấp
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Cửa hàng ABC',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 4),
                  Text('Địa chỉ: 123 Đường XYZ, Quận 1'),
                  SizedBox(height: 4),
                  Text('SĐT: 0909 123 456'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Danh sách mục trong đơn (dịch vụ hoặc sản phẩm)
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: const [
                      Expanded(child: Text('Mục')),
                      SizedBox(width: 8),
                      SizedBox(
                        width: 60,
                        child: Text('SL', textAlign: TextAlign.center),
                      ),
                      SizedBox(
                        width: 80,
                        child: Text('Giá', textAlign: TextAlign.right),
                      ),
                    ],
                  ),
                  const Divider(height: 16),
                  // TODO: render từ data theo orderId
                  Row(
                    children: const [
                      Expanded(child: Text('Cắt tỉa lông thú cưng')),
                      SizedBox(width: 8),
                      SizedBox(
                        width: 60,
                        child: Text('1', textAlign: TextAlign.center),
                      ),
                      SizedBox(
                        width: 80,
                        child: Text('150.000đ', textAlign: TextAlign.right),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: const [
                      Expanded(child: Text('Sữa tắm thú cưng 500ml')),
                      SizedBox(width: 8),
                      SizedBox(
                        width: 60,
                        child: Text('2', textAlign: TextAlign.center),
                      ),
                      SizedBox(
                        width: 80,
                        child: Text('200.000đ', textAlign: TextAlign.right),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Ghi chú, lịch hẹn (nếu là dịch vụ)
          if (isService) ...[
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: const ListTile(
                leading: Icon(Icons.event_available),
                title: Text('Thời gian hẹn'),
                subtitle: Text('14:30, 21/09/2025'),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: const ListTile(
                leading: Icon(Icons.note_alt_outlined),
                title: Text('Ghi chú'),
                subtitle: Text('Nhẹ tay với bé, bé sợ máy sấy'),
              ),
            ),
          ],

          const SizedBox(height: 12),

          // Tổng tiền
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: const [
                  _AmountRow(label: 'Tạm tính', value: '350.000đ'),
                  SizedBox(height: 6),
                  _AmountRow(label: 'Phí dịch vụ', value: '0đ'),
                  Divider(height: 18),
                  _AmountRow(
                    label: 'Tổng cộng',
                    value: '350.000đ',
                    isTotal: true,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Hành động
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {}, // tải hóa đơn PDF chẳng hạn
                  icon: const Icon(Icons.download),
                  label: const Text('Tải hóa đơn'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {}, // đặt lại tương tự đơn này
                  icon: const Icon(Icons.replay),
                  label: const Text('Đặt lại'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _AmountRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;
  const _AmountRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: isTotal ? 18 : 15,
      fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(value, style: style),
      ],
    );
  }
}
