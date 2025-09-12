class ProductCategory {
  final String productCategoryId;
  final String name;

  ProductCategory({
    required this.productCategoryId,
    required this.name,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      productCategoryId: json['productCategoryId'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productCategoryId': productCategoryId,
      'name': name,
    };
  }
}
