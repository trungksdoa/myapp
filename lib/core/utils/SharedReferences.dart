import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myapp/dto/userResponse.dart';

final _storage = FlutterSecureStorage();

// Lưu dữ liệu an toàn
Future<void> saveSecureToken(String token) async {
  await _storage.write(key: 'auth_token', value: token);
}

// Đọc dữ liệu an toàn
Future<String?> getSecureToken() async {
  return await _storage.read(key: 'auth_token');
}

// Xóa dữ liệu an toàn
Future<void> deleteSecureToken() async {
  await _storage.delete(key: 'auth_token');
}

Future<void> saveAuthData(UserResponse userResponse) async {
  saveSecureToken(userResponse.userToken);

  String userDataJson = jsonEncode(userResponse.toJson());
  await _storage.write(key: 'user_data', value: userDataJson);
}

Future<UserResponse?> getAuthData() async {
  String? userDataJson = await _storage.read(key: 'user_data');
  if (userDataJson != null) {
    return UserResponse.fromJson(jsonDecode(userDataJson));
  }
  return null;
}