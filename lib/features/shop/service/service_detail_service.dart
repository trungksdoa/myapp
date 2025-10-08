import 'package:myapp/core/network/dio_service.dart';
import 'package:myapp/features/shop/service/interface/i_service_detail.dart';
import 'package:myapp/features/shop/service/interface/service-detail-interface.dart';
import 'package:myapp/core/utils/logger_service.dart';

final logger = LoggerService.instance;

/// Service để tương tác với API ServiceDetail.
/// - Sử dụng DioClient singleton (hỗ trợ customBaseUrl).
/// - Gọi các API: list, detail, create, update, delete, search, filter theo shop.
class ServiceDetailService implements IServiceDetailService {
  static final ServiceDetailService _instance =
      ServiceDetailService._internal();
  factory ServiceDetailService() => _instance;
  ServiceDetailService._internal();

  late final DioClient _dioService;
  bool _isInitialized = false;

  // Base URL cho service detail
  static const String _baseUrl = "https://services-detail.devnest.io.vn";

  // Prefix endpoint
  static const String _apiPrefix = '/api/servicedetail';

  /// Khởi tạo service (gọi một lần).
  /// - Nếu đã khởi tạo thì trả về ngay.
  /// - Ghi log đơn giản để debug khi cần.
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      logger.d(
        '[ServiceDetailService] Bắt đầu khởi tạo với baseUrl: $_baseUrl',
      );
      _dioService = DioClient();
      await _dioService.initialize(_baseUrl);
      _isInitialized = true;
      logger.d('[ServiceDetailService] Khởi tạo thành công');
    } catch (e, st) {
      // Đánh dấu đã khởi tạo để tránh vòng lặp khởi tạo vô hạn,
      // nhưng vẫn ném lại lỗi để caller có thể xử lý hoặc fallback.
      _isInitialized = true;
      logger.d('[ServiceDetailService] Khởi tạo thất bại: $e\n$st');
      rethrow;
    }
  }

  /// Đảm bảo service đã được khởi tạo trước khi gọi API.
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  /// Lấy danh sách service detail (có phân trang).
  /// Trả về ServiceDetailListResponse.
  @override
  Future<ServiceDetailListResponse> getAllServiceDetails({
    int pageIndex = 1,
    int pageSize = 10,
    String? sortColumn,
    String sortDirection = 'asc',
    String serviceId = '',
  }) async {
    await _ensureInitialized();

    try {
      final queryParams = <String, dynamic>{
        'pageIndex': pageIndex,
        'pageSize': pageSize,
        'sortDirection': sortDirection,
        'serviceId': serviceId,
      };

      if (sortColumn != null && sortColumn.isNotEmpty) {
        queryParams['sortColumn'] = sortColumn;
      }

      final response = await _dioService.get(
        _apiPrefix,
        queryParameters: queryParams,
        customBaseUrl: _baseUrl,
      );

      return ServiceDetailListResponse.fromJson(response.data);
    } catch (e, st) {
      logger.d('[ServiceDetailService] Lấy danh sách thất bại: $e\n$st');
      throw Exception('Lấy danh sách dịch vụ thất bại: ${e.toString()}');
    }
  }

  /// Lấy chi tiết service theo id.
  @override
  Future<ServiceDetailResponse> getServiceDetailById(String id) async {
    await _ensureInitialized();

    try {
      final response = await _dioService.get(
        '$_apiPrefix/$id',
        customBaseUrl: _baseUrl,
      );
      return ServiceDetailResponse.fromJson(response.data);
    } catch (e, st) {
      logger.d('[ServiceDetailService] Lấy chi tiết thất bại: $e\n$st');
      throw Exception('Lấy chi tiết dịch vụ thất bại: ${e.toString()}');
    }
  }

  /// Tạo mới service detail.
  @override
  Future<CreateServiceDetailResponse> createServiceDetail(
    CreateServiceDetailRequest request,
  ) async {
    await _ensureInitialized();

    try {
      final response = await _dioService.post(
        _apiPrefix,
        data: request.toJson(),
        customBaseUrl: _baseUrl,
      );

      return CreateServiceDetailResponse.fromJson(response.data);
    } catch (e, st) {
      logger.d('[ServiceDetailService] Tạo mới thất bại: $e\n$st');
      throw Exception('Tạo dịch vụ thất bại: ${e.toString()}');
    }
  }

  /// Cập nhật service detail theo id.
  @override
  Future<ServiceDetailResponse> updateServiceDetail(
    String id,
    UpdateServiceDetailRequest request,
  ) async {
    await _ensureInitialized();

    try {
      final response = await _dioService.put(
        '$_apiPrefix/$id',
        data: request.toJson(),
        customBaseUrl: _baseUrl,
      );

      return ServiceDetailResponse.fromJson(response.data);
    } catch (e, st) {
      logger.d('[ServiceDetailService] Cập nhật thất bại: $e\n$st');
      throw Exception('Cập nhật dịch vụ thất bại: ${e.toString()}');
    }
  }

  /// Xóa service detail theo id.
  @override
  Future<bool> deleteServiceDetail(String id) async {
    await _ensureInitialized();

    try {
      final response = await _dioService.delete(
        '$_apiPrefix/$id',
        customBaseUrl: _baseUrl,
      );

      return response.statusCode == 200;
    } catch (e, st) {
      logger.d('[ServiceDetailService] Xóa thất bại: $e\n$st');
      throw Exception('Xóa dịch vụ thất bại: ${e.toString()}');
    }
  }

  /// Lấy danh sách theo category (nếu API hỗ trợ).
  @override
  Future<ServiceDetailListResponse> getServiceDetailsByCategory(
    String categoryId, {
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
          'serviceCategoryId': categoryId,
        },
        customBaseUrl: _baseUrl,
      );

      return ServiceDetailListResponse.fromJson(response.data);
    } catch (e, st) {
      logger.d('[ServiceDetailService] Lấy theo category thất bại: $e\n$st');
      throw Exception('Lấy dịch vụ theo category thất bại: ${e.toString()}');
    }
  }

  /// Tìm kiếm service detail theo từ khóa.
  @override
  Future<ServiceDetailListResponse> searchServiceDetails(
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

      return ServiceDetailListResponse.fromJson(response.data);
    } catch (e, st) {
      logger.d('[ServiceDetailService] Tìm kiếm thất bại: $e\n$st');
      throw Exception('Tìm kiếm dịch vụ thất bại: ${e.toString()}');
    }
  }

  /// Lấy các service đang active.
  @override
  Future<ServiceDetailListResponse> getActiveServiceDetails({
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
          'sortColumn': '',
          'sortDirection': 'asc',
        },
        customBaseUrl: _baseUrl,
      );

      return ServiceDetailListResponse.fromJson(response.data);
    } catch (e, st) {
      logger.d('[ServiceDetailService] Lấy active thất bại: $e\n$st');
      throw Exception('Lấy dịch vụ active thất bại: ${e.toString()}');
    }
  }

  /// Lấy service detail cho một shop cụ thể.
  Future<ServiceDetailListResponse> getServiceDetailsByShop(
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

      return ServiceDetailListResponse.fromJson(response.data);
    } catch (e, st) {
      logger.d('[ServiceDetailService] Lấy theo shop thất bại: $e\n$st');
      throw Exception('Lấy dịch vụ theo shop thất bại: ${e.toString()}');
    }
  }

  /// Lấy các service details liên quan tới một service cha (nếu có).
  @override
  Future<ServiceDetailListResponse> getServiceDetailsByService(
    String serviceId, {
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
          'serviceId': serviceId,
        },
        customBaseUrl: _baseUrl,
      );

      return ServiceDetailListResponse.fromJson(response.data);
    } catch (e, st) {
      logger.d('[ServiceDetailService] Lấy theo service thất bại: $e\n$st');
      throw Exception('Lấy dịch vụ theo service thất bại: ${e.toString()}');
    }
  }
}
