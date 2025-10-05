import 'package:flutter/material.dart';
import 'package:myapp/core/utils/device_size.dart';
import 'package:myapp/core/utils/performance_monitor.dart';
import 'package:myapp/features/shop/service/appointment-service.dart';
import 'package:myapp/features/shop/service/interface/i_service_detail.dart';
import 'package:myapp/features/shop/service/service_detail_service.dart';
import 'package:myapp/shared/model/shop.dart';
import 'package:myapp/shared/widgets/common/app_spacing.dart';
import 'package:myapp/features/shop/service/interface/service-detail-interface.dart';
import 'package:myapp/features/shop/service/interface/appointment-interface.dart';
import 'package:myapp/features/shop/service/interface/i_appointment_service.dart';

class ShopServiceScreen extends StatefulWidget {
  final String? shopId;

  const ShopServiceScreen({super.key, this.shopId});

  @override
  State<ShopServiceScreen> createState() => _ShopServiceScreenState();
}

class _ShopServiceScreenState extends State<ShopServiceScreen> {
  final TextEditingController _searchController = TextEditingController();
  // ✅ REMOVED: Cart service - single service booking only
  final List<ServiceDetail> _serviceList = [];
  final List<Shop> _shopList = [];
  String _selectedFilter =
      'all'; // 'all', 'medical', 'care', 'hotel', 'training'

