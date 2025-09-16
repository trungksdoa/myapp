import 'package:flutter/material.dart';

class AppointmentDetailsBodyWidget extends StatelessWidget {
  const AppointmentDetailsBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Customer information section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Thông tin khách hàng',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _buildInfoRow('Tên khách hàng:', 'Mèo thần chết'),
                _buildInfoRow('Số điện thoại:', '0912345678'),
                _buildInfoRow(
                  'Địa chỉ:',
                  'Đại học fpq, Quận 9, tp Hồ Chí Minh',
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Appointment status section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Trạng thái cuộc hẹn',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4A9B8E),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Chờ xác nhận',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildInfoRow('Thời gian:', '2:00 30/06/2025'),
                _buildInfoRow('Cơ sở thực hiện:', 'Chi nhánh Quận 1'),
                _buildInfoRow('Ghi chú:', 'Chó sợ người lạ'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Service items section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.store, color: Colors.grey, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Cửa hàng Petting',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const Spacer(),
                    Text(
                      'Xem cửa hàng',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildServiceItem(
                  image: 'assets/images/Home1.png',
                  title: 'Tắm cho cún',
                  duration: '60 phút',
                  price: '200,000 đ',
                  quantity: 1,
                ),
                const SizedBox(height: 8),
                _buildServiceItem(
                  image: 'assets/images/Home1.png',
                  title: 'Tắm cho cún',
                  duration: '60 phút',
                  price: '200,000 đ',
                  quantity: 1,
                ),
              ],
            ),
          ),

          const Spacer(),

          // Total price
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Tổng tiền:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '400,000 đ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildServiceItem({
    required String image,
    required String title,
    required String duration,
    required String price,
    required int quantity,
  }) {
    return Row(
      children: [
        Checkbox(
          value: true,
          onChanged: (value) {},
          activeColor: const Color(0xFF4A9B8E),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(image, width: 40, height: 40, fit: BoxFit.cover),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              Text(
                duration,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              Text(
                price,
                style: const TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        Text(
          'x$quantity',
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
      ],
    );
  }
}
