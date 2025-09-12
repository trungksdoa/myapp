class AppointmentService {
  final String id;
  final String serviceDetailId;
  final String appointmentId;
  final double totalAmount;
  final int petQuantity;

  AppointmentService({
    required this.id,
    required this.serviceDetailId,
    required this.appointmentId,
    required this.totalAmount,
    required this.petQuantity,
  });

  factory AppointmentService.fromJson(Map<String, dynamic> json) {
    return AppointmentService(
      id: json['id'],
      serviceDetailId: json['serviceDetailId'],
      appointmentId: json['appointmentId'],
      totalAmount: json['totalAmount'],
      petQuantity: json['petQuantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serviceDetailId': serviceDetailId,
      'appointmentId': appointmentId,
      'totalAmount': totalAmount,
      'petQuantity': petQuantity,
    };
  }
}
