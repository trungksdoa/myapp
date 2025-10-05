// lib/features/service/screens/service_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:myapp/core/utils/device_size.dart';
import 'package:myapp/features/shop/service/interface/service-detail-interface.dart';
import 'package:myapp/shared/widgets/common/app_spacing.dart';
import 'package:myapp/route/navigate_helper.dart';

class ServiceDetailScreen extends StatefulWidget {
  final String serviceId;
  final String? serviceName;

  const ServiceDetailScreen({
    super.key,
    required this.serviceId,
    this.serviceName,
  });

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  // Service will be loaded via mock data for now

  List<ServiceDetail> _serviceOptions =
      []; // ← Multiple options with different prices
  bool _isLoading = false;
  String _selectedOptionId = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    setState(() => _isLoading = true);

    try {
      // Initialize mock data
      await _loadServiceOptions();
    } catch (e) {
      print('[ServiceDetailScreen] Initialize failed: $e');
      _loadMockOptions(); // Fallback to mock data
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// ✅ Load service options (using mock data)
  Future<void> _loadServiceOptions() async {
    try {
      // TODO: Load ServiceDetails from API when available
      _loadMockOptions();
    } catch (e) {
      print('[ServiceDetailScreen] Load service options failed: $e');
      _loadMockOptions(); // Fallback
    }
  }

  /// ✅ Mock options based on your JSON structure
  void _loadMockOptions() {
    final mockOptions = [
      ServiceDetail(
        id: "f4adbccc0c0e4f1898080ceb6d49a757",
        serviceCategoryId: "8fc81a91f4f84f38bfe5a2805b385eb0",
        name: "Mát xa",
        price: 150000,
        durationTime: 90, // 1.5 hours
        status: true,
        discount: 0,
        isDefault: true,
        imgUrls: "https://example.com/basic.jpg",
      ),
      ServiceDetail(
        id: "f4adbccc0c0e4f1898080ceb6d49a758",
        serviceCategoryId: "8fc81a91f4f84f38bfe5a2805b385eb0",
        name: "Tắm",
        price: 300000,
        durationTime: 150, // 2.5 hours
        status: true,
        discount: 15, // 15% discount
        isDefault: false,
        imgUrls: "https://example.com/premium.jpg",
      ),
      ServiceDetail(
        id: "f4adbccc0c0e4f1898080ceb6d49a759",
        serviceCategoryId: "8fc81a91f4f84f38bfe5a2805b385eb0",
        name: "Thiến thú",
        price: 500000,
        durationTime: 210, // 3.5 hours
        status: true,
        discount: 20, // 20% discount
        isDefault: false,
        imgUrls: "https://example.com/vip.jpg",
      ),
    ];

    setState(() {
      _serviceOptions = mockOptions;
      if (_serviceOptions.isNotEmpty) {
        _selectedOptionId = _serviceOptions.first.id;
      }
    });
  }

  ServiceDetail? get _selectedOption {
    return _serviceOptions.firstWhere(
      (option) => option.id == _selectedOptionId,
      orElse: () => _serviceOptions.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                _buildSliverAppBar(),
                SliverToBoxAdapter(child: _buildContent()),
              ],
            ),
      bottomNavigationBar: _buildBottomBookingBar(),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          widget.serviceName ?? 'Chi tiết dịch vụ',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[400]!, Colors.blue[600]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: _selectedOption?.imgUrls?.isNotEmpty == true
              ? Image.network(
                  _selectedOption!.imgUrls!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.pets,
                    size: 64,
                    color: Colors.white.withOpacity(0.8),
                  ),
                )
              : Icon(
                  Icons.pets,
                  size: 64,
                  color: Colors.white.withOpacity(0.8),
                ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildServiceOptionsSection(),
        _buildSelectedOptionDetails(),
        _buildTabSection(),
        _buildServicesIncluded(),
      ],
    );
  }

  /// ✅ Service Options Selection
  Widget _buildServiceOptionsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Chọn gói dịch vụ',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          AppSpacing.vertical(16),
          ..._serviceOptions.map((option) => _buildOptionCard(option)),
        ],
      ),
    );
  }

  Widget _buildOptionCard(ServiceDetail option) {
    final isSelected = _selectedOptionId == option.id;

    return GestureDetector(
      onTap: () => setState(() => _selectedOptionId = option.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? Theme.of(context).primaryColor.withOpacity(0.05)
              : Colors.white,
        ),
        child: Row(
          children: [
            Radio<String>(
              value: option.id,
              groupValue: _selectedOptionId,
              onChanged: (value) => setState(() => _selectedOptionId = value!),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.name ?? 'Dịch vụ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.black,
                    ),
                  ),
                  AppSpacing.vertical(4),
                  Row(
                    children: [
                      if (option.discount > 0) ...[
                        Text(
                          option.formattedPrice + 'đ',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${option.finalPrice.round().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}đ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.red[600],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red[100],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '-${option.discount.round()}%',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.red[600],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ] else ...[
                        Text(
                          option.formattedPrice + 'đ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                      const Spacer(),
                      Text(
                        option.formattedDuration,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedOptionDetails() {
    if (_selectedOption == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      margin: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _selectedOption!.name!,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          AppSpacing.vertical(8),
          Row(
            children: [
              Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                'Thời gian: ${_selectedOption!.formattedDuration}',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabSection() {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 8),
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Mô tả'),
              Tab(text: 'Đánh giá'),
              Tab(text: 'Chính sách'),
            ],
          ),
          SizedBox(
            height: 200,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDescriptionTab(),
                _buildReviewTab(),
                _buildPolicyTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        'Dịch vụ chuyên nghiệp với đội ngũ có kinh nghiệm. '
        '${_selectedOption?.name ?? 'Gói dịch vụ'} bao gồm các hoạt động chăm sóc toàn diện.',
      ),
    );
  }

  Widget _buildReviewTab() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Text('Chưa có đánh giá nào.'),
    );
  }

  Widget _buildPolicyTab() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Text('Chính sách hủy: Miễn phí hủy trước 24h.'),
    );
  }

  Widget _buildServicesIncluded() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dịch vụ bao gồm',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          AppSpacing.vertical(12),
          ..._getIncludedServices(_selectedOption).map(
            (service) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 16),
                  const SizedBox(width: 8),
                  Expanded(child: Text(service)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<String> _getIncludedServices(ServiceDetail? option) {
    if (option == null) return [];

    // Based on option type, return different services
    switch ((option.name ?? '').toLowerCase()) {
      case 'gói cơ bản':
        return ['Tắm rửa cơ bản', 'Cắt tỉa móng', 'Vệ sinh tai', 'Sấy khô'];
      case 'gói cao cấp':
        return [
          'Tắm rửa cao cấp với sản phẩm nhập khẩu',
          'Cắt tỉa móng + đánh bóng',
          'Vệ sinh tai chuyên sâu',
          'Sấy khô + tạo kiểu lông',
          'Massage thư giãn',
          'Nước hoa thú cưng',
        ];
      case 'gói vip':
        return [
          'Tắm rửa VIP với sản phẩm organic',
          'Cắt tỉa móng + đánh bóng + nail art',
          'Vệ sinh tai + massage tai',
          'Sấy khô + tạo kiểu lông chuyên nghiệp',
          'Massage toàn thân',
          'Nước hoa cao cấp',
          'Chụp ảnh kỷ niệm',
          'Đồ ăn nhẹ cho thú cưng',
        ];
      default:
        return ['Dịch vụ chăm sóc cơ bản'];
    }
  }

  Widget _buildBottomBookingBar() {
    if (_selectedOption == null) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        16 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedOption!.name!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: [
                    if (_selectedOption!.discount > 0) ...[
                      Text(
                        _selectedOption!.formattedPrice + 'đ',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${_selectedOption!.finalPrice.round().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}đ',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        ),
                      ),
                    ] else ...[
                      Text(
                        _selectedOption!.formattedPrice + 'đ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () => _bookService(_selectedOption!),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Đặt lịch ngay',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _bookService(ServiceDetail selectedOption) async {
    // Navigate to booking/appointment screen with selected option
    final appointmentData = await _showAppointmentDialog(selectedOption);

    if (appointmentData != null) {
      // Process booking
      Navigator.pop(context); // Or navigate to order screen
    }
  }

  Future<Map<String, dynamic>?> _showAppointmentDialog(
    ServiceDetail option,
  ) async {
    // Implementation similar to your existing appointment dialog
    // but using ServiceDetail option instead of mock package
    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Đặt lịch: ${option.name}'),
        content: Text('Appointment booking dialog implementation...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, {'confirmed': true}),
            child: const Text('Đặt lịch'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
