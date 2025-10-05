// lib/shared/services/dio_service.dart
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;
  DioClient._internal();

  late final Dio _dio;
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  // Token storage keys
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _expiredTimeKey = 'token_expired_time';

  Future<void> initialize(String baseUrl) async {
    _dio = Dio();
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
    _dio.options.sendTimeout = const Duration(seconds: 10);

    // Add interceptors
    _addAuthInterceptor();
    _addLoggingInterceptor();
  }

  void _addAuthInterceptor() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          await _attachTokenToRequest(options);
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            // Try to refresh token
            final refreshed = await _refreshAccessToken();
            if (refreshed) {
              // Retry the original request
              final newOptions = error.requestOptions;
              await _attachTokenToRequest(newOptions);

              try {
                final response = await _dio.fetch(newOptions);
                handler.resolve(response);
                return;
              } catch (e) {
                // Refresh succeeded but retry failed
              }
            }

            // Refresh failed or retry failed - logout user
            await _handleAuthFailure();
          }
          handler.next(error);
        },
      ),
    );
  }

  void _addLoggingInterceptor() {
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        logPrint: (obj) {
          // Custom logging - you can integrate with your logger service
          print('[DIO] $obj');
        },
      ),
    );
  }

  Future<void> _attachTokenToRequest(RequestOptions options) async {
    final accessToken = await _secureStorage.read(key: _accessTokenKey);
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
  }

  Future<bool> _refreshAccessToken() async {
    try {
      final refreshToken = await _secureStorage.read(key: _refreshTokenKey);
      if (refreshToken == null) return false;

      final response = await _dio.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
        options: Options(
          headers: {'Authorization': null}, // Don't send old token
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;

        // Store new tokens
        await _secureStorage.write(
          key: _accessTokenKey,
          value: data['accessToken'] as String,
        );

        if (data['refreshToken'] != null) {
          await _secureStorage.write(
            key: _refreshTokenKey,
            value: data['refreshToken'] as String,
          );
        }

        // Calculate and store expiration time
        final expiresIn = data['expiresIn'] as int? ?? 3600; // Default 1 hour
        final expiredTime = DateTime.now().add(
          Duration(seconds: expiresIn - 240), // 4 minutes buffer
        );
        await _secureStorage.write(
          key: _expiredTimeKey,
          value: expiredTime.toIso8601String(),
        );

        return true;
      }
    } catch (e) {
      print('[DIO] Token refresh failed: $e');
    }
    return false;
  }

  Future<void> _handleAuthFailure() async {
    // Clear all auth tokens
    await _secureStorage.delete(key: _accessTokenKey);
    await _secureStorage.delete(key: _refreshTokenKey);
    await _secureStorage.delete(key: _expiredTimeKey);

    // Notify auth service about logout (optional)
    // You can implement an auth state notifier here
  }

  // Token management methods (for AuthService)
  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
    int? expiresIn,
  }) async {
    await _secureStorage.write(key: _accessTokenKey, value: accessToken);

    if (refreshToken != null) {
      await _secureStorage.write(key: _refreshTokenKey, value: refreshToken);
    }

    if (expiresIn != null) {
      final expiredTime = DateTime.now().add(
        Duration(seconds: expiresIn - 240), // 4 minutes buffer
      );
      await _secureStorage.write(
        key: _expiredTimeKey,
        value: expiredTime.toIso8601String(),
      );
    }
  }

  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: _accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: _refreshTokenKey);
  }

  Future<void> clearTokens() async {
    await _secureStorage.delete(key: _accessTokenKey);
    await _secureStorage.delete(key: _refreshTokenKey);
    await _secureStorage.delete(key: _expiredTimeKey);
  }

  Future<bool> hasValidToken() async {
    final accessToken = await _secureStorage.read(key: _accessTokenKey);
    final expiredTimeStr = await _secureStorage.read(key: _expiredTimeKey);

    if (accessToken == null || expiredTimeStr == null) return false;

    try {
      final expiredTime = DateTime.parse(expiredTimeStr);
      return DateTime.now().isBefore(expiredTime);
    } catch (e) {
      return false;
    }
  }

  // HTTP Methods
  Future<Response<T>> get<T>(
      String path, {
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
      }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Future<Response<T>> post<T>(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
      }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Future<Response<T>> put<T>(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
      }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Future<Response<T>> delete<T>(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
      }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Exception _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Kết nối mạng bị timeout');
      case DioExceptionType.badResponse:
        return _handleResponseError(e);
      case DioExceptionType.cancel:
        return Exception('Yêu cầu bị hủy');
      default:
        return Exception('Lỗi kết nối mạng');
    }
  }

  Exception _handleResponseError(DioException e) {
    final statusCode = e.response?.statusCode;
    final message = e.response?.data?['message'] as String?;

    switch (statusCode) {
      case 400:
        return Exception(message ?? 'Yêu cầu không hợp lệ');
      case 401:
        return Exception('Phiên đăng nhập hết hạn');
      case 403:
        return Exception('Không có quyền truy cập');
      case 404:
        return Exception('Không tìm thấy dữ liệu');
      case 422:
        return Exception(message ?? 'Dữ liệu không hợp lệ');
      case 500:
        return Exception('Lỗi máy chủ');
      default:
        return Exception(message ?? 'Đã có lỗi xảy ra');
    }
  }
}
