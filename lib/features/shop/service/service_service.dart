import 'package:myapp/core/network/dio_service.dart';
import 'package:myapp/features/shop/service/interface/service-interface.dart';
import 'package:myapp/features/shop/service/interface/i_service_service.dart';
import 'package:myapp/core/utils/logger_service.dart';

final logger = LoggerService.instance;

/// Service để tương tác với API Service.
/// - Sử dụng DioClient singleton (hỗ trợ customBaseUrl).
/// - Chỉ cung cấp các API GET: list, detail, search.
class ServiceService implements IServiceService {
  static final ServiceService _instance = ServiceService._internal();
  factory ServiceService() => _instance;
  ServiceService._internal();

  late final DioClient _dioService;
  bool _isInitialized = false;

  // Base URL cho service API
  static const String _baseUrl = "https://service.devnest.io.vn";

  // Prefix endpoint
  static const String _apiPrefix = '/api/service';

  /// Khởi tạo service (gọi một lần).
  @override
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      logger.d('[ServiceService] Bắt đầu khởi tạo với baseUrl: $_baseUrl');
      _dioService = DioClient();
      await _dioService.initialize(_baseUrl);
      _isInitialized = true;
      logger.d('[ServiceService] Khởi tạo thành công');
    } catch (e, st) {
      _isInitialized = true;
      logger.d('[ServiceService] Khởi tạo thất bại: $e\n$st');
      rethrow;
    }
  }

  /// Đảm bảo service đã được khởi tạo trước khi gọi API.
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  /// Lấy danh sách service (có phân trang và sắp xếp).
  @override
  Future<ServiceListResponse> getAllServices({
    int pageIndex = 1,
    int pageSize = 10,
    String? sortColumn,
    String sortDirection = 'asc',
    String serviceCategoryId = '',
  }) async {
    await _ensureInitialized();

    try {
      final queryParams = <String, dynamic>{
        'pageIndex': pageIndex,
        'pageSize': pageSize,
        'sortDirection': sortDirection,
      };

      if (serviceCategoryId.isNotEmpty) {
        queryParams['serviceCategoryId'] = serviceCategoryId;
      }

      final response = await _dioService.get(
        _apiPrefix,
        queryParameters: queryParams,
        customBaseUrl: _baseUrl,
      );

      print('Response data: ${response.data}'); // Debug log

      return ServiceListResponse.fromJson(response.data);
    } catch (e, st) {
      logger.d('[ServiceService] Lấy danh sách service thất bại: $e\n$st');
      throw Exception('Lấy danh sách service thất bại: ${e.toString()}');
    }
  }

  /// Lấy chi tiết service theo id.
  @override
  Future<ServiceResponse> getServiceById(String id) async {
    await _ensureInitialized();

    try {
      final response = await _dioService.get(
        '$_apiPrefix/$id',
        customBaseUrl: _baseUrl,
      );
      return ServiceResponse.fromJson(response.data);
    } catch (e, st) {
      logger.d('[ServiceService] Lấy chi tiết service thất bại: $e\n$st');
      throw Exception('Lấy chi tiết service thất bại: ${e.toString()}');
    }
  }

  /// Tìm kiếm service theo từ khóa.
  @override
  Future<ServiceListResponse> searchServices(
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

      return ServiceListResponse.fromJson(response.data);
    } catch (e, st) {
      logger.d('[ServiceService] Tìm kiếm service thất bại: $e\n$st');
      throw Exception('Tìm kiếm service thất bại: ${e.toString()}');
    }
  }

  /// Lấy các service đang hoạt động (status = true).
  @override
  Future<ServiceListResponse> getActiveServices({
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
          'status': true, // Filter by active status
        },
        customBaseUrl: _baseUrl,
      );

      return ServiceListResponse.fromJson(response.data);
    } catch (e, st) {
      logger.d('[ServiceService] Lấy service active thất bại: $e\n$st');
      throw Exception('Lấy service active thất bại: ${e.toString()}');
    }
  }

  /// Lấy service theo shop id.
  @override
  Future<ServiceListResponse> getServicesByShop(
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

      return ServiceListResponse.fromJson(response.data);
    } catch (e, st) {
      logger.d('[ServiceService] Lấy service theo shop thất bại: $e\n$st');
      throw Exception('Lấy service theo shop thất bại: ${e.toString()}');
    }
  }

  /// Lấy thống kê service theo status.
  Future<Map<String, int>> getServiceStatistics() async {
    await _ensureInitialized();

    try {
      // Get all services to calculate statistics
      final response = await getAllServices(pageSize: 1000);

      return {
        'total': response.totalItems,
        'active': response.items.where((service) => service.isActive).length,
        'inactive': response.items.where((service) => !service.isActive).length,
      };
    } catch (e, st) {
      logger.d('[ServiceService] Lấy thống kê service thất bại: $e\n$st');
      throw Exception('Lấy thống kê service thất bại: ${e.toString()}');
    }
  }

  /// Lấy service theo nhiều shop ids.
  Future<ServiceListResponse> getServicesByMultipleShops(
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

      return ServiceListResponse.fromJson(response.data);
    } catch (e, st) {
      logger.d(
        '[ServiceService] Lấy service theo multiple shops thất bại: $e\n$st',
      );
      throw Exception(
        'Lấy service theo multiple shops thất bại: ${e.toString()}',
      );
    }
  }
}
