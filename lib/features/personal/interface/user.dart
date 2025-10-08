class User {
  final String fullName;
  final String email;
  final String gender;
  final String? dateOfBirth;
  final String? nationality;
  final String? permanentAddress;
  final String? homeTown;
  final String? imgUrl;

  User({
    required this.fullName,
    required this.email,
    required this.gender,
    this.dateOfBirth,
    this.nationality,
    this.permanentAddress,
    required this.homeTown,
    this.imgUrl,
  });

  // Factory constructor từ JSON (giả sử API trả về Map<String, dynamic>)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      gender: json['gender'] as String,
      dateOfBirth: json['dateOfBirth'] as String?,
      nationality: json['nationality'] as String?,
      permanentAddress: json['permanentAddress'] as String?,
      homeTown: json['homeTown'] as String?,
      imgUrl: json['imgUrl'] as String?,
    );
  }

  // Method chuyển thành JSON
  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'nationality': nationality,
      'permanentAddress': permanentAddress,
      'homeTown': homeTown,
      'imgUrl': imgUrl,
    };
  }

  // Override toString cho debug
  @override
  String toString() {
    return 'User(fullName: $fullName, email: $email, gender: $gender, dateOfBirth: $dateOfBirth, nationality: $nationality, permanentAddress: $permanentAddress, homeTown: $homeTown, imgUrl: $imgUrl)';
  }
}
