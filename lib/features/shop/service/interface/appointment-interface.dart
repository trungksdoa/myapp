// lib/features/appointment/models/appointment_models.dart

enum AppointmentStatus {
  pending(0),
  confirmed(1),
  checkin(2),
  processing(3),
  finished(4),
  cancel(5);

  const AppointmentStatus(this.value);
  final int value;

  static AppointmentStatus fromValue(int value) {
    return AppointmentStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => AppointmentStatus.pending,
    );
  }
}

// ✅ UPDATED: AppointmentListResponse theo API structure
class AppointmentListResponse {
  final List<AppointmentSummary> items;
  final int totalItems; // ✅
  final int pageNumber; // ✅
  final int pageSize;
  final int totalPages;

  AppointmentListResponse({
    required this.items,
    required this.totalItems,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
  });

  // ✅ COMPUTED PROPERTIES for compatibility
  List<AppointmentSummary> get appointments => items;
  int get pageIndex => pageNumber;
  bool get hasNextPage => pageNumber < totalPages;
  bool get hasPreviousPage => pageNumber > 1;

  factory AppointmentListResponse.fromJson(Map<String, dynamic> json) {
    final dataJson = json['data'] as Map<String, dynamic>? ?? json;

    return AppointmentListResponse(
      items: (dataJson['items'] as List<dynamic>? ?? [])
          .map(
            (item) => AppointmentSummary.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      totalItems: dataJson['totalItems'] as int? ?? 0,
      pageNumber: dataJson['pageNumber'] as int? ?? 1,
      pageSize: dataJson['pageSize'] as int? ?? 10,
      totalPages: dataJson['totalPages'] as int? ?? 1,
    );
  }
}

// ✅ UPDATED: AppointmentSummary theo API structure
class AppointmentSummary {
  final String id;
  final String? customerId;
  final String? shopId;
  final String? shopName;
  final double totalAmount;
  final String? paymentMethod;
  final String? note;
  final AppointmentStatus status;
  final DateTime startTime;
  final String? staffName;
  final String? bankId;
  final String? bankTransactionId;
  final bool isPaid;
  final List<AppointmentDetail> details;

  AppointmentSummary({
    required this.id,
    this.customerId,
    this.shopId,
    this.shopName,
    this.totalAmount = 0.0,
    this.paymentMethod,
    this.note,
    required this.status,
    required this.startTime,
    this.staffName,
    this.bankId,
    this.bankTransactionId,
    this.isPaid = false,
    this.details = const [],
  });

