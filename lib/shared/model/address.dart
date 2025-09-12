class Address {
  final String? _addressId;
  final String? _accountId;
  final String? _address;
  final String? _phoneNumber;
  final String? _receiverName;
  final bool? _isDefault;

  Address({
    String? addressId,
    String? accountId,
    String? address,
    String? phoneNumber,
    String? receiverName,
    bool? isDefault,
  }) : _addressId = addressId,
       _accountId = accountId,
       _address = address,
       _phoneNumber = phoneNumber,
       _receiverName = receiverName,
       _isDefault = isDefault;

  String get addressId {
    if (_addressId == null) throw Exception('addressId not set');
    return _addressId;
  }

  String get accountId {
    if (_accountId == null) throw Exception('accountId not set');
    return _accountId;
  }

  String get address {
    if (_address == null) throw Exception('address not set');
    return _address;
  }

  String get phoneNumber {
    if (_phoneNumber == null) throw Exception('phoneNumber not set');
    return _phoneNumber;
  }

  String get receiverName {
    if (_receiverName == null) throw Exception('receiverName not set');
    return _receiverName;
  }

  bool get isDefault {
    if (_isDefault == null) throw Exception('isDefault not set');
    return _isDefault;
  }

  // Nullable getters
  String? get addressIdNullable => _addressId;
  String? get accountIdNullable => _accountId;
  String? get addressNullable => _address;
  String? get phoneNumberNullable => _phoneNumber;
  String? get receiverNameNullable => _receiverName;
  bool? get isDefaultNullable => _isDefault;

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
      'addressId': addressIdNullable,
      'accountId': accountIdNullable,
      'address': addressNullable,
      'phoneNumber': phoneNumberNullable,
      'receiverName': receiverNameNullable,
      'isDefault': isDefaultNullable,
    };
  }
}
