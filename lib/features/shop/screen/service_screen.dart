import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/core/currency_format.dart';
import 'package:myapp/core/utils/device_size.dart';

import 'package:myapp/features/shop/service/interface/service-detail-interface.dart';
import 'package:myapp/features/shop/service/interface/service-interface.dart';
import 'package:myapp/features/shop/service/interface/service_category.dart';
import 'package:myapp/features/shop/service/service_detail_service.dart';
import 'package:myapp/features/shop/service/service_service.dart';
import 'package:myapp/features/shop/model/booking_item.dart';
import 'package:myapp/features/shop/screen/booking_screen.dart';
import 'package:myapp/shared/widgets/common/app_spacing.dart';

class ServiceScreen extends StatefulWidget {
  final ServiceCategory serviceCategory;

  const ServiceScreen({super.key, required this.serviceCategory});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  final ServiceService _serviceService = ServiceService();
  final ServiceDetailService _serviceDetailService = ServiceDetailService();
  List<Service> _services = [];
  List<ServiceDetail> _serviceDetails = [];
  bool _isLoading = true;
  String? _error;
  int _currentPage = 1;
  bool _hasMoreData = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadServices();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoading && _hasMoreData) {
        _loadMoreServices();
      }
    }
  }

  Future<void> _loadServices() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
        _currentPage = 1;
      });

      await _serviceService.initialize();

      final response = await _serviceService.getAllServices(
        pageIndex: _currentPage,
        pageSize: 20,
        serviceCategoryId: widget.serviceCategory.id,
      );

      setState(() {
        _services = response.items;
        _hasMoreData = response.hasNextPage;
        _isLoading = false;
      });
    } catch (e) {
      print('[ServiceScreen] Load services failed: $e');
      setState(() {
        _error = 'Không thể tải dịch vụ từ server: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadServiceDetail(String serviceId) async {
    try {
      ServiceDetailListResponse details = await _serviceDetailService
          .getAllServiceDetails(serviceId: serviceId);
      setState(() {
        _serviceDetails = details.items;
      });
    } catch (e) {
      print('[ServiceScreen] Load service details failed: $e');
    }
  }

  Future<void> _loadMoreServices() async {
    if (!_hasMoreData || _isLoading) return;

    try {
      setState(() {
        _isLoading = true;
      });

      _currentPage++;

      final response = await _serviceService.getAllServices(
        pageIndex: _currentPage,
        pageSize: 20,
        serviceCategoryId: widget.serviceCategory.id,
      );

      setState(() {
        _services.addAll(response.items);
        _hasMoreData = response.hasNextPage;
        _isLoading = false;
      });
    } catch (e) {
      print('[ServiceScreen] Load more services failed: $e');
      _currentPage--;
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshServices() async {
    await _loadServices();
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
                        Icon(
                          _getCategoryIcon(widget.serviceCategory.name),
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.serviceCategory.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                widget.serviceCategory.shopName,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: _refreshServices,
                          icon: Icon(
                            Icons.refresh,
                            color: Colors.white.withOpacity(0.9),
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(paddingResponsive),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.medical_services,
                              color: _getCategoryColor(
                                widget.serviceCategory.name,
                              ),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Dịch vụ (${_services.length})',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        if (_error != null) ...[
                          AppSpacing.vertical(8),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.red[50],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red[200]!),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: Colors.red[600],
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _error!,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.red[700],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Expanded(child: _buildServicesList()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesList() {
    if (_isLoading && _services.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Đang tải dịch vụ...'),
          ],
        ),
      );
    }

    if (_services.isEmpty && !_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Không có dịch vụ nào trong danh mục này',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Vui lòng thử lại sau hoặc chọn danh mục khác',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshServices,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _services.length + (_hasMoreData ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _services.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final service = _services[index];
          return _buildServiceCard(service);
        },
      ),
    );
  }

  Widget _buildServiceCard(Service service) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: _getCategoryColor(
                    widget.serviceCategory.name,
                  ).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _getCategoryColor(
                      widget.serviceCategory.name,
                    ).withOpacity(0.3),
                  ),
                ),
                child: service.imgUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          service.imgUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.medical_services,
                              color: _getCategoryColor(
                                widget.serviceCategory.name,
                              ),
                              size: 30,
                            );
                          },
                        ),
                      )
                    : Icon(
                        Icons.medical_services,
                        color: _getCategoryColor(widget.serviceCategory.name),
                        size: 30,
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          service.isActive ? Icons.check_circle : Icons.cancel,
                          size: 14,
                          color: service.isActive ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          service.isActive ? 'Hoạt động' : 'Tạm ngưng',
                          style: TextStyle(
                            fontSize: 12,
                            color: service.isActive
                                ? Colors.green[600]
                                : Colors.red[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _showServiceDetail(service),
                icon: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[600],
                  size: 16,
                ),
              ),
            ],
          ),
          if (service.description.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              service.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.3,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _showServiceDetail(service),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: _getCategoryColor(widget.serviceCategory.name),
                    ),
                  ),
                  child: Text(
                    'Chi tiết',
                    style: TextStyle(
                      color: _getCategoryColor(widget.serviceCategory.name),
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: service.isActive
                      ? () => _showServiceDetail(service)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getCategoryColor(
                      widget.serviceCategory.name,
                    ),
                    disabledBackgroundColor: Colors.grey[300],
                  ),
                  child: Text(
                    'Đặt lịch',
                    style: TextStyle(
                      color: service.isActive ? Colors.white : Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
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

  IconData _getCategoryIcon(String categoryName) {
    final name = categoryName.toLowerCase();

    if (name.contains('mát xa') || name.contains('massage')) {
      return Icons.spa;
    } else if (name.contains('tiêm') || name.contains('vaccine')) {
      return Icons.vaccines;
    } else if (name.contains('thiến') || name.contains('surgery')) {
      return Icons.medical_services;
    } else if (name.contains('ăn') || name.contains('food')) {
      return Icons.restaurant;
    } else {
      return Icons.pets;
    }
  }

  void _showServiceDetail(Service service) async {
    await _loadServiceDetail(service.id);

    if (_serviceDetails.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không có tùy chọn dịch vụ nào'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Map to track selected details with their quantities and notes
    final Map<String, BookingItem> selectedBookingItems = {};

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return DraggableScrollableSheet(
            initialChildSize: 0.8,
            minChildSize: 0.6,
            maxChildSize: 0.95,
            expand: false,
            builder: (context, scrollController) {
              return Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle bar
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Scrollable content
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Service header
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
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
                                  child: service.imgUrl.isNotEmpty
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: Image.network(
                                            service.imgUrl,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  return Icon(
                                                    Icons.medical_services,
                                                    color: _getCategoryColor(
                                                      widget
                                                          .serviceCategory
                                                          .name,
                                                    ),
                                                    size: 30,
                                                  );
                                                },
                                          ),
                                        )
                                      : Icon(
                                          Icons.medical_services,
                                          color: _getCategoryColor(
                                            widget.serviceCategory.name,
                                          ),
                                          size: 30,
                                        ),
                                ),
                                const SizedBox(width: 16),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        service.name,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        widget.serviceCategory.name,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // Description
                            Text(
                              'Mô tả dịch vụ',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              service.description.isNotEmpty
                                  ? service.description
                                  : 'Dịch vụ chất lượng cao với đội ngũ chuyên nghiệp, trang thiết bị hiện đại.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                                height: 1.4,
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Service options title
                            Row(
                              children: [
                                Icon(
                                  Icons.checklist,
                                  size: 20,
                                  color: _getCategoryColor(
                                    widget.serviceCategory.name,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Chọn tùy chọn dịch vụ',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // Service details list with checkboxes
                            ..._serviceDetails.map((detail) {
                              final isSelected = selectedBookingItems
                                  .containsKey(detail.id);
                              final bookingItem =
                                  selectedBookingItems[detail.id];

                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? _getCategoryColor(
                                          widget.serviceCategory.name,
                                        ).withOpacity(0.1)
                                      : Colors.grey[50],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? _getCategoryColor(
                                            widget.serviceCategory.name,
                                          )
                                        : Colors.grey[200]!,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Checkbox and service info
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Checkbox(
                                          value: isSelected,
                                          onChanged: (value) {
                                            setModalState(() {
                                              if (value == true) {
                                                selectedBookingItems[detail
                                                    .id] = BookingItem(
                                                  serviceDetailId: detail.id,
                                                  serviceDetailName:
                                                      detail.name ?? '',
                                                  price: detail.price
                                                      .toDouble(),
                                                  durationTime:
                                                      detail.durationTime,
                                                  petQuantity: 1,
                                                  note: '',
                                                );
                                              } else {
                                                selectedBookingItems.remove(
                                                  detail.id,
                                                );
                                              }
                                            });
                                          },
                                          activeColor: _getCategoryColor(
                                            widget.serviceCategory.name,
                                          ),
                                        ),
                                        const SizedBox(width: 12),

                                        // Service detail info
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              if (detail.name?.isNotEmpty ??
                                                  false) ...[
                                                Text(
                                                  detail.name!,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black87,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 4),
                                              ],
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.attach_money,
                                                        size: 16,
                                                        color:
                                                            Colors.green[600],
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Expanded(
                                                        child: Text(
                                                          Currency.formatIntVND(
                                                            detail.price,
                                                          ),
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors
                                                                .green[600],
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.access_time,
                                                        size: 16,
                                                        color: Colors.blue[600],
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Expanded(
                                                        child: Text(
                                                          '${detail.durationTime} phút',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors
                                                                .blue[600],
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              if (detail.discount > 0) ...[
                                                const SizedBox(height: 4),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 6,
                                                        vertical: 2,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.orange[100],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    'Giảm ${detail.discount}%',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.orange[800],
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),

                                        // Status indicator
                                        Flexible(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: detail.status
                                                  ? Colors.green[50]
                                                  : Colors.red[50],
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: detail.status
                                                    ? Colors.green[200]!
                                                    : Colors.red[200]!,
                                              ),
                                            ),
                                            child: Text(
                                              detail.status ? 'Có sẵn' : 'Hết',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: detail.status
                                                    ? Colors.green[700]
                                                    : Colors.red[700],
                                                fontWeight: FontWeight.w500,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    // Show quantity and note inputs when selected
                                    if (isSelected && bookingItem != null) ...[
                                      const SizedBox(height: 12),
                                      const Divider(),
                                      const SizedBox(height: 12),

                                      // Pet quantity input
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.pets,
                                            size: 20,
                                            color: Colors.grey[600],
                                          ),
                                          const SizedBox(width: 8),
                                          const Text(
                                            'Số lượng pet:',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey[300]!,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.remove,
                                                    size: 20,
                                                  ),
                                                  onPressed: () {
                                                    if (bookingItem
                                                            .petQuantity >
                                                        1) {
                                                      setModalState(() {
                                                        selectedBookingItems[detail
                                                            .id] = BookingItem(
                                                          serviceDetailId:
                                                              bookingItem
                                                                  .serviceDetailId,
                                                          serviceDetailName:
                                                              bookingItem
                                                                  .serviceDetailName,
                                                          price:
                                                              bookingItem.price,
                                                          durationTime:
                                                              bookingItem
                                                                  .durationTime,
                                                          petQuantity:
                                                              bookingItem
                                                                  .petQuantity -
                                                              1,
                                                          note:
                                                              bookingItem.note,
                                                        );
                                                      });
                                                    }
                                                  },
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                      ),
                                                  child: Text(
                                                    '${bookingItem.petQuantity}',
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.add,
                                                    size: 20,
                                                  ),
                                                  onPressed: () {
                                                    if (bookingItem
                                                            .petQuantity <
                                                        10) {
                                                      setModalState(() {
                                                        selectedBookingItems[detail
                                                            .id] = BookingItem(
                                                          serviceDetailId:
                                                              bookingItem
                                                                  .serviceDetailId,
                                                          serviceDetailName:
                                                              bookingItem
                                                                  .serviceDetailName,
                                                          price:
                                                              bookingItem.price,
                                                          durationTime:
                                                              bookingItem
                                                                  .durationTime,
                                                          petQuantity:
                                                              bookingItem
                                                                  .petQuantity +
                                                              1,
                                                          note:
                                                              bookingItem.note,
                                                        );
                                                      });
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Spacer(),
                                          Text(
                                            Currency.formatIntVND(
                                              bookingItem.totalPrice.toInt(),
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

                                      const SizedBox(height: 12),

                                      // Note input
                                      TextField(
                                        decoration: InputDecoration(
                                          labelText: 'Ghi chú (tùy chọn)',
                                          hintText:
                                              'Nhập ghi chú cho dịch vụ này...',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          prefixIcon: Icon(
                                            Icons.note_alt_outlined,
                                            color: Colors.grey[600],
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 12,
                                              ),
                                        ),
                                        maxLines: 2,
                                        maxLength: 200,
                                        onChanged: (value) {
                                          selectedBookingItems[detail
                                              .id] = BookingItem(
                                            serviceDetailId:
                                                bookingItem.serviceDetailId,
                                            serviceDetailName:
                                                bookingItem.serviceDetailName,
                                            price: bookingItem.price,
                                            durationTime:
                                                bookingItem.durationTime,
                                            petQuantity:
                                                bookingItem.petQuantity,
                                            note: value,
                                          );
                                        },
                                      ),
                                    ],
                                  ],
                                ),
                              );
                            }).toList(),

                            const SizedBox(height: 20),

                            // Summary
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Đã chọn ${selectedBookingItems.length} tùy chọn',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      if (selectedBookingItems.isNotEmpty)
                                        Text(
                                          'Tổng: ${Currency.formatIntVND(selectedBookingItems.values.fold<double>(0, (sum, item) => sum + item.totalPrice).toInt())}',
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
                                ],
                              ),
                            ),

                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ),

                    // Action buttons fixed at bottom
                    Container(
                      padding: const EdgeInsets.only(top: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          top: BorderSide(color: Colors.grey[200]!, width: 1),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              child: const Text('Đóng'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed:
                                  selectedBookingItems.isNotEmpty &&
                                      service.isActive
                                  ? () {
                                      Navigator.pop(context);
                                      _navigateToBooking(
                                        service,
                                        selectedBookingItems.values.toList(),
                                      );
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _getCategoryColor(
                                  widget.serviceCategory.name,
                                ),
                                disabledBackgroundColor: Colors.grey[300],
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              child: Text(
                                'Đặt lịch (${selectedBookingItems.length})',
                                style: TextStyle(
                                  color:
                                      selectedBookingItems.isNotEmpty &&
                                          service.isActive
                                      ? Colors.white
                                      : Colors.grey[600],
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
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
            },
          );
        },
      ),
    );
  }

  void _navigateToBooking(Service service, List<BookingItem> bookingItems) {
    // Use serviceCategoryId as shopId since ServiceDetail doesn't have shopId
    String? shopId;
    if (_serviceDetails.isNotEmpty) {
      shopId = _serviceDetails.first.serviceCategoryId;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingScreen(
          service: service,
          serviceCategory: widget.serviceCategory,
          bookingItems: bookingItems,
          shopId: shopId ?? widget.serviceCategory.shopId,
        ),
      ),
    );
  }
}
