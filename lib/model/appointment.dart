class Appointment {
  final String? _appointmentId;
  final String? _customerId;
  final String? _shopId;
  final String? _branchId;
  final double? _totalAmount;
  final String? _paymentMethod;
  final String? _note;
  final String? _status;
  final DateTime? _startTime;
  final String? _staffName;

  Appointment({
    String? appointmentId,
    String? customerId,
    String? shopId,
    String? branchId,
    double? totalAmount,
    String? paymentMethod,
    String? note,
    String? status,
    DateTime? startTime,
    String? staffName,
  }) : _appointmentId = appointmentId,
       _customerId = customerId,
       _shopId = shopId,
       _branchId = branchId,
       _totalAmount = totalAmount,
       _paymentMethod = paymentMethod,
       _note = note,
       _status = status,
       _startTime = startTime,
       _staffName = staffName;

  String get appointmentId {
    if (_appointmentId == null) throw Exception('appointmentId not set');
    return _appointmentId;
  }

  String get customerId {
    if (_customerId == null) throw Exception('customerId not set');
    return _customerId;
  }

  String get shopId {
    if (_shopId == null) throw Exception('shopId not set');
    return _shopId;
  }

  String get branchId {
    if (_branchId == null) throw Exception('branchId not set');
    return _branchId;
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

  DateTime get startTime {
    if (_startTime == null) throw Exception('startTime not set');
    return _startTime;
  }

  String get staffName {
    if (_staffName == null) throw Exception('staffName not set');
    return _staffName;
  }

  // Nullable getters
  String? get appointmentIdNullable => _appointmentId;
  String? get customerIdNullable => _customerId;
  String? get shopIdNullable => _shopId;
  String? get branchIdNullable => _branchId;
  double? get totalAmountNullable => _totalAmount;
  String? get paymentMethodNullable => _paymentMethod;
  String? get noteNullable => _note;
  String? get statusNullable => _status;
  DateTime? get startTimeNullable => _startTime;
  String? get staffNameNullable => _staffName;

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      appointmentId: json['appointmentId'],
      customerId: json['customerId'],
      shopId: json['shopId'],
      branchId: json['branchId'],
      totalAmount: json['totalAmount'],
      paymentMethod: json['paymentMethod'],
      note: json['note'],
      status: json['status'],
      startTime: json['startTime'] != null
          ? DateTime.parse(json['startTime'])
          : null,
      staffName: json['staffName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appointmentId': appointmentIdNullable,
      'customerId': customerIdNullable,
      'shopId': shopIdNullable,
      'branchId': branchIdNullable,
      'totalAmount': totalAmountNullable,
      'paymentMethod': paymentMethodNullable,
      'note': noteNullable,
      'status': statusNullable,
      'startTime': startTimeNullable?.toIso8601String(),
      'staffName': staffNameNullable,
    };
  }
}
