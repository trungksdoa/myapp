import 'dart:convert';
import 'package:http/http.dart' as http;

class OllamaService {
  final String baseUrl = 'http://10.0.2.2:11434'; // Ví dụ: 'http://localhost:11434'

  OllamaService();

  Future<String> chat(String model, String userMessage) async {
    final url = Uri.parse('$baseUrl/api/chat');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'model': model,
      'messages': [
        {'role': 'user', 'content': userMessage},
      ],
      'stream': false, // Nếu bạn muốn nhận toàn bộ phản hồi một lần
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        // Endpoint /api/chat trả về một cấu trúc khác, cần lấy content từ 'message'
        return jsonResponse['message']['content'] ?? 'Không có phản hồi từ Ollama.';
      } else {
        return 'Lỗi khi gọi API Ollama: ${response.statusCode} - ${response.body}';
      }
    } catch (e) {
      return 'Lỗi kết nối đến Ollama: $e\nĐảm bảo Ollama đang chạy và có thể truy cập từ thiết bị của bạn. Nếu chạy trên Android emulator, thử dùng 10.0.2.2 thay vì localhost.';
    }
  }
}