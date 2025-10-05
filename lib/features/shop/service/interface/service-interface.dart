class Service {
  final String id;
  final String name;
  final String shopId;
  final String description;
  final String imgUrl;
  final bool status;

  Service({
    required this.id,
    required this.name,
    required this.shopId,
    required this.description,
    required this.imgUrl,
    required this.status,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] as String,
      name: json['name'] as String,
      shopId: json['shopId'] as String,
      description: json['description'] as String,
      imgUrl: json['imgUrl'] as String,
      status: json['status'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'shopId': shopId,
      'description': description,
      'imgUrl': imgUrl,
      'status': status,
    };
  }

  // Helper getters
  bool get isActive => status;

  Service copyWith({
    String? id,
    String? name,
    String? shopId,
    String? description,
    String? imgUrl,
    bool? status,
  }) {
    return Service(
      id: id ?? this.id,
      name: name ?? this.name,
      shopId: shopId ?? this.shopId,
      description: description ?? this.description,
      imgUrl: imgUrl ?? this.imgUrl,
      status: status ?? this.status,
    );
  }
}

// Service List Response Model
class ServiceListResponse {
  final List<Service> items;
  final int totalItems;
  final int pageNumber;
  final int pageSize;
  final int totalPages;

  ServiceListResponse({
    required this.items,
    required this.totalItems,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
  });

  // Computed properties
  bool get hasNextPage => pageNumber < totalPages;
  bool get hasPreviousPage => pageNumber > 1;
  int get pageIndex => pageNumber;

  factory ServiceListResponse.fromJson(Map<String, dynamic> json) {
    final dataJson = json['data'] as Map<String, dynamic>? ?? json;

    return ServiceListResponse(
      items:
          (dataJson['items'] as List<dynamic>?)
              ?.map((item) => Service.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      totalItems: dataJson['totalItems'] as int? ?? 0,
      pageNumber: dataJson['pageNumber'] as int? ?? 1,
      pageSize: dataJson['pageSize'] as int? ?? 10,
      totalPages: dataJson['totalPages'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'totalItems': totalItems,
      'pageNumber': pageNumber,
      'pageSize': pageSize,
      'totalPages': totalPages,
    };
  }
}

// Service Response Model (for single service)
class ServiceResponse {
  final Service service;
  final bool success;
  final String? message;

  ServiceResponse({required this.service, this.success = true, this.message});

  factory ServiceResponse.fromJson(Map<String, dynamic> json) {
    final dataJson = json['data'] as Map<String, dynamic>? ?? json;

    return ServiceResponse(
      service: Service.fromJson(dataJson),
      success: json['success'] as bool? ?? true,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'data': service.toJson(), 'success': success, 'message': message};
  }
}
