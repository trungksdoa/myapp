class GroupMember {
  final int? _id;
  final String? _accountId;
  final int? _groupId;

  GroupMember({int? id, String? accountId, int? groupId})
    : _id = id,
      _accountId = accountId,
      _groupId = groupId;

  int get id {
    if (_id == null) throw Exception('id not set');
    return _id;
  }

  String get accountId {
    if (_accountId == null) throw Exception('accountId not set');
    return _accountId;
  }

  int get groupId {
    if (_groupId == null) throw Exception('groupId not set');
    return _groupId;
  }

  // Nullable getters
  int? get idNullable => _id;
  String? get accountIdNullable => _accountId;
  int? get groupIdNullable => _groupId;
}
