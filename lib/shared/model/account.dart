class Account {
  final String accountId;
  final String fullName;
  final String email;
  final DateTime? dateOfBirth;
  final String? nationality;
  final String? avatar;
  final String? permanentAddress;
  final String? homeTown;
  final String? imgUrl;

  const Account({
    required this.accountId,
    required this.fullName,
    required this.email,
    this.dateOfBirth,
    this.nationality,
    this.avatar,
    this.permanentAddress,
    this.homeTown,
    this.imgUrl,
  });

  static Account fromJson(data) {
    return Account(
      accountId: data['accountId'] as String,
      fullName: data['fullName'] as String,
      email: data['email'] as String,
      dateOfBirth: data['dateOfBirth'] != null
          ? DateTime.parse(data['dateOfBirth'] as String)
          : DateTime.now(),
      nationality: data['nationality'] as String,
      avatar: data['avatar'] as String,
      permanentAddress: data['permanentAddress'] as String,
      homeTown: data['homeTown'] as String,
      imgUrl: data['imgUrl'] as String,
    );
  }
}
