import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioClient {
  final Dio dio;

  DioClient._internal(this.dio);

  static Future<DioClient> create() async {
    final dio = Dio();

    dio.options.baseUrl = 'https://api-tech.com/v1';
    dio.options.connectTimeout = Duration(seconds: 3); // kết nối timeout 3 giây
    dio.options.receiveTimeout = Duration(
      seconds: 3,
    ); // nhận dữ liệu timeout 3 giây

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          String? accessToken = prefs.getString('accessToken');
          String? expiredTimeStr = prefs.getString('expiredTime');
          String? refreshToken = prefs.getString('refreshToken');

          // Nếu không có token thì gửi request bình thường
          if (accessToken == null ||
              expiredTimeStr == null ||
              refreshToken == null) {
            return handler.next(options);
          }

          final expiredTime = DateTime.parse(expiredTimeStr);
          final isExpired = DateTime.now().isAfter(expiredTime);

          // Nếu accessToken hết hạn, gọi refresh token để lấy token mới
          if (isExpired) {
            try {
              final response = await dio.post(
                '/auth/user-refresh-token',
                data: {'refreshToken': refreshToken},
              );
              if (response.statusCode == 200 && response.data != false) {
                accessToken = response.data['accessToken'];
                final newExpiredTime = DateTime.now().add(
                  Duration(seconds: response.data['expiresIn'] - 240),
                );
                await prefs.setString('accessToken', accessToken!);
                await prefs.setString(
                  'expiredTime',
                  newExpiredTime.toIso8601String(),
                );
                options.headers['Authorization'] = 'Bearer $accessToken';
              } else {
                // Xử lý logout hoặc không còn login
                // logout();
              }
            } catch (e) {
              // Xử lý lỗi refresh token
              // logout();
              return handler.reject(e as DioError);
            }
          } else {
            // Nếu token còn hạn thì gắn token vào header
            options.headers['Authorization'] = 'Bearer $accessToken';
          }

          return handler.next(options);
        },

        onResponse: (response, handler) {
          return handler.next(response);
        },

        onError: (DioError error, handler) async {
          if (error.response?.statusCode == 401) {
            // Có thể xử lý logout ở đây nếu cần
            // logout();
          }
          return handler.next(error);
        },
      ),
    );

    return DioClient._internal(dio);
  }
}
