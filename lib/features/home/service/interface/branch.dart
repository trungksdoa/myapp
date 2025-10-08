/// Branch models và interfaces

class Branch {
  final String id;
  final String shopId;
  final String address;
  final String phoneNumber;

  Branch({
    required this.id,
    required this.shopId,
    required this.address,
    required this.phoneNumber,
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['id'] as String,
      shopId: json['shopId'] as String,
      address: json['address'] as String,
      phoneNumber: json['phoneNumber'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shopId': shopId,
      'address': address,
      'phoneNumber': phoneNumber,
    };
  }
}

class BranchListResponse {
  final List<Branch> items;
  final int totalItems;
  final int pageNumber;
  final int pageSize;
  final int totalPages;
  final bool success;
  final String message;

  BranchListResponse({
    required this.items,
    required this.totalItems,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
    required this.success,
    required this.message,
  });

  // Computed properties for compatibility
  List<Branch> get branches => items;
  int get pageIndex => pageNumber;
  bool get hasNextPage => pageNumber < totalPages;
  bool get hasPreviousPage => pageNumber > 1;

  factory BranchListResponse.fromJson(Map<String, dynamic> json) {
    final dataJson = json['data'] as Map<String, dynamic>? ?? {};

    return BranchListResponse(
      items: (dataJson['items'] as List<dynamic>? ?? [])
          .map((item) => Branch.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalItems: dataJson['totalItems'] as int? ?? 0,
      pageNumber: dataJson['pageNumber'] as int? ?? 1,
      pageSize: dataJson['pageSize'] as int? ?? 10,
      totalPages: dataJson['totalPages'] as int? ?? 1,
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': {
        'items': items.map((branch) => branch.toJson()).toList(),
        'totalItems': totalItems,
        'pageNumber': pageNumber,
        'pageSize': pageSize,
        'totalPages': totalPages,
      },
    };
  }
}
