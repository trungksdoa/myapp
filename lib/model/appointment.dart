class Appointment {
  final String appointmentId;
  final String customerId;
  final String shopId;
  final String branchId;
  final double totalAmount;
  final String paymentMethod;
  final String note;
  final String status;
  final DateTime startTime;
  final String staffName;

  Appointment({
    required this.appointmentId,
    required this.customerId,
    required this.shopId,
    required this.branchId,
    required this.totalAmount,
    required this.paymentMethod,
    required this.note,
    required this.status,
    required this.startTime,
    required this.staffName,
  });

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
      startTime: DateTime.parse(json['startTime']),
      staffName: json['staffName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appointmentId': appointmentId,
      'customerId': customerId,
      'shopId': shopId,
      'branchId': branchId,
      'totalAmount': totalAmount,
      'paymentMethod': paymentMethod,
      'note': note,
      'status': status,
      'startTime': startTime.toIso8601String(),
      'staffName': staffName,
    };
  }
}
