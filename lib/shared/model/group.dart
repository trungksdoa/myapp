class Group {
  final int? _id;
  final String? _name;
  final int? _memberCount;
  final String? _imgUrl;
  final String? _createdById;

  Group({
    int? id,
    String? name,
    int? memberCount,
    String? imgUrl,
    String? createdById,
  }) : _id = id,
       _name = name,
       _memberCount = memberCount,
       _imgUrl = imgUrl,
       _createdById = createdById;

  int get id {
    if (_id == null) throw Exception('id not set');
    return _id;
  }

  String get name {
    if (_name == null) throw Exception('name not set');
    return _name;
  }

  int get memberCount {
    if (_memberCount == null) throw Exception('memberCount not set');
    return _memberCount;
  }

  String get imgUrl {
    if (_imgUrl == null) throw Exception('imgUrl not set');
    return _imgUrl;
  }

  String get createdById {
    if (_createdById == null) throw Exception('createdById not set');
    return _createdById;
  }

  // Nullable getters
  int? get idNullable => _id;
  String? get nameNullable => _name;
  int? get memberCountNullable => _memberCount;
  String? get imgUrlNullable => _imgUrl;
  String? get createdByIdNullable => _createdById;
}
