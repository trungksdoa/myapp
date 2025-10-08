// lib/features/service_detail/models/service_detail_models.dart

class ServiceDetail {
  final String id;
  final String? serviceCategoryId;
  final String? name;
  final int price;
  final int durationTime; // in minutes
  final bool status;
  final double discount;
  final bool isDefault;
  final String? imgUrls;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ServiceDetail({
    required this.id,
    this.serviceCategoryId,
    this.name,
    required this.price,
    required this.durationTime,
    required this.status,
    required this.discount,
    required this.isDefault,
    this.imgUrls,
    this.createdAt,
    this.updatedAt,
  });

  factory ServiceDetail.fromJson(Map<String, dynamic> json) {
    return ServiceDetail(
      id: json['id'] as String,
      serviceCategoryId: json['serviceCategoryId'] as String?,
      name: json['name'] as String?,
      price: json['price'] as int? ?? 0,
      durationTime: json['durationTime'] as int? ?? 0,
      status: json['status'] as bool? ?? true,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      isDefault: json['isDefault'] as bool? ?? false,
      imgUrls: json['imgUrls'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serviceCategoryId': serviceCategoryId,
      'name': name,
      'price': price,
      'durationTime': durationTime,
      'status': status,
      'discount': discount,
      'isDefault': isDefault,
      'imgUrls': imgUrls,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Helper methods
  String get formattedPrice => price.toString().replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (Match m) => '${m[1]},',
  );

  String get formattedDuration {
    final hours = durationTime ~/ 60;
    final minutes = durationTime % 60;

    if (hours > 0 && minutes > 0) {
      return '${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h';
    } else {
      return '${minutes}m';
    }
  }

  double get finalPrice => price * (1 - (discount / 100));

  ServiceDetail copyWith({
    String? id,
    String? serviceCategoryId,
    String? name,
    int? price,
    int? durationTime,
    bool? status,
    double? discount,
    bool? isDefault,
    String? imgUrls,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ServiceDetail(
      id: id ?? this.id,
      serviceCategoryId: serviceCategoryId ?? this.serviceCategoryId,
      name: name ?? this.name,
      price: price ?? this.price,
      durationTime: durationTime ?? this.durationTime,
      status: status ?? this.status,
      discount: discount ?? this.discount,
      isDefault: isDefault ?? this.isDefault,
      imgUrls: imgUrls ?? this.imgUrls,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

// ✅ Create Service Detail Request Model
class CreateServiceDetailRequest {
  final String? serviceCategoryId;
  final String? name;
  final int price;
  final int durationTime;
  final bool status;
  final double discount;
  final bool isDefault;
  final String? imgUrls;

  CreateServiceDetailRequest({
    this.serviceCategoryId,
    this.name,
    required this.price,
    required this.durationTime,
    this.status = true,
    this.discount = 0.0,
    this.isDefault = false,
    this.imgUrls,
  });

  Map<String, dynamic> toJson() {
    return {
      'serviceCategoryId': serviceCategoryId,
      'name': name,
      'price': price,
      'durationTime': durationTime,
      'status': status,
      'discount': discount,
      'isDefault': isDefault,
      'imgUrls': imgUrls,
    };
  }

  factory CreateServiceDetailRequest.fromJson(Map<String, dynamic> json) {
    return CreateServiceDetailRequest(
      serviceCategoryId: json['serviceCategoryId'] as String?,
      name: json['name'] as String?,
      price: json['price'] as int? ?? 0,
      durationTime: json['durationTime'] as int? ?? 0,
      status: json['status'] as bool? ?? true,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      isDefault: json['isDefault'] as bool? ?? false,
      imgUrls: json['imgUrls'] as String?,
    );
  }
}

// ✅ Update Service Detail Request Model
class UpdateServiceDetailRequest {
  final String? serviceCategoryId;
  final String? name;
  final int? price;
  final int? durationTime;
  final bool? status;
  final double? discount;
  final bool? isDefault;
  final String? imgUrls;

  UpdateServiceDetailRequest({
    this.serviceCategoryId,
    this.name,
    this.price,
    this.durationTime,
    this.status,
    this.discount,
    this.isDefault,
    this.imgUrls,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};

    if (serviceCategoryId != null)
      json['serviceCategoryId'] = serviceCategoryId;
    if (name != null) json['name'] = name;
    if (price != null) json['price'] = price;
    if (durationTime != null) json['durationTime'] = durationTime;
    if (status != null) json['status'] = status;
    if (discount != null) json['discount'] = discount;
    if (isDefault != null) json['isDefault'] = isDefault;
    if (imgUrls != null) json['imgUrls'] = imgUrls;

    return json;
  }

  factory UpdateServiceDetailRequest.fromJson(Map<String, dynamic> json) {
    return UpdateServiceDetailRequest(
      serviceCategoryId: json['serviceCategoryId'] as String?,
      name: json['name'] as String?,
      price: json['price'] as int?,
      durationTime: json['durationTime'] as int?,
      status: json['status'] as bool?,
      discount: (json['discount'] as num?)?.toDouble(),
      isDefault: json['isDefault'] as bool?,
      imgUrls: json['imgUrls'] as String?,
    );
  }
}

// ✅ Service Detail List Response Model
class ServiceDetailListResponse {
  List<ServiceDetail> items;
  final int totalItems;
  final int pageIndex;
  final int pageSize;
  final int totalPages;

  ServiceDetailListResponse({
    required this.items,
    required this.totalItems,
    required this.pageIndex,
    required this.pageSize,
    required this.totalPages,
  });

  // Computed properties
  bool get hasNextPage => pageIndex < totalPages;
  bool get hasPreviousPage => pageIndex > 1;

  factory ServiceDetailListResponse.fromJson(Map<String, dynamic> json) {
    final dataJson = json['data'] as Map<String, dynamic>? ?? json;

    return ServiceDetailListResponse(
      items:
          (dataJson['items'] as List<dynamic>?)
              ?.map(
                (item) => ServiceDetail.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
      totalItems: dataJson['totalItems'] as int? ?? 0,
      pageIndex:
          dataJson['pageNumber'] as int? ?? dataJson['pageIndex'] as int? ?? 1,
      pageSize: dataJson['pageSize'] as int? ?? 10,
      totalPages: dataJson['totalPages'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'totalItems': totalItems,
      'pageIndex': pageIndex,
      'pageSize': pageSize,
      'totalPages': totalPages,
    };
  }
}

// ✅ Service Detail Response Model (for single service)
class ServiceDetailResponse {
  final ServiceDetail serviceDetail;
  final bool success;
  final String? message;

  ServiceDetailResponse({
    required this.serviceDetail,
    this.success = true,
    this.message,
  });

  factory ServiceDetailResponse.fromJson(Map<String, dynamic> json) {
    final dataJson = json['data'] as Map<String, dynamic>? ?? json;

    return ServiceDetailResponse(
      serviceDetail: ServiceDetail.fromJson(dataJson),
      success: json['success'] as bool? ?? true,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': serviceDetail.toJson(),
      'success': success,
      'message': message,
    };
  }
}

// ✅ Create Service Detail Response Model
class CreateServiceDetailResponse {
  final String id;
  final bool success;
  final String? message;

  CreateServiceDetailResponse({
    required this.id,
    this.success = true,
    this.message,
  });

  factory CreateServiceDetailResponse.fromJson(Map<String, dynamic> json) {
    return CreateServiceDetailResponse(
      id: json['id'] as String? ?? json['data']?['id'] as String? ?? '',
      success: json['success'] as bool? ?? true,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'success': success, 'message': message};
  }
}
// ✅ Update Service Detail Response Model