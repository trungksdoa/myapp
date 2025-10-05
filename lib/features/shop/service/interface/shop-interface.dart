class Shop {
  final String id;
  final String ownerId;
  final String name;
  final String description;
  final int status;
  final String imgUrl;
  final String workingDays;

  Shop({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.description,
    required this.status,
    required this.imgUrl,
    required this.workingDays,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      id: json['id'] as String,
      ownerId: json['ownerId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      status: json['status'] as int,
      imgUrl: json['imgUrl'] as String,
      workingDays: json['workingDays'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerId': ownerId,
      'name': name,
      'description': description,
      'status': status,
      'imgUrl': imgUrl,
      'workingDays': workingDays,
    };
  }

  // Helper getters
  String get shopName => name;
  String get owner => ownerId;
  bool get isActive => status == 1;

  Shop copyWith({
    String? id,
    String? ownerId,
    String? name,
    String? description,
    int? status,
    String? imgUrl,
    String? workingDays,
  }) {
    return Shop(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
      imgUrl: imgUrl ?? this.imgUrl,
      workingDays: workingDays ?? this.workingDays,
    );
  }
}

// Shop List Response Model
class ShopListResponse {
  final List<Shop> items;
  final int totalItems;
  final int pageNumber;
  final int pageSize;
  final int totalPages;

  ShopListResponse({
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

  factory ShopListResponse.fromJson(Map<String, dynamic> json) {
    final dataJson = json['data'] as Map<String, dynamic>? ?? json;

    return ShopListResponse(
      items:
          (dataJson['items'] as List<dynamic>?)
              ?.map((item) => Shop.fromJson(item as Map<String, dynamic>))
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

// Shop Response Model (for single shop)
class ShopResponse {
  final Shop shop;
  final bool success;
  final String? message;

  ShopResponse({required this.shop, this.success = true, this.message});

  factory ShopResponse.fromJson(Map<String, dynamic> json) {
    final dataJson = json['data'] as Map<String, dynamic>? ?? json;

    return ShopResponse(
      shop: Shop.fromJson(dataJson),
      success: json['success'] as bool? ?? true,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'data': shop.toJson(), 'success': success, 'message': message};
  }
}

// Create Shop Request Model
class CreateShopRequest {
  final String ownerId;
  final String name;
  final String description;
  final int status;
  final String imgUrl;
  final String workingDays;

  CreateShopRequest({
    required this.ownerId,
    required this.name,
    required this.description,
    this.status = 1,
    required this.imgUrl,
    required this.workingDays,
  });

  Map<String, dynamic> toJson() {
    return {
      'ownerId': ownerId,
      'name': name,
      'description': description,
      'status': status,
      'imgUrl': imgUrl,
      'workingDays': workingDays,
    };
  }

  factory CreateShopRequest.fromJson(Map<String, dynamic> json) {
    return CreateShopRequest(
      ownerId: json['ownerId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      status: json['status'] as int? ?? 1,
      imgUrl: json['imgUrl'] as String,
      workingDays: json['workingDays'] as String,
    );
  }
}

// Update Shop Request Model
class UpdateShopRequest {
  final String? ownerId;
  final String? name;
  final String? description;
  final int? status;
  final String? imgUrl;
  final String? workingDays;

  UpdateShopRequest({
    this.ownerId,
    this.name,
    this.description,
    this.status,
    this.imgUrl,
    this.workingDays,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};

    if (ownerId != null) json['ownerId'] = ownerId;
    if (name != null) json['name'] = name;
    if (description != null) json['description'] = description;
    if (status != null) json['status'] = status;
    if (imgUrl != null) json['imgUrl'] = imgUrl;
    if (workingDays != null) json['workingDays'] = workingDays;

    return json;
  }

  factory UpdateShopRequest.fromJson(Map<String, dynamic> json) {
    return UpdateShopRequest(
      ownerId: json['ownerId'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      status: json['status'] as int?,
      imgUrl: json['imgUrl'] as String?,
      workingDays: json['workingDays'] as String?,
    );
  }
}

// Create Shop Response Model
class CreateShopResponse {
  final String id;
  final bool success;
  final String? message;

  CreateShopResponse({required this.id, this.success = true, this.message});

  factory CreateShopResponse.fromJson(Map<String, dynamic> json) {
    return CreateShopResponse(
      id: json['id'] as String? ?? json['data']?['id'] as String? ?? '',
      success: json['success'] as bool? ?? true,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'success': success, 'message': message};
  }
}
