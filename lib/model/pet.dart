class Pet {
  final int? _petId;
  final String? _accountId;
  final String? _petName;
  final DateTime? _dateOfBirth;
  final String? _petImage;
  final String? _petType;
  final String? _size;
  final String? _gender;

  Pet({
    int? petId,
    String? accountId,
    String? petName,
    DateTime? dateOfBirth,
    String? petImage,
    String? petType,
    String? size,
    String? gender,
  }) : _petId = petId,
       _accountId = accountId,
       _petName = petName,
       _dateOfBirth = dateOfBirth,
       _petImage = petImage,
       _petType = petType,
       _size = size,
       _gender = gender;

  int get petId {
    if (_petId == null) throw Exception('petId not set');
    return _petId;
  }

  String get accountId {
    if (_accountId == null) throw Exception('accountId not set');
    return _accountId;
  }

  String get petName {
    if (_petName == null) throw Exception('petName not set');
    return _petName;
  }

  DateTime get dateOfBirth {
    if (_dateOfBirth == null) throw Exception('dateOfBirth not set');
    return _dateOfBirth;
  }

  String get petImage {
    if (_petImage == null) throw Exception('petImage not set');
    return _petImage;
  }

  String get petType {
    if (_petType == null) throw Exception('petType not set');
    return _petType;
  }

  String get size {
    if (_size == null) throw Exception('size not set');
    return _size;
  }

  String get gender {
    if (_gender == null) throw Exception('gender not set');
    return _gender;
  }

  // Nullable getters
  int? get petIdNullable => _petId;
  String? get accountIdNullable => _accountId;
  String? get petNameNullable => _petName;
  DateTime? get dateOfBirthNullable => _dateOfBirth;
  String? get petImageNullable => _petImage;
  String? get petTypeNullable => _petType;
  String? get sizeNullable => _size;
  String? get genderNullable => _gender;
}
