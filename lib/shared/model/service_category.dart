class ServiceCategory {
  final String serviceCategoryId;
  final String name;

  ServiceCategory({
    required this.serviceCategoryId,
    required this.name,
  });

  factory ServiceCategory.fromJson(Map<String, dynamic> json) {
    return ServiceCategory(
      serviceCategoryId: json['serviceCategoryId'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serviceCategoryId': serviceCategoryId,
      'name': name,
    };
  }
}
