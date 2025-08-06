class OrderDetail {
  final String detailId;
  final String productDetailId;
  final int quantity;
  final double totalAmount;

  OrderDetail({
    required this.detailId,
    required this.productDetailId,
    required this.quantity,
    required this.totalAmount,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      detailId: json['detailId'],
      productDetailId: json['productDetailId'],
      quantity: json['quantity'],
      totalAmount: json['totalAmount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'detailId': detailId,
      'productDetailId': productDetailId,
      'quantity': quantity,
      'totalAmount': totalAmount,
    };
  }
}
