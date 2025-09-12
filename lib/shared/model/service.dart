class Service {
  final String serviceId;
  final String shopId;
  final String serviceName;
  final String description;
  final bool status;

  Service({
    required this.serviceId,
    required this.shopId,
    required this.serviceName,
    required this.description,
    required this.status,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      serviceId: json['serviceId'],
      shopId: json['shopId'],
      serviceName: json['serviceName'],
      description: json['description'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serviceId': serviceId,
      'shopId': shopId,
      'serviceName': serviceName,
      'description': description,
      'status': status,
    };
  }
}
