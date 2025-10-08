import 'package:flutter/material.dart';
import 'package:myapp/core/utils/device_size.dart';
import 'package:myapp/features/shop/service/interface/service_category.dart';
import 'package:myapp/shared/widgets/common/app_spacing.dart';
import 'package:myapp/features/shop/service/service_category_service.dart';
import 'package:myapp/features/shop/screen/service_screen.dart';

// Mock data để fallback khi API fail
final List<Map<String, String>> mockServiceCategories = [
  {
    "id": "5b70b9a9335147128e07b1bc8b648e9a",
    "name": "Mát xa nâng cao",
    "shopId": "4c3f2177cf22481dabd063f0572df905",
    "shopName": "Divineder",
  },
  {
    "id": "d41211e55eb749f69a124edf83906f3a",
    "name": "Tiêm phòng",
    "shopId": "4c3f2177cf22481dabd063f0572df905",
    "shopName": "Divineder",
  },
  {
    "id": "58daf0341f154dacbea904c50ca77af1",
    "name": "Thiến",
    "shopId": "4c3f2177cf22481dabd063f0572df905",
    "shopName": "Divineder",
  },
  {
    "id": "be3e2275a3b74133864391b9a9169dad",
    "name": "An tử",
    "shopId": "4c3f2177cf22481dabd063f0572df905",
    "shopName": "Divineder",
  },
];

class ShopServiceScreen extends StatefulWidget {
  const ShopServiceScreen({super.key});

  @override
  State<ShopServiceScreen> createState() => _ShopServiceScreenState();
}

class _ShopServiceScreenState extends State<ShopServiceScreen> {
  final ServiceCategoryService _serviceCategoryService =
      ServiceCategoryService();
  List<ServiceCategory> _serviceCategories = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _loadServices() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Initialize ServiceCategoryService
      await _serviceCategoryService.initialize();

      // Load service categories from API
      final response = await _serviceCategoryService.getAllServiceCategories(
        pageSize: 50,
      );

