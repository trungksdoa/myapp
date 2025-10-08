class ServiceCategory {
  final String id;
  final String name;
  final String shopId;
  final String shopName;

  ServiceCategory({
    required this.id,
    required this.name,
    required this.shopId,
    required this.shopName,
  });

  factory ServiceCategory.fromJson(Map<String, dynamic> json) {
    return ServiceCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      shopId: json['shopId'] as String,
      shopName: json['shopName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'shopId': shopId, 'shopName': shopName};
  }

  ServiceCategory copyWith({
    String? id,
    String? name,
    String? shopId,
    String? shopName,
  }) {
    return ServiceCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      shopId: shopId ?? this.shopId,
      shopName: shopName ?? this.shopName,
    );
  }
}

// Service Category List Response Model
class ServiceCategoryListResponse {
  final List<ServiceCategory> items;
  final int totalItems;
  final int pageNumber;
  final int pageSize;
  final int totalPages;

  ServiceCategoryListResponse({
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

  factory ServiceCategoryListResponse.fromJson(Map<String, dynamic> json) {
    final dataJson = json['data'] as Map<String, dynamic>? ?? json;

    return ServiceCategoryListResponse(
      items:
          (dataJson['items'] as List<dynamic>?)
              ?.map(
                (item) =>
                    ServiceCategory.fromJson(item as Map<String, dynamic>),
              )
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

// Service Category Response Model (for single service category)
class ServiceCategoryResponse {
  final ServiceCategory serviceCategory;
  final bool success;
  final String? message;

  ServiceCategoryResponse({
    required this.serviceCategory,
    this.success = true,
    this.message,
  });

  factory ServiceCategoryResponse.fromJson(Map<String, dynamic> json) {
    final dataJson = json['data'] as Map<String, dynamic>? ?? json;

    return ServiceCategoryResponse(
      serviceCategory: ServiceCategory.fromJson(dataJson),
      success: json['success'] as bool? ?? true,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': serviceCategory.toJson(),
      'success': success,
      'message': message,
    };
  }
}
