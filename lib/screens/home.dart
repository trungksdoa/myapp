// import 'package:flutter/material.dart';
// import 'package:myapp/component/AppBar.dart';
// import 'package:myapp/core/theme/custom_colors.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// import '../component/CardItem.dart';
//
// class Home extends StatefulWidget {
//   const Home({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<Home> createState() => _TestState();
// }
//
// class _TestState extends State<Home> {
//   final services = [
//     {'icon':  "assets/images/Home1.png", 'label': 'Dịch vụ chăm sóc thú cưng'},
//     {'icon':  "assets/images/Home2.png", 'label': 'Sức khỏe và vệ sinh'},
//     {'icon':  "assets/images/Home3.png", 'label': 'Thức ăn và dinh dưỡng'},
//     {'icon':  "assets/images/Home4.png", 'label': 'Phụ kiện và đồ dùng'},
//     {'icon':  "assets/images/Home5.png", 'label': 'Y tế thú y'},
//     {'icon':  "assets/images/Home6.png", 'label': 'Khác'},
//   ];
//
//   void showNotification(BuildContext context, String message) {
//     final snackBar = SnackBar(
//       content: Text(message),
//       duration: Duration(seconds: 3),  // thời gian hiển thị
//       behavior: SnackBarBehavior.floating, // để SnackBar nổi trên nội dung (tuỳ chọn)
//       margin: EdgeInsets.all(16), // khoảng cách cách viền màn hình (khi floating)
//       backgroundColor: Colors.black87, // màu nền SnackBar
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(8), // bo góc cho SnackBar
//       ),
//     );
//
//     // Hiển thị SnackBar
//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: CustomScrollView(
//         slivers: [
//           MyAppBar(),
//           SliverPadding(
//             padding: EdgeInsets.all(20), // khoảng cách trên padding, tùy chỉnh
//             sliver: SliverGrid(
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 3, // 3 item trên một hàng
//                 mainAxisSpacing: 10, // khoảng cách dọc giữa các item
//                 crossAxisSpacing: 20, // khoảng cách ngang giữa các item
//                 childAspectRatio: 0.72, // tỷ lệ rộng / cao của mỗi item
//               ),
//               delegate: SliverChildBuilderDelegate(
//                     (context, index) {
//                   return PetServiceCard(
//                     assetIcon: services[index]['icon']!,
//                     label: services[index]['label']!,
//                     size: 75,
//                     onTap: (){
//                       showNotification(context, 'Đã chọn ' + services[index]['label']!);
//                     },
//                   );
//                 },
//                 childCount: services.length,
//               )
//             ),
//           ),
//
//           //Bản đồ
//
//           SliverToBoxAdapter(
//             child: Card(
//               margin: EdgeInsets.all(16),
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//               elevation: 6,
//               child: Padding(
//                 padding: EdgeInsets.all(12),
//                 child: Row(
//                   children: [
//                     // Cột map bên trái, chiếm ~40% chiều rộng
//                     Expanded(
//                       flex: 6,
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(10),
//                         child: Image.asset(
//                           'assets/images/preview_map.png',
//                           height: 140,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 16), // Khoảng cách giữa 2 cột
//                     // Cột text + button bên phải, chiếm ~60% chiều rộng
//                     Expanded(
//                       flex: 4,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Trải nghiệm tìm kiếm phòng khám uy tín gần khu vực của bạn',
//                             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                           ),
//                           SizedBox(height: 16),
//                           ElevatedButton(
//                             onPressed: () {},
//                             style: ElevatedButton.styleFrom(
//                               shape: StadiumBorder(),
//                               backgroundColor: Colors.teal,
//                             ),
//                             child: Text('Đăng nhập',
//                             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//
//                           ),
//                           SizedBox(height: 6),
//                           Text(
//                             "Đăng nhập để trải nghiệm nhiều hơn",
//                             style: TextStyle(color: Colors.black54, fontSize: 12, fontFamily: 'Roboto'),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//
//           // // --- Card đánh giá khách hàng ---
//           SliverToBoxAdapter(
//             child: Card(
//               margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//               elevation: 5,
//               child: Padding(
//                 padding: EdgeInsets.all(12),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Đánh giá từ khách hàng', style: TextStyle(fontWeight: FontWeight.bold)),
//                     SizedBox(height: 8),
//                     // Ví dụ review lặp:
//                     ...List.generate(4, (i) => Row(
//                       children: [
//                         CircleAvatar(
//                           backgroundImage: AssetImage('assets/images/user_avatar.jpg'),
//                           radius: 18,
//                         ),
//                         SizedBox(width: 8),
//                         Text('Giao hàng sớm'),
//                         SizedBox(width: 8),
//                         Row(
//                           children: List.generate(5, (j) => Icon(Icons.star, color: Colors.amber, size: 18)),
//                         ),
//                       ],
//                     )),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ), // appBar: MyAppBar(),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
// import 'package:myapp/services/ollama_service.dart';