      setState(() {
        _serviceCategories = response.items;
        _isLoading = false;
      });
    } catch (e) {
      print('[ShopServiceScreen] Load service categories failed: $e');
      // Fallback to mock data
      _loadMockData();
      setState(() {
        _error =
            'Không thể tải danh mục dịch vụ từ server. Hiển thị dữ liệu mẫu.';
        _isLoading = false;
      });
    }
  }

  void _loadMockData() {
    _serviceCategories = mockServiceCategories.map((mockService) {
      return ServiceCategory(
        id: mockService['id']!,
        name: mockService['name']!,
        shopId: mockService['shopId']!,
        shopName: mockService['shopName']!,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    double paddingResponsive = DeviceSize.getResponsivePadding(
      MediaQuery.of(context).size.width,
    );

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Danh mục dịch vụ',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        // centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              // Show loading feedback
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Đang tải lại danh mục dịch vụ...'),
                  duration: Duration(seconds: 1),
                ),
              );

              // Trigger reload
              await _loadServices();

              // Show success feedback
              if (_error == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đã tải lại danh mục dịch vụ thành công'),
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            tooltip: 'Tải lại danh mục dịch vụ',
          ),
        ],
      ),
      body: Column(
        children: [
          // Service grid section
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
                  // Section title với error message
                  Padding(
                    padding: EdgeInsets.all(paddingResponsive),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.list_alt,
                              color: Colors.orange,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Danh Mục Dịch Vụ (${_serviceCategories.length})',
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
                              color: Colors.orange[50],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.orange[200]!),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.warning,
                                  color: Colors.orange[600],
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _error!,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.orange[700],
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

                  // Services grid hoặc loading
                  Expanded(
                    child: _isLoading
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 16),
                                Text('Đang tải danh mục dịch vụ...'),
                              ],
                            ),
                          )
                        : _serviceCategories.isEmpty
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.inbox, size: 64, color: Colors.grey),
                                SizedBox(height: 16),
                                Text('Không có danh mục dịch vụ nào'),
                              ],
                            ),
                          )
                        : GridView.builder(
                            padding: EdgeInsets.symmetric(
                              horizontal: paddingResponsive,
                            ),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 8,
                                  crossAxisSpacing: 8,
                                  childAspectRatio: 1.1,
                                ),
                            itemCount: _serviceCategories.length,
                            itemBuilder: (context, index) {
                              final serviceCategory = _serviceCategories[index];
                              return _buildCompactServiceCard(serviceCategory);
                            },
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

  Widget _buildCompactServiceCard(ServiceCategory serviceCategory) {
    return GestureDetector(
      onTap: () => _showServiceDetail(serviceCategory),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Service icon - compact
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getServiceColor(serviceCategory.name),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: _getServiceColor(
                      serviceCategory.name,
                    ).withOpacity(0.2),
                    spreadRadius: 0,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                _getServiceIcon(serviceCategory.name),
                color: Colors.white,
                size: 24,
              ),
            ),

            const SizedBox(height: 8),
            // Service name - compact
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                serviceCategory.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  height: 1.1,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(height: 4),
            // Shop name info - compact
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.store, size: 10, color: Colors.grey[600]),
                const SizedBox(width: 3),
                Flexible(
                  child: Text(
                    serviceCategory.shopName,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),
            // View details button - compact
            Container(
              width: double.infinity,
              height: 28,
              decoration: BoxDecoration(
                color: _getServiceColor(serviceCategory.name).withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: _getServiceColor(
                    serviceCategory.name,
                  ).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  'Xem chi tiết',
                  style: TextStyle(
                    color: _getServiceColor(serviceCategory.name),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getServiceColor(String serviceName) {
    final name = serviceName.toLowerCase();

    if (name.contains('mát xa') || name.contains('massage')) {
      return Colors.orange;
    } else if (name.contains('tiêm') || name.contains('vaccine')) {
      return Colors.blue;
    } else if (name.contains('thiến') || name.contains('surgery')) {
      return Colors.purple;
    } else if (name.contains('ăn') || name.contains('food')) {
      return Colors.brown;
    } else if (name.contains('tắm') ||
        name.contains('grooming') ||
        name.contains('spa')) {
      return Colors.cyan;
    } else if (name.contains('huấn luyện') || name.contains('training')) {
      return Colors.green;
    } else if (name.contains('khách sạn') || name.contains('hotel')) {
      return Colors.indigo;
    } else {
      return Colors.grey;
    }
  }

  IconData _getServiceIcon(String serviceName) {
    final name = serviceName.toLowerCase();

    if (name.contains('mát xa') || name.contains('massage')) {
      return Icons.spa;
    } else if (name.contains('tiêm') || name.contains('vaccine')) {
      return Icons.vaccines;
    } else if (name.contains('thiến') || name.contains('surgery')) {
      return Icons.medical_services;
    } else if (name.contains('ăn') || name.contains('food')) {
      return Icons.restaurant;
    } else if (name.contains('tắm') ||
        name.contains('grooming') ||
        name.contains('spa')) {
      return Icons.bathtub;
    } else if (name.contains('huấn luyện') || name.contains('training')) {
      return Icons.school;
    } else if (name.contains('khách sạn') || name.contains('hotel')) {
      return Icons.hotel;
    } else {
      return Icons.pets;
    }
  }

  void _showServiceDetail(ServiceCategory serviceCategory) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
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

                  // Service content
                  // Service info
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: _getServiceColor(serviceCategory.name),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(
                          _getServiceIcon(serviceCategory.name),
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      AppSpacing.horizontal(16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              serviceCategory.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            AppSpacing.vertical(4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.store,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    serviceCategory.shopName,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            AppSpacing.vertical(4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  size: 16,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Danh mục hoạt động',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.green[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  AppSpacing.vertical(24),

                  // Service description
                  Text(
                    'Thông tin danh mục',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  AppSpacing.vertical(8),
                  Text(
                    'Danh mục dịch vụ "${serviceCategory.name}" tại cửa hàng ${serviceCategory.shopName}. Đây là một trong những danh mục dịch vụ chất lượng cao với đội ngũ chuyên nghiệp và trang thiết bị hiện đại.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                  ),

                  AppSpacing.vertical(16),

                  // Additional info
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Thông tin bổ sung',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'ID: ${serviceCategory.id}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          'Shop ID: ${serviceCategory.shopId}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Action button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ServiceScreen(serviceCategory: serviceCategory),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _getServiceColor(serviceCategory.name),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Xem dịch vụ trong danh mục',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
