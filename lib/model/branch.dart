class Branch {
  final String branchId;
  final String shopId;
  final String address;
  final String phoneNumber;
  final String mail;

  Branch({
    required this.branchId,
    required this.shopId,
    required this.address,
    required this.phoneNumber,
    required this.mail,
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      branchId: json['branchId'],
      shopId: json['shopId'],
      address: json['address'],
      phoneNumber: json['phoneNumber'],
      mail: json['mail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'branchId': branchId,
      'shopId': shopId,
      'address': address,
      'phoneNumber': phoneNumber,
      'mail': mail,
    };
  }
}
