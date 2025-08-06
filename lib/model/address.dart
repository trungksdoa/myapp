class Address {
  final String addressId;
  final String accountId;
  final String address;
  final String phoneNumber;
  final String receiverName;
  final bool isDefault;

  Address({
    required this.addressId,
    required this.accountId,
    required this.address,
    required this.phoneNumber,
    required this.receiverName,
    required this.isDefault,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      addressId: json['addressId'],
      accountId: json['accountId'],
      address: json['address'],
      phoneNumber: json['phoneNumber'],
      receiverName: json['receiverName'],
      isDefault: json['isDefault'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'addressId': addressId,
      'accountId': accountId,
      'address': address,
      'phoneNumber': phoneNumber,
      'receiverName': receiverName,
      'isDefault': isDefault,
    };
  }
}
