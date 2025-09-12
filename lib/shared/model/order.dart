class Order {
  final String? _orderId;
  final String? _customerId;
  final String? _shopId;
  final String? _shippingAddressId;
  final double? _totalAmount;
  final String? _paymentMethod;
  final String? _note;
  final String? _status;

  Order({
    String? orderId,
    String? customerId,
    String? shopId,
    String? shippingAddressId,
    double? totalAmount,
    String? paymentMethod,
    String? note,
    String? status,
  }) : _orderId = orderId,
       _customerId = customerId,
       _shopId = shopId,
       _shippingAddressId = shippingAddressId,
       _totalAmount = totalAmount,
       _paymentMethod = paymentMethod,
       _note = note,
       _status = status;

  String get orderId {
    if (_orderId == null) throw Exception('orderId not set');
    return _orderId;
  }

  String get customerId {
    if (_customerId == null) throw Exception('customerId not set');
    return _customerId;
  }

  String get shopId {
    if (_shopId == null) throw Exception('shopId not set');
    return _shopId;
  }

  String get shippingAddressId {
    if (_shippingAddressId == null)
      throw Exception('shippingAddressId not set');
    return _shippingAddressId;
  }

  double get totalAmount {
    if (_totalAmount == null) throw Exception('totalAmount not set');
    return _totalAmount;
  }

  String get paymentMethod {
    if (_paymentMethod == null) throw Exception('paymentMethod not set');
    return _paymentMethod;
  }

  String get note {
    if (_note == null) throw Exception('note not set');
    return _note;
  }

  String get status {
    if (_status == null) throw Exception('status not set');
    return _status;
  }

  // Nullable getters
  String? get orderIdNullable => _orderId;
  String? get customerIdNullable => _customerId;
  String? get shopIdNullable => _shopId;
  String? get shippingAddressIdNullable => _shippingAddressId;
  double? get totalAmountNullable => _totalAmount;
  String? get paymentMethodNullable => _paymentMethod;
  String? get noteNullable => _note;
  String? get statusNullable => _status;

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
      'orderId': orderIdNullable,
      'customerId': customerIdNullable,
      'shopId': shopIdNullable,
      'shippingAddressId': shippingAddressIdNullable,
      'totalAmount': totalAmountNullable,
      'paymentMethod': paymentMethodNullable,
      'note': noteNullable,
      'status': statusNullable,
    };
  }
}
