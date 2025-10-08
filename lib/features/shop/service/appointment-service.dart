// lib/features/appointment/services/appointment_service.dart
import 'package:myapp/core/network/dio_service.dart';
import 'package:myapp/features/shop/service/interface/appointment-interface.dart';
import 'package:myapp/features/shop/service/interface/i_appointment_service.dart';
import 'package:myapp/core/utils/logger_service.dart';

final logger = LoggerService.instance;

/// Service để tương tác với API Appointment.
/// - Sử dụng DioClient singleton (hỗ trợ customBaseUrl).
/// - Cung cấp các API CRUD cho appointment.
class AppointmentService implements IAppointmentService {
  static final AppointmentService _instance = AppointmentService._internal();
  factory AppointmentService() => _instance;
  AppointmentService._internal();

  late final DioClient _dioService;
  bool _isInitialized = false;

  // Base URL cho appointment API
  static const String _baseUrl = "https://appointment.devnest.io.vn";

  // Prefix endpoint
  static const String _apiPrefix = '/api/appointment';

  /// Khởi tạo service (gọi một lần).
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      logger.d('[AppointmentService] Bắt đầu khởi tạo với baseUrl: $_baseUrl');
      _dioService = DioClient();
      await _dioService.initialize(_baseUrl);
      _isInitialized = true;
      logger.d('[AppointmentService] Khởi tạo thành công');
    } catch (e, st) {
      _isInitialized = true;
      logger.d('[AppointmentService] Khởi tạo thất bại: $e\n$st');
      rethrow;
    }
  }

  /// Đảm bảo service đã được khởi tạo trước khi gọi API.
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  @override
  Future<AppointmentListResponse> getAllAppointments({
    int pageIndex = 1,
    int pageSize = 10,
    String? sortColumn,
    String sortDirection = 'asc',
    String customerId = '',
  }) async {
    await _ensureInitialized();

    try {
      final queryParams = <String, dynamic>{
        'pageIndex': pageIndex,
        'pageSize': pageSize,
        'sortDirection': sortDirection,
        'customerId': customerId,
      };

      if (sortColumn != null) {
        queryParams['sortColumn'] = sortColumn;
      }

      final response = await _dioService.get(
        _apiPrefix,
        queryParameters: queryParams,
        customBaseUrl: _baseUrl,
      );

      return AppointmentListResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } catch (e, st) {
      logger.d(
        '[AppointmentService] Lấy danh sách appointment thất bại: $e\n$st',
      );
      throw Exception('Lấy danh sách cuộc hẹn thất bại: ${e.toString()}');
    }
  }

  // @override
  // Future<AppointmentDetailResponse> getAppointmentById(String id) async {
  //   await _ensureInitialized();

  //   try {
  //     final response = await _dioService.get(
  //       '$_apiPrefix/$id',
  //       customBaseUrl: _baseUrl,
  //     );

  //     return AppointmentDetailResponse.fromJson(
  //       response.data as Map<String, dynamic>,
  //     );
  //   } catch (e, st) {
  //     logger.d(
  //       '[AppointmentService] Lấy chi tiết appointment thất bại: $e\n$st',
  //     );
  //     throw Exception('Lấy chi tiết cuộc hẹn thất bại: ${e.toString()}');
  //   }
  // }

  @override
  Future<CreateAppointmentResponse> createAppointment(
    CreateAppointmentRequest request,
  ) async {
    await _ensureInitialized();

    try {
      logger.d(
        '[AppointmentService] Tạo appointment với data: ${request.toJson()}',
      );

      final response = await _dioService.post(
        _apiPrefix,
        data: request.toJson(),
        customBaseUrl: _baseUrl,
      );

      logger.d(
        '[AppointmentService] Tạo appointment thành công: ${response.data}',
      );

      return CreateAppointmentResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } catch (e, st) {
      logger.d('[AppointmentService] Tạo appointment thất bại: $e\n$st');
      throw Exception('Tạo cuộc hẹn thất bại: ${e.toString()}');
    }
  }

  @override
  Future<UpdateAppointmentResponse> updateAppointment(
    String id,
    UpdateAppointmentRequest request,
  ) async {
    await _ensureInitialized();

    try {
      final response = await _dioService.put(
        '$_apiPrefix/$id',
        data: request.toJson(),
        customBaseUrl: _baseUrl,
      );

      return UpdateAppointmentResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } catch (e, st) {
      logger.d('[AppointmentService] Cập nhật appointment thất bại: $e\n$st');
      throw Exception('Cập nhật cuộc hẹn thất bại: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteAppointment(String id) async {
    await _ensureInitialized();

    try {
      await _dioService.delete('$_apiPrefix/$id', customBaseUrl: _baseUrl);
    } catch (e, st) {
      logger.d('[AppointmentService] Xóa appointment thất bại: $e\n$st');
      throw Exception('Xóa cuộc hẹn thất bại: ${e.toString()}');
    }
  }

  @override
  Future<void> updateAppointmentTotalAmount(
    String id,
    double totalAmount,
  ) async {
    await _ensureInitialized();

    try {
      await _dioService.put(
        '$_apiPrefix/$id/total-amount',
        data: totalAmount,
        customBaseUrl: _baseUrl,
      );
    } catch (e, st) {
      logger.d('[AppointmentService] Cập nhật tổng tiền thất bại: $e\n$st');
      throw Exception('Cập nhật tổng tiền thất bại: ${e.toString()}');
    }
  }

  // ✅ CONVENIENCE METHODS

  /// Get appointments by customer ID
  Future<AppointmentListResponse> getAppointmentsByCustomer({
    required String customerId,
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
          'customerId': customerId,
          'sortColumn': 'updateat',
          'sortDirection': 'desc',
        },
        customBaseUrl: _baseUrl,
      );

      return AppointmentListResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } catch (e, st) {
      logger.d(
        '[AppointmentService] Lấy appointment theo customer thất bại: $e\n$st',
      );
      throw Exception(
        'Lấy appointment theo customer thất bại: ${e.toString()}',
      );
    }
  }

  /// Get appointments by shop ID
  Future<AppointmentListResponse> getAppointmentsByShop({
    required String shopId,
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
          'sortColumn': 'updateat',
          'sortDirection': 'desc',
        },
        customBaseUrl: _baseUrl,
      );

      return AppointmentListResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } catch (e, st) {
      logger.d(
        '[AppointmentService] Lấy appointment theo shop thất bại: $e\n$st',
      );
      throw Exception('Lấy appointment theo shop thất bại: ${e.toString()}');
    }
  }

  /// Get appointments by status
  Future<AppointmentListResponse> getAppointmentsByStatus({
    required AppointmentStatus status,
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
          'status': status.name,
          'sortColumn': 'updateat',
          'sortDirection': 'desc',
        },
        customBaseUrl: _baseUrl,
      );

      return AppointmentListResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } catch (e, st) {
      logger.d(
        '[AppointmentService] Lấy appointment theo status thất bại: $e\n$st',
      );
      throw Exception('Lấy appointment theo status thất bại: ${e.toString()}');
    }
  }

  /// Lấy thống kê appointment theo status.
  Future<Map<String, int>> getAppointmentStatistics() async {
    await _ensureInitialized();

    try {
      // Get all appointments to calculate statistics
      final response = await getAllAppointments(pageSize: 1000);

      return {
        'total': response.totalItems,
        'pending': response.items
            .where((apt) => apt.status == AppointmentStatus.pending)
            .length,
        'confirmed': response.items
            .where((apt) => apt.status == AppointmentStatus.confirmed)
            .length,
        'finished': response.items
            .where((apt) => apt.status == AppointmentStatus.finished)
            .length,
        'cancel': response.items
            .where((apt) => apt.status == AppointmentStatus.cancel)
            .length,
      };
    } catch (e, st) {
      logger.d(
        '[AppointmentService] Lấy thống kê appointment thất bại: $e\n$st',
      );
      throw Exception('Lấy thống kê appointment thất bại: ${e.toString()}');
    }
  }
}
