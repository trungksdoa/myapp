import 'package:myapp/core/network/dio_service.dart';
import 'package:myapp/features/shop/service/interface/service_category.dart';
import 'package:myapp/features/shop/service/interface/i_service_category_service.dart';
import 'package:myapp/core/utils/logger_service.dart';

final logger = LoggerService.instance;

/// Service để tương tác với API Service Category.
/// - Sử dụng DioClient singleton (hỗ trợ customBaseUrl).
/// - Chỉ cung cấp các API GET: list, detail, search.
class ServiceCategoryService implements IServiceCategoryService {
  static final ServiceCategoryService _instance =
      ServiceCategoryService._internal();
  factory ServiceCategoryService() => _instance;
  ServiceCategoryService._internal();

  late final DioClient _dioService;
  bool _isInitialized = false;

  // Base URL cho service category API
  static const String _baseUrl = "https://category.devnest.io.vn";

  // Prefix endpoint
  static const String _apiPrefix = '/api/servicecategory';

  /// Khởi tạo service (gọi một lần).
  @override
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      logger.d(
        '[ServiceCategoryService] Bắt đầu khởi tạo với baseUrl: $_baseUrl',
      );
      _dioService = DioClient();
      await _dioService.initialize(_baseUrl);
      _isInitialized = true;
      logger.d('[ServiceCategoryService] Khởi tạo thành công');
    } catch (e, st) {
      _isInitialized = true;
      logger.d('[ServiceCategoryService] Khởi tạo thất bại: $e\n$st');
      rethrow;
    }
  }

  /// Đảm bảo service đã được khởi tạo trước khi gọi API.
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  /// Lấy danh sách service category (có phân trang và sắp xếp).
  @override
  Future<ServiceCategoryListResponse> getAllServiceCategories({
    int pageIndex = 1,
    int pageSize = 10,
    String? sortColumn,
    String sortDirection = 'asc',
  }) async {
    await _ensureInitialized();

    try {
      final queryParams = <String, dynamic>{
        'pageIndex': pageIndex,
        'pageSize': pageSize,
        'sortDirection': sortDirection,
      };

      if (sortColumn != null && sortColumn.isNotEmpty) {
        queryParams['sortColumn'] = sortColumn;
      }

      final response = await _dioService.get(
        _apiPrefix,
        queryParameters: queryParams,
        customBaseUrl: _baseUrl,
      );

      return ServiceCategoryListResponse.fromJson(response.data);
    } catch (e, st) {
      logger.d(
        '[ServiceCategoryService] Lấy danh sách service category thất bại: $e\n$st',
      );
      throw Exception(
        'Lấy danh sách service category thất bại: ${e.toString()}',
      );
    }
  }

  /// Lấy chi tiết service category theo id.
  @override
  Future<ServiceCategoryResponse> getServiceCategoryById(String id) async {
    await _ensureInitialized();

    try {
      final response = await _dioService.get(
        '$_apiPrefix/$id',
        customBaseUrl: _baseUrl,
      );
      return ServiceCategoryResponse.fromJson(response.data);
    } catch (e, st) {
      logger.d(
        '[ServiceCategoryService] Lấy chi tiết service category thất bại: $e\n$st',
      );
      throw Exception(
        'Lấy chi tiết service category thất bại: ${e.toString()}',
      );
    }
  }

  /// Tìm kiếm service category theo từ khóa.
  @override
  Future<ServiceCategoryListResponse> searchServiceCategories(
    String searchTerm, {
    int pageIndex = 1,
    int pageSize = 10,
  }) async {
    await _ensureInitialized();

    try {
      final response = await _dioService.get(
        _apiPrefix,
        queryParameters: {
          'pageIndex': pageIndex,
          'pageSize': pageSize,
          'search': searchTerm,
        },
        customBaseUrl: _baseUrl,
      );

      return ServiceCategoryListResponse.fromJson(response.data);
    } catch (e, st) {
      logger.d(
        '[ServiceCategoryService] Tìm kiếm service category thất bại: $e\n$st',
      );
      throw Exception('Tìm kiếm service category thất bại: ${e.toString()}');
    }
  }

  /// Lấy service category theo shop id.
  @override
  Future<ServiceCategoryListResponse> getServiceCategoriesByShop(
    String shopId, {
    int pageIndex = 1,
    int pageSize = 10,
  }) async {
    await _ensureInitialized();

    try {
      final response = await _dioService.get(
        _apiPrefix,
        queryParameters: {
          'pageIndex': pageIndex,
          'pageSize': pageSize,
          'shopId': shopId,
        },
        customBaseUrl: _baseUrl,
      );

      return ServiceCategoryListResponse.fromJson(response.data);
    } catch (e, st) {
      logger.d(
        '[ServiceCategoryService] Lấy service category theo shop thất bại: $e\n$st',
      );
      throw Exception(
        'Lấy service category theo shop thất bại: ${e.toString()}',
      );
    }
  }

  /// Lấy service category theo shop name.
  @override
  Future<ServiceCategoryListResponse> getServiceCategoriesByShopName(
    String shopName, {
    int pageIndex = 1,
    int pageSize = 10,
  }) async {
    await _ensureInitialized();

    try {
      final response = await _dioService.get(
        _apiPrefix,
        queryParameters: {
          'pageIndex': pageIndex,
          'pageSize': pageSize,
          'shopName': shopName,
        },
        customBaseUrl: _baseUrl,
      );

      return ServiceCategoryListResponse.fromJson(response.data);
    } catch (e, st) {
      logger.d(
        '[ServiceCategoryService] Lấy service category theo shop name thất bại: $e\n$st',
      );
      throw Exception(
        'Lấy service category theo shop name thất bại: ${e.toString()}',
      );
    }
  }

  /// Lấy thống kê service category theo shop.
  Future<Map<String, int>> getServiceCategoryStatistics() async {
    await _ensureInitialized();

    try {
      // Get all service categories to calculate statistics
      final response = await getAllServiceCategories(pageSize: 1000);

      // Group by shop
      final shopStats = <String, int>{};
      for (final category in response.items) {
        shopStats[category.shopName] = (shopStats[category.shopName] ?? 0) + 1;
      }

      return {
        'total': response.totalItems,
        'uniqueShops': shopStats.length,
        ...shopStats,
      };
    } catch (e, st) {
      logger.d(
        '[ServiceCategoryService] Lấy thống kê service category thất bại: $e\n$st',
      );
      throw Exception(
        'Lấy thống kê service category thất bại: ${e.toString()}',
      );
    }
  }

  /// Lấy service category theo nhiều shop ids.
  Future<ServiceCategoryListResponse> getServiceCategoriesByMultipleShops(
    List<String> shopIds, {
    int pageIndex = 1,
    int pageSize = 10,
  }) async {
    await _ensureInitialized();

    try {
      final response = await _dioService.get(
        _apiPrefix,
        queryParameters: {
          'pageIndex': pageIndex,
          'pageSize': pageSize,
          'shopIds': shopIds.join(','), // Join shop IDs with comma
        },
        customBaseUrl: _baseUrl,
      );

      return ServiceCategoryListResponse.fromJson(response.data);
    } catch (e, st) {
      logger.d(
        '[ServiceCategoryService] Lấy service category theo multiple shops thất bại: $e\n$st',
      );
      throw Exception(
        'Lấy service category theo multiple shops thất bại: ${e.toString()}',
      );
    }
  }

  /// Lấy tất cả shop names từ service categories.
  Future<List<String>> getAllShopNames() async {
    await _ensureInitialized();

    try {
      final response = await getAllServiceCategories(pageSize: 1000);
      final shopNames = response.items
          .map((category) => category.shopName)
          .toSet()
          .toList();

      shopNames.sort(); // Sort alphabetically
      return shopNames;
    } catch (e, st) {
      logger.d(
        '[ServiceCategoryService] Lấy danh sách shop names thất bại: $e\n$st',
      );
      throw Exception('Lấy danh sách shop names thất bại: ${e.toString()}');
    }
  }
}
