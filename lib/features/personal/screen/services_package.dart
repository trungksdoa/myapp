import 'package:flutter/material.dart';
import 'deposit_qr_page.dart';

class ServicePackagesBodyWidget extends StatelessWidget {
  const ServicePackagesBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Bank Account Section - MOVED TO TOP
          _buildBankAccountSection(context),

          const SizedBox(height: 24),

          // Special offer card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.orange, Colors.deepOrange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Gói thành viên của bạn',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Gói thành viên Bạc',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Thời hạn: 1 năm',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 4),
                const Text(
                  '500.000đ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextButton(
                    onPressed: () => _buyNow(context),
                    child: const Text(
                      'Mua ngay',
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Benefits list
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: [
                    _buildBenefitItem('🏥 Ai Ty Vân Đình Khoa 24/7'),
                    _buildBenefitItem('📍 Khám tại Đinh Tiên Hoàng'),
                    _buildBenefitItem('📱 Tính Năng Vứng Thể'),
                    _buildBenefitItem(
                      '🎯 Được 10 lần khám miễn phí tại Ai Dọc',
                    ),
                    _buildBenefitItem('🌟 Hồ sơ bệnh án điện tử miễn phí'),
                    _buildBenefitItem('🔔 Nhắc nhở lịch tiêm chủng'),
                    _buildBenefitItem('💊 Tư vấn về sức khỏe'),
                    _buildBenefitItem('📞 Đường dây nóng 24/7'),
                    _buildBenefitItem(
                      '🎁 Ưu đãi khuyến mãi tại nhà thuốc và bệnh viện khách thuộc hệ thống thú cưng',
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Available packages section
          const Text(
            'Gói thành viên',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          // Gold membership card (no Expanded inside scroll view)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.stars, color: Colors.white, size: 40),
                const SizedBox(height: 12),
                const Text(
                  'Thành viên vàng',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Thời hạn: 1 năm',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 6),
                const Text(
                  '500.000đ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _buyGoldMembership(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Mua ngay',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Bank Account Section - NOW AT THE TOP
  Widget _buildBankAccountSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Nạp tiền',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _navigateToDepositPage(context),
                icon: const Icon(Icons.qr_code, size: 16),
                label: const Text('Nạp tiền'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Deposit information
          _buildDepositInfo(context),
        ],
      ),
    );
  }

  Widget _buildDepositInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.account_balance_wallet,
                color: Colors.orange,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Số dư hiện tại',
                      style: TextStyle(fontSize: 14, color: Color(0xFF757575)),
                    ),
                    const Text(
                      '1.250.000đ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Quét mã QR để nạp tiền nhanh chóng và an toàn',
            style: TextStyle(fontSize: 14, color: Color(0xFF757575)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(String benefit) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        benefit,
        style: const TextStyle(color: Colors.white, fontSize: 11),
      ),
    );
  }

  void _buyNow(BuildContext context) {
    // Navigate to deposit QR page for payment
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const DepositQRPage()));
  }

  void _buyGoldMembership(BuildContext context) {
    // Navigate to deposit QR page for payment
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const DepositQRPage()));
  }

  void _navigateToDepositPage(BuildContext context) {
    // Navigate to deposit QR page
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const DepositQRPage()));
  }
}
