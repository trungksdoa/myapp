import 'package:myapp/core/network/dio_service.dart';
import 'package:myapp/features/shop/service/interface/shop-interface.dart';
import 'package:myapp/features/shop/service/interface/i_shop_service.dart';
import 'package:myapp/core/utils/logger_service.dart';

final logger = LoggerService.instance;

/// Service để tương tác với API Shop.
/// - Sử dụng DioClient singleton (hỗ trợ customBaseUrl).
/// - Gọi các API: list, detail, create, update, delete, search.
class ShopService implements IShopService {
  static final ShopService _instance = ShopService._internal();
  factory ShopService() => _instance;
  ShopService._internal();

  late final DioClient _dioService;
  bool _isInitialized = false;

  // Base URL cho shop API
  static const String _baseUrl = "https://shop.devnest.io.vn";

  // Prefix endpoint
  static const String _apiPrefix = '/api/shop';

  /// Khởi tạo service (gọi một lần).
  @override
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      logger.d('[ShopService] Bắt đầu khởi tạo với baseUrl: $_baseUrl');
      _dioService = DioClient();
      await _dioService.initialize(_baseUrl);
      _isInitialized = true;
      logger.d('[ShopService] Khởi tạo thành công');
    } catch (e, st) {
      _isInitialized = true;
      logger.e('[ShopService] Khởi tạo thất bại: $e\n$st');
      rethrow;
    }
  }

  /// Đảm bảo service đã được khởi tạo trước khi gọi API.
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  /// Lấy danh sách shop (có phân trang và sắp xếp).
  @override
  Future<ShopListResponse> getAllShops({
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

      return ShopListResponse.fromJson(response.data);
    } catch (e, st) {
      logger.e('[ShopService] Lấy danh sách shop thất bại: $e\n$st');
      throw Exception('Lấy danh sách shop thất bại: ${e.toString()}');
    }
  }

  /// Lấy chi tiết shop theo id.
  @override
  Future<ShopResponse> getShopById(String id) async {
    await _ensureInitialized();

    try {
      final response = await _dioService.get(
        '$_apiPrefix/$id',
        customBaseUrl: _baseUrl,
      );
      return ShopResponse.fromJson(response.data);
    } catch (e, st) {
      logger.e('[ShopService] Lấy chi tiết shop thất bại: $e\n$st');
      throw Exception('Lấy chi tiết shop thất bại: ${e.toString()}');
    }
  }

  /// Tạo mới shop.
  @override
  Future<CreateShopResponse> createShop(CreateShopRequest request) async {
    await _ensureInitialized();

    try {
      final response = await _dioService.post(
        _apiPrefix,
        data: request.toJson(),
        customBaseUrl: _baseUrl,
      );

      return CreateShopResponse.fromJson(response.data);
    } catch (e, st) {
      logger.e('[ShopService] Tạo shop thất bại: $e\n$st');
      throw Exception('Tạo shop thất bại: ${e.toString()}');
    }
  }

  /// Cập nhật shop theo id.
  @override
  Future<ShopResponse> updateShop(String id, UpdateShopRequest request) async {
    await _ensureInitialized();

    try {
      final response = await _dioService.put(
        '$_apiPrefix/$id',
        data: request.toJson(),
        customBaseUrl: _baseUrl,
      );

      return ShopResponse.fromJson(response.data);
    } catch (e, st) {
      logger.e('[ShopService] Cập nhật shop thất bại: $e\n$st');
      throw Exception('Cập nhật shop thất bại: ${e.toString()}');
    }
  }

  /// Xóa shop theo id.
  @override
  Future<bool> deleteShop(String id) async {
    await _ensureInitialized();

    try {
      final response = await _dioService.delete(
        '$_apiPrefix/$id',
        customBaseUrl: _baseUrl,
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e, st) {
      logger.e('[ShopService] Xóa shop thất bại: $e\n$st');
      throw Exception('Xóa shop thất bại: ${e.toString()}');
    }
  }

  /// Tìm kiếm shop theo từ khóa.
  @override
  Future<ShopListResponse> searchShops(
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

      return ShopListResponse.fromJson(response.data);
    } catch (e, st) {
      logger.e('[ShopService] Tìm kiếm shop thất bại: $e\n$st');
      throw Exception('Tìm kiếm shop thất bại: ${e.toString()}');
    }
  }

  /// Lấy các shop đang hoạt động (status = 1).
  @override
  Future<ShopListResponse> getActiveShops({
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
          'status': 1, // Filter by active status
        },
        customBaseUrl: _baseUrl,
      );

      return ShopListResponse.fromJson(response.data);
    } catch (e, st) {
      logger.e('[ShopService] Lấy shop active thất bại: $e\n$st');
      throw Exception('Lấy shop active thất bại: ${e.toString()}');
    }
  }

  /// Lấy shop theo owner id.
  @override
  Future<ShopListResponse> getShopsByOwner(
    String ownerId, {
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
          'ownerId': ownerId,
        },
        customBaseUrl: _baseUrl,
      );

      return ShopListResponse.fromJson(response.data);
    } catch (e, st) {
      logger.e('[ShopService] Lấy shop theo owner thất bại: $e\n$st');
      throw Exception('Lấy shop theo owner thất bại: ${e.toString()}');
    }
  }

  /// Cập nhật status của shop.
  @override
  Future<ShopResponse> updateShopStatus(String id, int status) async {
    await _ensureInitialized();

    try {
      final updateRequest = UpdateShopRequest(status: status);

      final response = await _dioService.put(
        '$_apiPrefix/$id',
        data: updateRequest.toJson(),
        customBaseUrl: _baseUrl,
      );

      return ShopResponse.fromJson(response.data);
    } catch (e, st) {
      logger.e('[ShopService] Cập nhật status shop thất bại: $e\n$st');
      throw Exception('Cập nhật status shop thất bại: ${e.toString()}');
    }
  }

  /// Lấy số lượng shop theo status.
  @override
  Future<Map<String, int>> getShopStatistics() async {
    await _ensureInitialized();

    try {
      // Get all shops to calculate statistics
      final response = await getAllShops(pageSize: 1000);

      final activeCount = response.items
          .where((shop) => shop.status == 1)
          .length;
      final inactiveCount = response.items
          .where((shop) => shop.status == 0)
          .length;

      return {
        'total': response.totalItems,
        'active': activeCount,
        'inactive': inactiveCount,
      };
    } catch (e, st) {
      logger.e('[ShopService] Lấy thống kê shop thất bại: $e\n$st');
      throw Exception('Lấy thống kê shop thất bại: ${e.toString()}');
    }
  }
}
