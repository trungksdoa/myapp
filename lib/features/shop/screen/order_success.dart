import 'package:flutter/material.dart';
import 'package:myapp/route/navigate_helper.dart';

class OrderSuccessScreen extends StatelessWidget {
  final String orderId;
  const OrderSuccessScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đặt hàng thành công'),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black87),
          onPressed: () => NavigateHelper.goToHome(context),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, size: 96, color: Colors.green),
              const SizedBox(height: 16),
              const Text(
                'Cảm ơn đã đặt hàng!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                'Mã đơn: $orderId',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    NavigateHelper.goToHome(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Quay lại'),
                ),
              ),

              ElevatedButton(
                onPressed: () => NavigateHelper.goToOrderDetail(
                  context,
                  orderId: orderId,
                  isService: true, // hoặc false nếu là đơn sản phẩm
                ),
                child: const Text('Xem chi tiết đơn'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
