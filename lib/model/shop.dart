class Shop {
  final String shopId;
  final String owner;
  final String shopName;
  final String description;
  final bool status;
  final String workingDays;

  Shop({
    required this.shopId,
    required this.owner,
    required this.shopName,
    required this.description,
    required this.status,
    required this.workingDays,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      shopId: json['shopId'],
      owner: json['owner'],
      shopName: json['shopName'],
      description: json['description'],
      status: json['status'],
      workingDays: json['workingDays'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shopId': shopId,
      'owner': owner,
      'shopName': shopName,
      'description': description,
      'status': status,
      'workingDays': workingDays,
    };
  }
}