import '../service/ollama_service.dart'; // Đảm bảo đường dẫn chính xác

void main() {
  runApp(const Home());
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Analysis App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PetAnalysisScreen(),
    );
  }
}

class PetAnalysisScreen extends StatefulWidget {
  const PetAnalysisScreen({super.key});

  @override
  _PetAnalysisScreenState createState() => _PetAnalysisScreenState();
}

class _PetAnalysisScreenState extends State<PetAnalysisScreen> {
  final TextEditingController _inputController = TextEditingController();
  String _analysisResult = ''; // Lưu kết quả phân tích
  bool _isLoading = false; // Biến để theo dõi trạng thái tải
  late OllamaService _ollamaService; // Khai báo service

  @override
  void initState() {
    super.initState();
    // Khởi tạo OllamaService với baseUrl của bạn
    // RẤT QUAN TRỌNG: THAY ĐỔI BASE URL NÀY CHO PHÙ HỢP VỚI CẤU HÌNH OLLAMA CỦA BẠN
    // Ví dụ: 'http://localhost:11434' nếu chạy trên máy tính và test trên web/desktop
    // Ví dụ: 'http://10.0.2.2:11434' nếu chạy Ollama trên máy tính và test trên Android emulator
    // Ví dụ: 'http://192.168.1.XXX:11434' nếu chạy Ollama trên máy tính và test trên thiết bị Android thật
    _ollamaService = OllamaService(); // <-- THAY ĐỔI DÒNG NÀY
  }

  // Hàm để gọi model phân tích từ Ollama
  void _analyzeInput() async {
    String input = _inputController.text.trim();
    if (input.isEmpty) {
      setState(() {
        _analysisResult = 'Vui lòng nhập mô tả tình trạng thú cưng.';
      });
      return;
    }

    setState(() {
      _isLoading = true; // Bắt đầu tải
      _analysisResult = 'Đang phân tích với Ollama...';
    });

    try {
      // Gọi Ollama API qua service đã tạo
      String ollamaResponse = await _ollamaService.chat(
        'gemma3:270m', // <-- THAY ĐỔI TÊN MODEL OLLAMA CỦA BẠN (ví dụ: 'gemma:2b', 'llama2', 'mistral')
        input,
      );

      setState(() {
        _analysisResult = ollamaResponse;
      });
    } catch (e) {
      setState(() {
        _analysisResult = 'Đã xảy ra lỗi khi gọi Ollama: $e';
      });
    } finally {
      setState(() {
        _isLoading = false; // Kết thúc tải
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản Lý Thú Cưng - Phân Tích Tình Trạng'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nhập mô tả tình trạng thú cưng (ví dụ: triệu chứng, dữ liệu MCP):',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _inputController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),

                hintText: 'Ví dụ: Chó của tôi ít vận động và thở nặng...',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _analyzeInput, // Vô hiệu hóa nút khi đang tải
              child: _isLoading
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
                  : const Text('Phân Tích Với Model'),
            ),
            const SizedBox(height: 24),
            if (_analysisResult.isNotEmpty) ...[
              const Text(
                'Kết Quả Phân Tích:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Expanded( // Sử dụng Expanded để kết quả có thể cuộn nếu dài
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _analysisResult,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}