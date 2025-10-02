// Response models to parse API responses consistently

/// Base response wrapper used by backend
class BaseResponse<T> {
  final String status;
  final int code;
  final String? message;
  final T? data;

  const BaseResponse({
    required this.status,
    required this.code,
    this.message,
    this.data,
  });

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json)? fromJsonT,
  ) {
    return BaseResponse<T>(
      status: json['status'] as String? ?? 'unknown',
      code: json['code'] as int? ?? 500,
      message: json['message'] as String?,
      data: _convertData(json['data'], fromJsonT),
    );
  }

  static T? _convertData<T>(Object? data, T Function(Object? json)? fromJson) {
    if (data == null) return null;
    if (fromJson == null) return data as T;
    return fromJson(data);
  }

  bool get isSuccess => code == 200 || status.toLowerCase() == 'success';

  @override
  String toString() =>
      'BaseResponse{status: $status, code: $code, message: $message, data: $data}';
}

/// Login response data
class LoginData {
  final String accessToken;
  final String refreshToken;
  final String? userId;
  final String? username;
  final String? email;

  const LoginData({
    required this.accessToken,
    required this.refreshToken,
    this.userId,
    this.username,
    this.email,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      userId: json['userId'] as String?,
      username: json['username'] as String?,
      email: json['email'] as String?,
    );
  }
}

/// Register response data
class RegisterData {
  final String accessToken;
  final String refreshToken;
  final String? userId;
  final String? username;
  final String? email;

  const RegisterData({
    required this.accessToken,
    required this.refreshToken,
    this.userId,
    this.username,
    this.email,
  });

  factory RegisterData.fromJson(Map<String, dynamic> json) {
    return RegisterData(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      userId: json['userId'] as String?,
      username: json['username'] as String?,
      email: json['email'] as String?,
    );
  }
}

/// Token response used by refresh token endpoint
class TokenData {
  final String accessToken;
  final String refreshToken;

  const TokenData({required this.accessToken, required this.refreshToken});

  factory TokenData.fromJson(Map<String, dynamic> json) {
    return TokenData(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }
}
