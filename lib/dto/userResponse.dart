class UserResponse {
  final String username;
  final String userEmail;
  final String userToken;

  UserResponse(this.username, this.userEmail, this.userToken);

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      json['username'] as String,
      json['userEmail'] as String,
      json['userToken'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'username': username,
    'userEmail': userEmail
  };
}