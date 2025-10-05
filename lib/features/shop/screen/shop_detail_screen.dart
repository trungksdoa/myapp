import 'package:flutter/material.dart';
import 'package:myapp/core/utils/device_size.dart';
import 'package:myapp/core/utils/performance_monitor.dart';
import 'package:myapp/features/shop/service/appointment-service.dart';
import 'package:myapp/features/shop/service/interface/i_service_detail.dart';
import 'package:myapp/features/shop/service/interface/i_service_service.dart';
import 'package:myapp/features/shop/service/interface/i_shop_service.dart';
import 'package:myapp/features/shop/service/interface/service-interface.dart';
import 'package:myapp/features/shop/service/service_detail_service.dart';
import 'package:myapp/features/shop/service/service_service.dart';
import 'package:myapp/features/shop/service/shop_service.dart';
import 'package:myapp/shared/model/shop.dart';
import 'package:myapp/shared/widgets/common/app_spacing.dart';
import 'package:myapp/features/shop/service/interface/i_appointment_service.dart';
import 'package:myapp/features/shop/screen/service_detail_screen.dart';
import 'package:myapp/features/shop/widgets/service_grid_widget.dart';

import 'package:myapp/features/shop/widgets/loading_state_widget.dart';

class ShopServiceScreen extends StatefulWidget {
  final String? shopId;

  const ShopServiceScreen({super.key, this.shopId});

  @override
  State<ShopServiceScreen> createState() => _ShopServiceScreenState();
}

class _ShopServiceScreenState extends State<ShopServiceScreen> {
  final TextEditingController _searchController = TextEditingController();
  // ✅ REMOVED: Cart service - single service booking only
  final List<Service> _serviceList = [];
  final List<Shop> _shopList = [];
  // Removed filter functionality

  // ✅ UPDATED: Use actual services
  late final IServiceService _serviceService;
  late final IServiceDetailService _serviceDetailService;
  late final IAppointmentService _appointmentService;
  late final IShopService _shopService;
  bool _isLoading = false;
  int _currentPage = 1;

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
      _serviceService = ServiceService();
      _shopService = ShopService();

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
      ServiceListResponse response;

      // Nếu có shopId, lấy services theo shop, ngược lại lấy tất cả
      response = await _serviceService.getActiveServices(
        pageIndex: _currentPage,
        pageSize: 20,
      );

