class Account {
  final String? _accountId;
  final String? _fullName;
  final String? _email;
  final String? _password;
  final int? _role;
  final bool? _status;
  final DateTime? _dateOfBirth;
  final String? _gender;
  final String? _nationality;
  final String? _homeTown;
  final String? _permanentAddress;
  final String? _issuedDate;
  final String? _issuedBy;
  final String? _imgUrl;

  Account({
    String? accountId,
    String? fullName,
    String? email,
    String? password,
    int? role,
    bool? status,
    DateTime? dateOfBirth,
    String? gender,
    String? nationality,
    String? homeTown,
    String? permanentAddress,
    String? issuedDate,
    String? issuedBy,
    String? imgUrl,
  }) : _accountId = accountId,
       _fullName = fullName,
       _email = email,
       _password = password,
       _role = role,
       _status = status,
       _dateOfBirth = dateOfBirth,
       _gender = gender,
       _nationality = nationality,
       _homeTown = homeTown,
       _permanentAddress = permanentAddress,
       _issuedDate = issuedDate,
       _issuedBy = issuedBy,
       _imgUrl = imgUrl;

  // Getters with null check and throw
  String get accountId {
    if (_accountId == null) throw Exception('accountId not set');
    return _accountId;
  }

  String get fullName {
    if (_fullName == null) throw Exception('fullName not set');
    return _fullName;
  }

  String get email {
    if (_email == null) throw Exception('email not set');
    return _email;
  }

  String get password {
    if (_password == null) throw Exception('password not set');
    return _password;
  }

  int get role {
    if (_role == null) throw Exception('role not set');
    return _role;
  }

  bool get status {
    if (_status == null) throw Exception('status not set');
    return _status;
  }

  DateTime get dateOfBirth {
    if (_dateOfBirth == null) throw Exception('dateOfBirth not set');
    return _dateOfBirth;
  }

  String get gender {
    if (_gender == null) throw Exception('gender not set');
    return _gender;
  }

  String get nationality {
    if (_nationality == null) throw Exception('nationality not set');
    return _nationality;
  }

  String get homeTown {
    if (_homeTown == null) throw Exception('homeTown not set');
    return _homeTown;
  }

  String get permanentAddress {
    if (_permanentAddress == null) throw Exception('permanentAddress not set');
    return _permanentAddress;
  }

  String get issuedDate {
    if (_issuedDate == null) throw Exception('issuedDate not set');
    return _issuedDate;
  }

  String get issuedBy {
    if (_issuedBy == null) throw Exception('issuedBy not set');
    return _issuedBy;
  }

  String get imgUrl {
    if (_imgUrl == null) throw Exception('imgUrl not set');
    return _imgUrl;
  }

  // Nullable getters for optional access
  String? get accountIdNullable => _accountId;
  String? get fullNameNullable => _fullName;
  String? get emailNullable => _email;
  String? get passwordNullable => _password;
  int? get roleNullable => _role;
  bool? get statusNullable => _status;
  DateTime? get dateOfBirthNullable => _dateOfBirth;
  String? get genderNullable => _gender;
  String? get nationalityNullable => _nationality;
  String? get homeTownNullable => _homeTown;
  String? get permanentAddressNullable => _permanentAddress;
  String? get issuedDateNullable => _issuedDate;
  String? get issuedByNullable => _issuedBy;
  String? get imgUrlNullable => _imgUrl;

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      accountId: json['accountId'],
      fullName: json['fullName'],
      email: json['email'],
      password: json['password'],
      role: json['role'],
      status: json['status'],
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
      gender: json['gender'],
      nationality: json['nationality'],
      homeTown: json['homeTown'],
      permanentAddress: json['permanentAddress'],
      issuedDate: json['issuedDate'],
      issuedBy: json['issuedBy'],
      imgUrl: json['imgUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accountId': accountIdNullable,
      'fullName': fullNameNullable,
      'email': emailNullable,
      'password': passwordNullable,
      'role': roleNullable,
      'status': statusNullable,
      'dateOfBirth': dateOfBirthNullable?.toIso8601String(),
      'gender': genderNullable,
      'nationality': nationalityNullable,
      'homeTown': homeTownNullable,
      'permanentAddress': permanentAddressNullable,
      'issuedDate': issuedDateNullable,
      'issuedBy': issuedByNullable,
      'imgUrl': imgUrlNullable,
    };
  }

  @override
  String toString() {
    final Map<String, dynamic> json = toJson();
    json.removeWhere((key, value) => value == null);
    return 'Account(${json.entries.map((e) => '${e.key}: ${e.value}').join(', ')})';
  }
}
