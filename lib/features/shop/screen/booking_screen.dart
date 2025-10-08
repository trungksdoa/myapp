import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/core/currency_format.dart';
import 'package:myapp/core/utils/device_size.dart';
import 'package:myapp/features/auth/service/auth_service.dart';
import 'package:myapp/features/shop/service/appointment-service.dart';
import 'package:myapp/features/shop/service/interface/appointment-interface.dart';
import 'package:myapp/features/shop/service/interface/service-interface.dart';
import 'package:myapp/features/shop/service/interface/service_category.dart';
import 'package:myapp/features/shop/model/booking_item.dart';
import 'package:myapp/shared/widgets/common/app_spacing.dart';
import 'package:myapp/route/navigate_helper.dart'; // ✅ Thêm import này

enum PaymentMethod { shop, momo }

class BookingScreen extends StatefulWidget {
  final Service service;
  final ServiceCategory serviceCategory;
  final List<BookingItem> bookingItems;
  final String shopId;

  const BookingScreen({
    super.key,
    required this.service,
    required this.serviceCategory,
    required this.bookingItems,
    required this.shopId,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  PaymentMethod _selectedPaymentMethod = PaymentMethod.shop;
  bool _isProcessing = false;

  //Call Appointment service
  AppointmentService appointmentService = AppointmentService();

  @override
  void initState() {
    super.initState();
    // Set default date to tomorrow
    _selectedDate = DateTime.now().add(const Duration(days: 1));
    // Set default time to 9:00 AM
    _selectedTime = const TimeOfDay(hour: 9, minute: 0);
  }

  void _confirmBooking() async {
    print('🔵 _confirmBooking() được gọi');

    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn ngày và giờ đặt lịch'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      print('🟡 Bắt đầu gọi _createAppointment()');
      // ✅ Gọi _createAppointment thay vì simulate API call
      await _createAppointment();
      print('🟢 _createAppointment() hoàn thành thành công');

      setState(() {
        _isProcessing = false;
      });

      if (mounted) {
        // Show success dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            icon: Icon(Icons.check_circle, color: Colors.green[600], size: 64),
            title: const Text(
              'Đặt lịch thành công!',
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Lịch hẹn của bạn đã được xác nhận',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Ngày:'),
                          Text(
                            DateFormat('dd/MM/yyyy').format(_selectedDate!),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Giờ:'),
                          Text(
                            _selectedTime!.format(context),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  // ✅ Sử dụng NavigateHelper.goToHome thay vì multiple pop()
                  NavigateHelper.goToHome(context);
                },
                child: const Text('Về trang chủ'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  // TODO: Navigate to booking history
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getCategoryColor(
                    widget.serviceCategory.name,
                  ),
                ),
                child: const Text(
                  'Xem lịch hẹn',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print('🔴 Lỗi trong _confirmBooking: $e');
      setState(() {
        _isProcessing = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đặt lịch thất bại: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _createAppointment() async {
    print('🚀 _createAppointment() bắt đầu');

    try {
      final authService = AuthService();
      String? userId = authService.userId;
      print('👤 User ID: $userId');

      if (userId == null) {
        print('❌ User chưa đăng nhập');
        throw Exception('Vui lòng đăng nhập để đặt lịch');
      }

      // ✅ Tạo DateTime với timezone UTC và format theo ISO 8601
      final startTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      ).toUtc(); // Chuyển sang UTC

      print('📅 Start time (UTC): ${startTime.toIso8601String()}');
      print('🏪 Shop ID: ${widget.shopId}');
      print('💳 Payment method: ${_selectedPaymentMethod.name}');

      CreateAppointmentRequest request = CreateAppointmentRequest(
        customerId: userId,
        shopId: widget.shopId,
        paymentMethod: _selectedPaymentMethod.name,
        note: '',
        status: AppointmentStatus.pending,
        startTime: startTime, // Sử dụng UTC time
        staffName: 'null',
        bankId: _selectedPaymentMethod == PaymentMethod.momo
            ? 'MOMO_BANK_ID'
            : null,
        details: widget.bookingItems
            .map(
              (item) => AppointmentDetailInput(
                serviceDetailId: item.serviceDetailId,
                petQuantity: item.petQuantity,
                note: item.note,
              ),
            )
            .toList(),
      );

      print('📝 Request tạo thành công, đang gửi API...');
      print(
        '🕐 StartTime trong request: ${request.startTime.toIso8601String()}',
      );

      final response = await appointmentService.createAppointment(request);
      print('📨 Response nhận được: ${response.success}');

      if (!response.success) {
        print('❌ API trả về thất bại');
        throw Exception('Đặt lịch không thành công');
      }

      print('✅ Đặt lịch thành công với User ID: $userId');
    } catch (e) {
      print('❌ Lỗi trong _createAppointment: $e');
      rethrow; // Ném lại lỗi để _confirmBooking có thể xử lý
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: _getCategoryColor(widget.serviceCategory.name),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? const TimeOfDay(hour: 9, minute: 0),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: _getCategoryColor(widget.serviceCategory.name),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Color _getCategoryColor(String categoryName) {
    final name = categoryName.toLowerCase();

    if (name.contains('mát xa') || name.contains('massage')) {
      return Colors.orange;
    } else if (name.contains('tiêm') || name.contains('vaccine')) {
      return Colors.blue;
    } else if (name.contains('thiến') || name.contains('surgery')) {
      return Colors.purple;
    } else if (name.contains('ăn') || name.contains('food')) {
      return Colors.brown;
    } else {
      return Colors.teal;
    }
  }

  double get _totalAmount {
    return widget.bookingItems.fold<double>(
      0.0,
      (sum, item) => sum + item.totalPrice,
    );
  }

  int get _totalDuration {
    return widget.bookingItems.fold<int>(
      0,
      (sum, item) => sum + (item.durationTime * item.petQuantity),
    );
  }

  @override
  Widget build(BuildContext context) {
    double paddingResponsive = DeviceSize.getResponsivePadding(
      MediaQuery.of(context).size.width,
    );

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Header
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _getCategoryColor(widget.serviceCategory.name),
                  _getCategoryColor(
                    widget.serviceCategory.name,
                  ).withOpacity(0.8),
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(paddingResponsive),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Đặt lịch dịch vụ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Hoàn tất thông tin đặt lịch',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(paddingResponsive),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Service info
                  _buildSectionCard(
                    title: 'Thông tin dịch vụ',
                    icon: Icons.medical_services,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.service.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.serviceCategory.name,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),

                  AppSpacing.vertical(16),

                  // Selected options
                  _buildSectionCard(
                    title: 'Tùy chọn đã chọn (${widget.bookingItems.length})',
                    icon: Icons.checklist,
                    child: Column(
                      children: widget.bookingItems.map((item) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _getCategoryColor(
                              widget.serviceCategory.name,
                            ).withOpacity(0.05),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _getCategoryColor(
                                widget.serviceCategory.name,
                              ).withOpacity(0.2),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.serviceDetailName,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    Currency.formatIntVND(
                                      item.totalPrice.toInt(),
                                    ),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: _getCategoryColor(
                                        widget.serviceCategory.name,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.pets,
                                    size: 14,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${item.petQuantity} pet',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Icon(
                                    Icons.access_time,
                                    size: 14,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${item.durationTime} phút/pet',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              if (item.note.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.note,
                                      size: 14,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        item.note,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[700],
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  AppSpacing.vertical(16),

                  // Date and time selection
                  _buildSectionCard(
                    title: 'Chọn ngày và giờ',
                    icon: Icons.event,
                    child: Column(
                      children: [
                        // Date picker
                        InkWell(
                          onTap: () => _selectDate(context),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  color: _getCategoryColor(
                                    widget.serviceCategory.name,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Ngày bắt đầu',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      Text(
                                        _selectedDate != null
                                            ? DateFormat(
                                                'dd/MM/yyyy',
                                              ).format(_selectedDate!)
                                            : 'Chọn ngày',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.arrow_forward_ios, size: 16),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Time picker
                        InkWell(
                          onTap: () => _selectTime(context),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  color: _getCategoryColor(
                                    widget.serviceCategory.name,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Thời gian',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      Text(
                                        _selectedTime != null
                                            ? _selectedTime!.format(context)
                                            : 'Chọn giờ',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.arrow_forward_ios, size: 16),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Duration info
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 16,
                                color: Colors.blue[700],
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Thời gian dự kiến: $_totalDuration phút',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue[700],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  AppSpacing.vertical(16),

                  // Payment method
                  _buildSectionCard(
                    title: 'Phương thức thanh toán',
                    icon: Icons.payment,
                    child: Column(
                      children: [
                        RadioListTile<PaymentMethod>(
                          value: PaymentMethod.shop,
                          groupValue: _selectedPaymentMethod,
                          onChanged: (value) {
                            setState(() {
                              _selectedPaymentMethod = value!;
                            });
                          },
                          activeColor: _getCategoryColor(
                            widget.serviceCategory.name,
                          ),
                          title: Row(
                            children: [
                              Icon(Icons.store, color: Colors.grey[700]),
                              const SizedBox(width: 12),
                              const Text('Thanh toán tại cửa hàng'),
                            ],
                          ),
                          contentPadding: EdgeInsets.zero,
                        ),
                        const Divider(),
                        RadioListTile<PaymentMethod>(
                          value: PaymentMethod.momo,
                          groupValue: _selectedPaymentMethod,
                          onChanged: (value) {
                            setState(() {
                              _selectedPaymentMethod = value!;
                            });
                          },
                          activeColor: _getCategoryColor(
                            widget.serviceCategory.name,
                          ),
                          title: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFA50064),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Center(
                                  child: Text(
                                    'M',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text('Thanh toán qua MoMo'),
                            ],
                          ),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ),

                  AppSpacing.vertical(16),

                  // Summary
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(
                        widget.serviceCategory.name,
                      ).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _getCategoryColor(
                          widget.serviceCategory.name,
                        ).withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Tổng cộng',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              Currency.formatVND(_totalAmount),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: _getCategoryColor(
                                  widget.serviceCategory.name,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom button
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(paddingResponsive),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: _isProcessing ? null : _confirmBooking,
            style: ElevatedButton.styleFrom(
              backgroundColor: _getCategoryColor(widget.serviceCategory.name),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isProcessing
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_circle, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        'Đặt lịch ngay - ${Currency.formatIntVND(_totalAmount.toInt())}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: _getCategoryColor(widget.serviceCategory.name),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
