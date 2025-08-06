class Order {
  final String orderId;
  final String customerId;
  final String shopId;
  final String shippingAddressId;
  final double totalAmount;
  final String paymentMethod;
  final String note;
  final String status;

  Order({
    required this.orderId,
    required this.customerId,
    required this.shopId,
    required this.shippingAddressId,
    required this.totalAmount,
    required this.paymentMethod,
    required this.note,
    required this.status,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['orderId'],
      customerId: json['customerId'],
      shopId: json['shopId'],
      shippingAddressId: json['shippingAddressId'],
      totalAmount: json['totalAmount'],
      paymentMethod: json['paymentMethod'],
      note: json['note'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'customerId': customerId,
      'shopId': shopId,
      'shippingAddressId': shippingAddressId,
      'totalAmount': totalAmount,
      'paymentMethod': paymentMethod,
      'note': note,
      'status': status,
    };
  }
}