  // ✅ UPDATED: Use actual services
  late final IServiceDetailService _serviceDetailService;
  late final IAppointmentService _appointmentService;
  bool _isLoading = false;
  int _currentPage = 1;
  bool _hasMoreData = true;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  // ✅ UPDATED: Initialize services properly
  Future<void> _initializeServices() async {
    setState(() => _isLoading = true);

    try {
      // Initialize services
      _serviceDetailService = ServiceDetailService();
      _appointmentService = AppointmentService();

      await (_serviceDetailService as ServiceDetailService).initialize();
      await (_appointmentService as AppointmentService).initialize();

      await _loadServicesData();
      await _loadShopData();
    } catch (e) {
      print('[ShopServiceScreen] Initialize services failed: $e');
      _showErrorSnackBar('Không thể khởi tạo dịch vụ');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // ✅ UPDATED: Load services from API
  Future<void> _loadServicesData() async {
    try {
      final response = await _serviceDetailService.getActiveServiceDetails(
        pageIndex: _currentPage,
        pageSize: 20,
      );

      if (response.items.isNotEmpty) {
        setState(() {
          if (_currentPage == 1) {
            _serviceList.clear();
          }
          _serviceList.addAll(response.items);
          _hasMoreData = response.hasNextPage;
        });
      }
    } catch (e) {
      print('[ShopServiceScreen] Load services data failed: $e');
      // Fallback to mock data if API fails
      _loadMockData();
    }
  }

  // ✅ Fallback mock data
  void _loadMockData() {
    final mockServices = [
      ServiceDetail(
        id: 'service_1',
        serviceCategoryId: 'cat_care',
        name: 'Dịch vụ spa thú cưng',
        price: 150000,
        durationTime: 120, // 2 hours
        status: true,
        discount: 10.0,
        isDefault: false,
        imgUrls: null,
      ),
      ServiceDetail(
        id: 'service_2',
        serviceCategoryId: 'cat_medical',
        name: 'Khám sức khỏe tổng quát',
        price: 300000,
        durationTime: 60, // 1 hour
        status: true,
        discount: 0.0,
        isDefault: false,
        imgUrls: null,
      ),
      ServiceDetail(
        id: 'service_3',
        serviceCategoryId: 'cat_hotel',
        name: 'Dịch vụ khách sạn thú cưng',
        price: 200000,
        durationTime: 1440, // 1 day
        status: true,
        discount: 5.0,
        isDefault: false,
        imgUrls: null,
      ),
      ServiceDetail(
        id: 'service_4',
        serviceCategoryId: 'cat_training',
        name: 'Huấn luyện thú cưng',
        price: 500000,
        durationTime: 90, // 1.5 hours
        status: true,
        discount: 15.0,
        isDefault: false,
        imgUrls: null,
      ),
    ];

    setState(() {
      _serviceList.addAll(mockServices);
    });
  }

  // ✅ Load shop data (mock for now)
  Future<void> _loadShopData() async {
    final mockShops = [
      Shop(
        shopId: widget.shopId ?? 'shop_1',
        owner: 'Nguyễn Văn A',
        shopName: 'Pet Care Center',
        description: 'Trung tâm chăm sóc thú cưng chuyên nghiệp',
        status: true,
        workingDays: 'Thứ 2 - Chủ nhật',
      ),
    ];

    setState(() {
      _shopList.addAll(mockShops);
    });
  }

  // ✅ UPDATED: Book single service using ServiceDetail
  Future<void> _bookService(ServiceDetail service) async {
    setState(() => _isLoading = true);

    try {
      // Show appointment booking dialog
      final appointmentData = await _showAppointmentDialog(service);

      if (appointmentData == null) return;

      // Create appointment detail for single service
      final appointmentDetail = AppointmentDetailInput(
        serviceDetailId: service.id,
        petQuantity: 1,
        note: 'Dịch vụ: ${service.name}',
      );

      // Create appointment request
      final createRequest = CreateAppointmentRequest(
        customerId: 'current_user_id', // TODO: Get from AuthService
        shopId: widget.shopId ?? 'shop_1',
        status: AppointmentStatus.pending,
        startTime: appointmentData['selectedDateTime'] as DateTime,
        staffName: appointmentData['staffName'] as String?,
        paymentMethod: appointmentData['paymentMethod'] as String?,
        note: appointmentData['note'] as String?,
        details: [appointmentDetail], // Single service
      );

      // Create appointment using AppointmentService
      final createResponse = await _appointmentService.createAppointment(
        createRequest,
      );

      // Show success message
      _showSuccessDialog(createResponse.id);
    } catch (e) {
      print('[ShopServiceScreen] Book service failed: $e');
      _showErrorSnackBar('Đặt lịch hẹn thất bại: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // ✅ UPDATED: Show appointment dialog with ServiceDetail info
  Future<Map<String, dynamic>?> _showAppointmentDialog(
    ServiceDetail service,
  ) async {
    DateTime? selectedDate;
    TimeOfDay? selectedTime;
    String? selectedStaff;
    String paymentMethod = 'cash';
    String note = '';

    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Đặt lịch: ${service.name}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Service info card
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.name ?? 'Dịch vụ',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      AppSpacing.vertical(8),
                      Row(
                        children: [
                          // ✅ Use ServiceDetail's finalPrice (with discount)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: service.discount > 0
                                  ? Colors.red
                                  : Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: service.discount > 0
                                ? Column(
                                    children: [
                                      Text(
                                        '${service.formattedPrice}đ',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                      Text(
                                        '${service.finalPrice.round().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}đ',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  )
                                : Text(
                                    '${service.formattedPrice}đ',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                          if (service.discount > 0) ...[
                            AppSpacing.horizontal(8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '-${service.discount.round()}%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                          const Spacer(),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 14,
                                color: Colors.grey[600],
                              ),
                              AppSpacing.horizontal(4),
                              Text(
                                service.formattedDuration,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                AppSpacing.vertical(16),

                // Date & Time selection
                const Text(
                  'Chọn ngày và giờ hẹn:',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                AppSpacing.vertical(8),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now().add(
                              const Duration(days: 1),
                            ),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 30),
                            ),
                          );
                          if (date != null)
                            setDialogState(() => selectedDate = date);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                            color: selectedDate != null
                                ? Colors.green[50]
                                : null,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 16,
                                color: selectedDate != null
                                    ? Colors.green[600]
                                    : Colors.grey[600],
                              ),
                              AppSpacing.horizontal(8),
                              Text(
                                selectedDate != null
                                    ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                                    : 'Chọn ngày',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: selectedDate != null
                                      ? Colors.green[600]
                                      : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    AppSpacing.horizontal(8),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: const TimeOfDay(hour: 9, minute: 0),
                          );
                          if (time != null)
                            setDialogState(() => selectedTime = time);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                            color: selectedTime != null
                                ? Colors.green[50]
                                : null,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 16,
                                color: selectedTime != null
                                    ? Colors.green[600]
                                    : Colors.grey[600],
                              ),
                              AppSpacing.horizontal(8),
                              Text(
                                selectedTime != null
                                    ? '${selectedTime!.hour}:${selectedTime!.minute.toString().padLeft(2, '0')}'
                                    : 'Chọn giờ',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: selectedTime != null
                                      ? Colors.green[600]
                                      : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                AppSpacing.vertical(16),

                // Staff selection
                const Text(
                  'Nhân viên thực hiện:',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                AppSpacing.vertical(8),
                DropdownButtonFormField<String>(
                  value: selectedStaff,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: null,
                      child: Text('Tự động chọn phù hợp'),
                    ),
                    DropdownMenuItem(
                      value: 'Dr. Smith',
                      child: Text('Dr. Smith - Bác sĩ thú y'),
                    ),
                    DropdownMenuItem(
                      value: 'Dr. Jane',
                      child: Text('Dr. Jane - Chuyên gia spa'),
                    ),
                    DropdownMenuItem(
                      value: 'Nurse Tom',
                      child: Text('Nurse Tom - Y tá'),
                    ),
                  ],
                  onChanged: (value) =>
                      setDialogState(() => selectedStaff = value),
                ),
                AppSpacing.vertical(16),

                // Payment method
                const Text(
                  'Phương thức thanh toán:',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                AppSpacing.vertical(8),
                DropdownButtonFormField<String>(
                  value: paymentMethod,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'cash', child: Text('💵 Tiền mặt')),
                    DropdownMenuItem(
                      value: 'card',
                      child: Text('💳 Thẻ tín dụng'),
                    ),
                    DropdownMenuItem(
                      value: 'transfer',
                      child: Text('🏦 Chuyển khoản'),
                    ),
                  ],
                  onChanged: (value) =>
                      setDialogState(() => paymentMethod = value ?? 'cash'),
                ),
                AppSpacing.vertical(16),

                // Note
                const Text(
                  'Ghi chú thêm:',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                AppSpacing.vertical(8),
                TextField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText:
                        'Nhập thông tin thêm về thú cưng, yêu cầu đặc biệt...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                  onChanged: (value) => note = value,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: selectedDate != null && selectedTime != null
                  ? () {
                      final selectedDateTime = DateTime(
                        selectedDate!.year,
                        selectedDate!.month,
                        selectedDate!.day,
                        selectedTime!.hour,
                        selectedTime!.minute,
                      );

                      Navigator.of(context).pop({
                        'selectedDateTime': selectedDateTime,
                        'staffName': selectedStaff,
                        'paymentMethod': paymentMethod,
                        'note': note.isNotEmpty ? note : null,
                      });
                    }
                  : null,
              child: const Text('Xác nhận đặt lịch'),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Show success dialog
  void _showSuccessDialog(String appointmentId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green[100],
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check, color: Colors.green[600], size: 24),
            ),
            AppSpacing.horizontal(12),
            const Text('Đặt lịch thành công!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mã lịch hẹn:',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  AppSpacing.vertical(4),
                  Text(
                    appointmentId,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.vertical(12),
            const Text(
              '✅ Cửa hàng sẽ liên hệ với bạn để xác nhận thời gian cụ thể.',
            ),
            AppSpacing.vertical(6),
            const Text(
              '📱 Bạn có thể theo dõi trạng thái lịch hẹn trong mục "Lịch sử".',
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Đã hiểu'),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            AppSpacing.horizontal(8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red[600],
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PerformanceMonitor.start('ShopServiceScreen build');

    double width = MediaQuery.of(context).size.width;
    double paddingResponsive = DeviceSize.getResponsivePadding(width);

    // ✅ Show loading spinner if initializing
    if (_isLoading && _serviceList.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Dịch vụ thú cưng'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0.5,
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Đang tải dữ liệu...'),
            ],
          ),
        ),
      );
    }

    final filteredServices = _getFilteredServices();

    final widget = Scaffold(
      appBar: AppBar(
        title: const Text('Dịch vụ thú cưng'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          const Divider(height: 1),
          AppSpacing.vertical(4),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Shop info section
                  _buildShopInfoSection(paddingResponsive),
                  AppSpacing.vertical(16),

                  // Filter tabs
                  _buildFilterTabs(paddingResponsive),
                  AppSpacing.vertical(16),

                  // Services grid
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: paddingResponsive),
                    child: filteredServices.isEmpty
                        ? _buildEmptyState()
                        : GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.75,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                ),
                            itemCount: filteredServices.length,
                            itemBuilder: (context, index) =>
                                _buildServiceCard(filteredServices[index]),
                          ),
                  ),
                  AppSpacing.vertical(20),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    PerformanceMonitor.stop('ShopServiceScreen build');
    return widget;
  }

  // ✅ Build shop info section
  Widget _buildShopInfoSection(double paddingResponsive) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: paddingResponsive),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Shop avatar
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[400]!, Colors.blue[600]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Center(
              child: Icon(Icons.store, color: Colors.white, size: 24),
            ),
          ),
          AppSpacing.horizontal(12),
          // Shop info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Pet Care Center',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[900],
                      ),
                    ),
                    AppSpacing.horizontal(4),
                    Icon(Icons.verified, color: Colors.blue[600], size: 16),
                  ],
                ),
                AppSpacing.vertical(4),
                Wrap(
                  spacing: 16,
                  runSpacing: 4,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        AppSpacing.horizontal(4),
                        Text(
                          '4.9',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.phone, color: Colors.grey[500], size: 14),
                        AppSpacing.horizontal(4),
                        Text(
                          '1900 123 456',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.green[600],
                    shape: BoxShape.circle,
                  ),
                ),
                AppSpacing.horizontal(6),
                Text(
                  'Đang mở',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Build filter tabs
  Widget _buildFilterTabs(double paddingResponsive) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: paddingResponsive),
      child: Row(
        children: [
          _buildFilterTab(
            title: 'Tất cả',
            isSelected: _selectedFilter == 'all',
            onTap: () => _updateFilter('all'),
          ),
          AppSpacing.horizontal(12),
          _buildFilterTab(
            title: 'Y tế',
            isSelected: _selectedFilter == 'medical',
            onTap: () => _updateFilter('medical'),
          ),
          AppSpacing.horizontal(12),
          _buildFilterTab(
            title: 'Chăm sóc',
            isSelected: _selectedFilter == 'care',
            onTap: () => _updateFilter('care'),
          ),
          AppSpacing.horizontal(12),
          _buildFilterTab(
            title: 'Khách sạn',
            isSelected: _selectedFilter == 'hotel',
            onTap: () => _updateFilter('hotel'),
          ),
        ],
      ),
    );
  }

  // ✅ Build filter tab
  Widget _buildFilterTab({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[800],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  // ✅ UPDATED: Build service card using ServiceDetail
  Widget _buildServiceCard(ServiceDetail service) {
    final String categoryName = _getCategoryDisplayName(
      service.serviceCategoryId,
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Service image placeholder
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[100]!, Colors.blue[200]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Icon(
              _getServiceIcon(service.serviceCategoryId),
              size: 48,
              color: Colors.blue[600],
            ),
          ),

          // Service details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Service name and category
                  Text(
                    service.name ?? 'Dịch vụ',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppSpacing.vertical(2),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      categoryName,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Spacer(),

                  // Price and duration
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (service.discount > 0) ...[
                            Text(
                              '${service.formattedPrice}đ',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[500],
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            Text(
                              '${service.finalPrice.round().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}đ',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.red[600],
                              ),
                            ),
                          ] else
                            Text(
                              '${service.formattedPrice}đ',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        service.formattedDuration,
                        style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                  if (service.discount > 0) ...[
                    AppSpacing.vertical(4),
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
                        'Giảm ${service.discount.round()}%',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.red[600],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                  AppSpacing.vertical(8),

                  // Book button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _bookService(service),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Đặt lịch',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Get category display name
  String _getCategoryDisplayName(String? categoryId) {
    switch (categoryId?.toLowerCase()) {
      case 'cat_medical':
        return 'Y tế';
      case 'cat_care':
        return 'Chăm sóc';
      case 'cat_hotel':
        return 'Khách sạn';
      case 'cat_training':
        return 'Huấn luyện';
      default:
        return 'Dịch vụ';
    }
  }

  // ✅ Get service icon based on category
  IconData _getServiceIcon(String? categoryId) {
    switch (categoryId?.toLowerCase()) {
      case 'cat_medical':
        return Icons.medical_services;
      case 'cat_care':
        return Icons.spa;
      case 'cat_hotel':
        return Icons.hotel;
      case 'cat_training':
        return Icons.school;
      default:
        return Icons.pets;
    }
  }

  // ✅ Build empty state
  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
          AppSpacing.vertical(16),
          Text(
            'Không tìm thấy dịch vụ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          AppSpacing.vertical(8),
          Text(
            'Hiện tại không có dịch vụ nào thuộc danh mục này',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _updateFilter(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  // ✅ UPDATED: Filter services using ServiceDetail
  List<ServiceDetail> _getFilteredServices() {
    if (_selectedFilter == 'all') {
      return _serviceList.where((service) {
        final searchTerm = _searchController.text.toLowerCase();
        return (service.name ?? '').toLowerCase().contains(searchTerm);
      }).toList();
    } else {
      return _serviceList.where((service) {
        final searchTerm = _searchController.text.toLowerCase();
        final categoryMatch =
            _getCategoryDisplayName(service.serviceCategoryId).toLowerCase() ==
                _selectedFilter.toLowerCase() ||
            service.serviceCategoryId?.toLowerCase().contains(
                  _selectedFilter.toLowerCase(),
                ) ==
                true;
        return categoryMatch &&
            (service.name ?? '').toLowerCase().contains(searchTerm);
      }).toList();
    }
  }
}
