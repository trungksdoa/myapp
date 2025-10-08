import 'package:dio/dio.dart';
import 'package:myapp/core/network/dio_service.dart';

class ChatService {
  final DioClient _dio = DioClient();

  Future<String> sendMessage(String input, String? userId) async {
    try {
      final response = await _dio.post(
        '/webhook/bc798bc5-1e01-4390-bcad-f7564e7f9bfc',
        data: {'input': input, 'sessionId': userId},
        customBaseUrl: 'https://izffzjus5.tino.page',
        options: Options(
          receiveTimeout: const Duration(seconds: 30),
        ), // Tăng timeout lên 30s
      );

      // Giả sử response trả về JSON với key 'response'
      final data = response.data;
      if (data is List && data.isNotEmpty) {
        final firstItem = data[0] as Map<String, dynamic>;
        return firstItem['response'] as String? ?? 'Không có phản hồi';
      }
      return 'Không có phản hồi';
    } catch (e) {
      return 'Lỗi khi gửi tin nhắn: $e';
    }
  }
}