      if (response.items.isNotEmpty) {
        setState(() {
          if (_currentPage == 1) {
            _serviceList.clear();
          }
          _serviceList.addAll(response.items);
        });
      } else {
        // Nếu không có data từ API, fallback sang mock
        _loadMockData();
      }
    } catch (e) {
      print('[ShopServiceScreen] Load services data failed: $e');
      // Fallback to mock data if API fails
      _loadMockData();
    }
  }

  // ✅ Fallback mock data - services without price
  void _loadMockData() {
    final mockServices = [
      {
        "id": "09e9c6ac2f8e4fdda9db6e67366930a0",
        'name': 'Dịch vụ Spa Thú Cưng',
        'shopId': 'SHOP001',
        'description':
            'Dịch vụ spa cao cấp cho thú cưng với không gian thoải mái và thiết bị hiện đại',
        'imgUrl': 'https://example.com/spa.jpg',
        'status': true,
      },
      {
        "id": "be7261667b61428db5f3d620fafc0fe0",
        'name': 'Khám Sức Khỏe Tổng Quát',
        'shopId': 'SHOP002',
        'description':
            'Dịch vụ khám sức khỏe định kỳ với bác sĩ thú y có kinh nghiệm',
        'imgUrl': 'https://example.com/checkup.jpg',
        'status': true,
      },
    ];

    // Convert to Service format for compatibility
    final services = mockServices
        .asMap()
        .entries
        .map(
          (entry) => Service(
            id: 'mock_${entry.key + 1}',
            name: entry.value['name'] as String,
            shopId: entry.value['shopId'] as String,
            description: entry.value['description'] as String,
            imgUrl: entry.value['imgUrl'] as String,
            status: entry.value['status'] as bool,
          ),
        )
        .toList();

    setState(() {
      _serviceList.addAll(services);
    });
  }

  // ✅ Load shop data từ API
  Future<void> _loadShopData() async {
    try {
      // Lấy danh sách tất cả shop active
      final response = await _shopService.getActiveShops(
        pageIndex: 1,
        pageSize: 100, // Lấy nhiều shop để match với services
      );

      if (response.items.isNotEmpty) {
        // Convert API Shop to local Shop model
        final shops = response.items
            .map(
              (apiShop) => Shop(
                shopId: apiShop.id,
                owner: apiShop.ownerId,
                shopName: apiShop.name,
                description: apiShop.description,
                status: apiShop.status == 1,
                workingDays: apiShop.workingDays,
              ),
            )
            .toList();

        setState(() {
          _shopList.clear();
          _shopList.addAll(shops);
        });
        print('[ShopServiceScreen] Loaded ${shops.length} shops from API');
      } else {
        print('[ShopServiceScreen] No shops found from API, using mock data');
        await _loadMockShopData();
      }
    } catch (e) {
      print('[ShopServiceScreen] Load shop data failed: $e');
      // Fallback to mock data if API fails
      await _loadMockShopData();
    }
  }

  Future<void> _loadMockShopData() async {
    final mockShops = [
      Shop(
        shopId: 'SHOP001',
        owner: 'Dr. Nguyễn Văn A',
        shopName: 'Pet Spa Paradise',
        description: 'Spa cao cấp cho thú cưng',
        status: true,
        workingDays: 'Thứ 2 - Chủ nhật',
      ),
      Shop(
        shopId: 'SHOP002',
        owner: 'Dr. Trần Thị B',
        shopName: 'Veterinary Clinic Plus',
        description: 'Phòng khám thú y chuyên nghiệp',
        status: true,
        workingDays: 'Thứ 2 - Chủ nhật',
      ),
      Shop(
        shopId: 'SHOP003',
        owner: 'Lê Văn C',
        shopName: 'Pet Hotel Luxury',
        description: 'Khách sạn thú cưng 5 sao',
        status: true,
        workingDays: '24/7',
      ),
      Shop(
        shopId: 'SHOP004',
        owner: 'Phạm Thị D',
        shopName: 'Pet Training Academy',
        description: 'Học viện huấn luyện thú cưng',
        status: true,
        workingDays: 'Thứ 2 - Thứ 7',
      ),
    ];

    setState(() {
      _shopList.addAll(mockShops);
    });
  }

  /// Lấy shop theo ID từ danh sách đã load
  Shop? getShopById(String shopId) {
    try {
      return _shopList.firstWhere((shop) => shop.shopId == shopId);
    } catch (e) {
      return null;
    }
  }

  /// Lấy shop từ API theo ID (nếu cần)
  Future<Shop?> fetchShopById(String shopId) async {
    try {
      final response = await _shopService.getShopById(shopId);
      return Shop(
        shopId: response.shop.id,
        owner: response.shop.ownerId,
        shopName: response.shop.name,
        description: response.shop.description,
        status: response.shop.status == 1,
        workingDays: response.shop.workingDays,
      );
    } catch (e) {
      print('[ShopServiceScreen] Fetch shop by ID failed: $e');
      return null;
    }
  }

  // ✅ Navigate to service detail for booking
  void _viewServiceDetail(Service service) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ServiceDetailScreen(
          serviceId: service.id,
          serviceName: service.name,
        ),
      ),
    );
  }

  // ✅ UPDATED: Show appointment dialog with ServiceDetail info

  // ✅ Show success dialog

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
      return const LoadingStateWidget();
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
                  // Services grid with shop info in each card
                  ServiceGridWidget(
                    services: filteredServices,
                    onServiceTap: _viewServiceDetail,
                    paddingResponsive: paddingResponsive,
                    shops: _shopList,
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

  // ✅ UPDATED: Build service card using ServiceDetail

  // ✅ UPDATED: Get all services (no filtering)
  List<Service> _getFilteredServices() {
    final searchTerm = _searchController.text.toLowerCase();
    return _serviceList.where((service) {
      return service.name.toLowerCase().contains(searchTerm);
    }).toList();
  }
}
