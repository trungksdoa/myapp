class ProductDetail {
  final String id;
  final String productId;
  final double price;
  final bool discount;
  final bool isDefault;
  final int quantityInStock;

  ProductDetail({
    required this.id,
    required this.productId,
    required this.price,
    required this.discount,
    required this.isDefault,
    required this.quantityInStock,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    return ProductDetail(
      id: json['id'],
      productId: json['productId'],
      price: json['price'],
      discount: json['discount'],
      isDefault: json['isDefault'],
      quantityInStock: json['quantityInStock'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'price': price,
      'discount': discount,
      'isDefault': isDefault,
      'quantityInStock': quantityInStock,
    };
  }
}
