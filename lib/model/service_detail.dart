class ServiceDetail {
  final String id;
  final String serviceId;
  final String name;
  final int price;
  final double discount;
  final int durationTime;
  final bool isDefault;

  ServiceDetail({
    required this.id,
    required this.serviceId,
    required this.name,
    required this.price,
    required this.discount,
    required this.durationTime,
    required this.isDefault,
  });

  factory ServiceDetail.fromJson(Map<String, dynamic> json) {
    return ServiceDetail(
      id: json['id'],
      serviceId: json['serviceId'],
      name: json['name'],
      price: json['price'],
      discount: json['discount'],
      durationTime: json['durationTime'],
      isDefault: json['isDefault'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serviceId': serviceId,
      'name': name,
      'price': price,
      'discount': discount,
      'durationTime': durationTime,
      'isDefault': isDefault,
    };
  }
}
