// lib/features/appointment/services/appointment_service.dart
import 'package:myapp/core/network/dio_service_old.dart';
import 'package:myapp/features/shop/service/interface/appointment-interface.dart';
import 'package:myapp/features/shop/service/interface/i_appointment_service.dart';

class AppointmentService implements IAppointmentService {
  static final AppointmentService _instance = AppointmentService._internal();
  factory AppointmentService() => _instance;
  AppointmentService._internal();

  late final DioClient _dioService;
  bool _isInitialized = false;

  // ✅ Base URL for appointment service
  static const String _baseUrl =
      "https://appointment.devnest.io.vn"; // Replace with actual URL

  // ✅ Async initialization
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _dioService = DioClient();
      await _dioService.initialize(_baseUrl);
      _isInitialized = true;
    } catch (e) {
      print('[AppointmentService] Initialize failed: $e');
      _isInitialized = true;
    }
  }

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
  }) async {
    await _ensureInitialized();

    try {
      final response = await _dioService.get(
        '/api/appointment',
        queryParameters: {
          'pageIndex': pageIndex,
          'pageSize': pageSize,
          if (sortColumn != null) 'sortColumn': sortColumn,
          'sortDirection': sortDirection,
        },
      );

      return AppointmentListResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } catch (e) {
      print('[AppointmentService] Get all appointments failed: $e');
      if (e is Exception) rethrow;
      throw Exception('Lấy danh sách cuộc hẹn thất bại: ${e.toString()}');
    }
  }

  @override
  Future<AppointmentDetailResponse> getAppointmentById(String id) async {
    await _ensureInitialized();

    try {
      final response = await _dioService.get('/api/appointment/$id');

      return AppointmentDetailResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } catch (e) {
      print('[AppointmentService] Get appointment by id failed: $e');
      if (e is Exception) rethrow;
      throw Exception('Lấy chi tiết cuộc hẹn thất bại: ${e.toString()}');
    }
  }

  @override
  Future<CreateAppointmentResponse> createAppointment(
    CreateAppointmentRequest request,
  ) async {
    await _ensureInitialized();

    try {
      final response = await _dioService.post(
        '/api/appointment',
        data: request.toJson(),
      );

      return CreateAppointmentResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } catch (e) {
      print('[AppointmentService] Create appointment failed: $e');
      if (e is Exception) rethrow;
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
        '/api/appointment/$id',
        data: request.toJson(),
      );

      return UpdateAppointmentResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } catch (e) {
      print('[AppointmentService] Update appointment failed: $e');
      if (e is Exception) rethrow;
      throw Exception('Cập nhật cuộc hẹn thất bại: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteAppointment(String id) async {
    await _ensureInitialized();

    try {
      await _dioService.delete('/api/appointment/$id');
    } catch (e) {
      print('[AppointmentService] Delete appointment failed: $e');
      if (e is Exception) rethrow;
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
        '/api/appointment/$id/total-amount',
        data: totalAmount,
      );
    } catch (e) {
      print('[AppointmentService] Update total amount failed: $e');
      if (e is Exception) rethrow;
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
    // This would typically be filtered on the server side
    // For now, we get all and could filter client-side if needed
    return await getAllAppointments(
      pageIndex: pageIndex,
      pageSize: pageSize,
      sortColumn: 'updateat',
      sortDirection: 'desc',
    );
  }

  /// Get appointments by shop ID
  Future<AppointmentListResponse> getAppointmentsByShop({
    required String shopId,
    int pageIndex = 1,
    int pageSize = 10,
  }) async {
    return await getAllAppointments(
      pageIndex: pageIndex,
      pageSize: pageSize,
      sortColumn: 'updateat',
      sortDirection: 'desc',
    );
  }

  /// Get appointments by status
  Future<AppointmentListResponse> getAppointmentsByStatus({
    required AppointmentStatus status,
    int pageIndex = 1,
    int pageSize = 10,
  }) async {
    return await getAllAppointments(
      pageIndex: pageIndex,
      pageSize: pageSize,
      sortColumn: 'updateat',
      sortDirection: 'desc',
    );
  }

  /// Update appointment status
  Future<UpdateAppointmentResponse> updateAppointmentStatus(
    String id,
    AppointmentStatus status,
  ) async {
    await _ensureInitialized();

    try {
      // Get current appointment data
      final currentAppointment = await getAppointmentById(id);

      // Create update request with new status
      final updateRequest = UpdateAppointmentRequest(
        customerId: currentAppointment.customerId,
        shopId: currentAppointment.shopId,
        paymentMethod: currentAppointment.paymentMethod,
        note: currentAppointment.note,
        status: status,
        startTime: currentAppointment.startTime,
        staffName: currentAppointment.staffName,
        bankId: currentAppointment.bankId,
        bankTransactionId: currentAppointment.bankTransactionId,
        isPaid: currentAppointment.isPaid,
      );

      return await updateAppointment(id, updateRequest);
    } catch (e) {
      print('[AppointmentService] Update status failed: $e');
      if (e is Exception) rethrow;
      throw Exception('Cập nhật trạng thái thất bại: ${e.toString()}');
    }
  }

  /// Mark appointment as paid
  Future<UpdateAppointmentResponse> markAppointmentAsPaid(String id) async {
    await _ensureInitialized();

    try {
      final currentAppointment = await getAppointmentById(id);

      final updateRequest = UpdateAppointmentRequest(
        customerId: currentAppointment.customerId,
        shopId: currentAppointment.shopId,
        paymentMethod: currentAppointment.paymentMethod,
        note: currentAppointment.note,
        status: currentAppointment.status,
        startTime: currentAppointment.startTime,
        staffName: currentAppointment.staffName,
        bankId: currentAppointment.bankId,
        bankTransactionId: currentAppointment.bankTransactionId,
        isPaid: true, // ✅ Mark as paid
      );

      return await updateAppointment(id, updateRequest);
    } catch (e) {
      print('[AppointmentService] Mark as paid failed: $e');
      if (e is Exception) rethrow;
      throw Exception('Đánh dấu đã thanh toán thất bại: ${e.toString()}');
    }
  }
}
