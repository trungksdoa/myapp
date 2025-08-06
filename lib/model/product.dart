class Product {
  final String productId;
  final String shopId;
  final String productName;
  final String description;
  final bool status;

  Product({
    required this.productId,
    required this.shopId,
    required this.productName,
    required this.description,
    required this.status,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['productId'],
      shopId: json['shopId'],
      productName: json['productName'],
      description: json['description'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'shopId': shopId,
      'productName': productName,
      'description': description,
      'status': status,
    };
  }
}