  factory AppointmentSummary.fromJson(Map<String, dynamic> json) {
    return AppointmentSummary(
      id: json['id'] as String,
      customerId: json['customerId'] as String?,
      shopId: json['shopId'] as String?,
      shopName: json['shopName'] as String?,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      paymentMethod: json['paymentMethod'] as String?,
      note: json['note'] as String?,
      status: AppointmentStatus.fromValue(json['status'] as int? ?? 0),
      startTime: DateTime.parse(json['startTime'] as String),
      staffName: json['staffName'] as String?,
      bankId: json['bankId'] as String?,
      bankTransactionId: json['bankTransactionId'] as String?,
      isPaid: json['isPaid'] as bool? ?? false,
      details: (json['details'] as List<dynamic>? ?? [])
          .map(
            (item) => AppointmentDetail.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}

// ✅ UPDATED: AppointmentDetail theo API structure thực tế
class AppointmentDetail {
  final String id;
  final String? appointmentId;
  final String? serviceDetailId;
  final String? serviceDetailName;
  final double totalAmount;
  final String? note;
  final int petQuantity;

  AppointmentDetail({
    required this.id,
    this.appointmentId,
    this.serviceDetailId,
    this.serviceDetailName,
    this.totalAmount = 0.0,
    this.note,
    this.petQuantity = 1,
  });

  factory AppointmentDetail.fromJson(Map<String, dynamic> json) {
    return AppointmentDetail(
      id: json['id'] as String,
      appointmentId: json['appointmentId'] as String?,
      serviceDetailId: json['serviceDetailId'] as String?,
      serviceDetailName: json['serviceDetailName'] as String?,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      note: json['note'] as String?,
      petQuantity: json['petQuantity'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'appointmentId': appointmentId,
      'serviceDetailId': serviceDetailId,
      'serviceDetailName': serviceDetailName,
      'totalAmount': totalAmount,
      'note': note,
      'petQuantity': petQuantity,
    };
  }
}

// ✅ KEEP ORIGINAL: Create/Update models vẫn giữ nguyên
class CreateAppointmentRequest {
  final String? customerId;
  final String? shopId;
  final String? paymentMethod;
  final String? note;
  final AppointmentStatus status;
  final DateTime startTime;
  final String? staffName;
  final String? bankId;
  final String? bankTransactionId;
  final bool isPaid;
  final List<AppointmentDetailInput>? details;

  CreateAppointmentRequest({
    this.customerId,
    this.shopId,
    this.paymentMethod,
    this.note,
    required this.status,
    required this.startTime,
    this.staffName,
    this.bankId,
    this.bankTransactionId,
    this.isPaid = false,
    this.details,
  });

  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId,
      'shopId': shopId,
      'paymentMethod': paymentMethod,
      'note': note,
      'status': status.value,
      'startTime': startTime.toIso8601String(),
      'staffName': staffName,
      'bankId': bankId,
      'bankTransactionId': bankTransactionId,
      'isPaid': isPaid,
      'details': details?.map((detail) => detail.toJson()).toList(),
    };
  }
}

class UpdateAppointmentRequest {
  final String? customerId;
  final String? shopId;
  final String? paymentMethod;
  final String? note;
  final AppointmentStatus status;
  final DateTime startTime;
  final String? staffName;
  final String? bankId;
  final String? bankTransactionId;
  final bool isPaid;

  UpdateAppointmentRequest({
    this.customerId,
    this.shopId,
    this.paymentMethod,
    this.note,
    required this.status,
    required this.startTime,
    this.staffName,
    this.bankId,
    this.bankTransactionId,
    this.isPaid = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId,
      'shopId': shopId,
      'paymentMethod': paymentMethod,
      'note': note,
      'status': status.value,
      'startTime': startTime.toIso8601String(),
      'staffName': staffName,
      'bankId': bankId,
      'bankTransactionId': bankTransactionId,
      'isPaid': isPaid,
    };
  }
}

class AppointmentDetailInput {
  final String? serviceDetailId;
  final String? note;
  final int petQuantity;

  AppointmentDetailInput({
    this.serviceDetailId,
    this.note,
    required this.petQuantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'serviceDetailId': serviceDetailId,
      'note': note,
      'petQuantity': petQuantity,
    };
  }

  factory AppointmentDetailInput.fromJson(Map<String, dynamic> json) {
    return AppointmentDetailInput(
      serviceDetailId: json['serviceDetailId'] as String?,
      note: json['note'] as String?,
      petQuantity: json['petQuantity'] as int? ?? 1,
    );
  }
}

// ✅ KEEP ORIGINAL: Response models
class CreateAppointmentResponse {
  final String id;
  final String message;
  final bool success;

  CreateAppointmentResponse({
    required this.id,
    required this.message,
    this.success = true,
  });

  factory CreateAppointmentResponse.fromJson(Map<String, dynamic> json) {
    return CreateAppointmentResponse(
      id: json['id'] as String? ?? '',
      message: json['message'] as String? ?? 'Tạo cuộc hẹn thành công',
      success: json['success'] as bool? ?? true,
    );
  }
}

class UpdateAppointmentResponse {
  final String message;
  final bool success;

  UpdateAppointmentResponse({required this.message, this.success = true});

  factory UpdateAppointmentResponse.fromJson(Map<String, dynamic> json) {
    return UpdateAppointmentResponse(
      message: json['message'] as String? ?? 'Cập nhật cuộc hẹn thành công',
      success: json['success'] as bool? ?? true,
    );
  }
}
