import 'package:flutter/material.dart';
import 'package:myapp/component/AppBar.dart';
import 'package:myapp/core/theme/custom_colors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../component/CardItem.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _TestState();
}

class _TestState extends State<Home> {
  final services = [
    {'icon':  "assets/images/Home1.png", 'label': 'Dịch vụ chăm sóc thú cưng'},
    {'icon':  "assets/images/Home2.png", 'label': 'Sức khỏe và vệ sinh'},
    {'icon':  "assets/images/Home3.png", 'label': 'Thức ăn và dinh dưỡng'},
    {'icon':  "assets/images/Home4.png", 'label': 'Phụ kiện và đồ dùng'},
    {'icon':  "assets/images/Home5.png", 'label': 'Y tế thú y'},
    {'icon':  "assets/images/Home6.png", 'label': 'Khác'},
  ];

  void showNotification(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 3),  // thời gian hiển thị
      behavior: SnackBarBehavior.floating, // để SnackBar nổi trên nội dung (tuỳ chọn)
      margin: EdgeInsets.all(16), // khoảng cách cách viền màn hình (khi floating)
      backgroundColor: Colors.black87, // màu nền SnackBar
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // bo góc cho SnackBar
      ),
    );

    // Hiển thị SnackBar
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          MyAppBar(),
          SliverPadding(
            padding: EdgeInsets.all(20), // khoảng cách trên padding, tùy chỉnh
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3 item trên một hàng
                mainAxisSpacing: 10, // khoảng cách dọc giữa các item
                crossAxisSpacing: 20, // khoảng cách ngang giữa các item
                childAspectRatio: 0.72, // tỷ lệ rộng / cao của mỗi item
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return PetServiceCard(
                    assetIcon: services[index]['icon']!,
                    label: services[index]['label']!,
                    size: 75,
                    onTap: (){
                      showNotification(context, 'Đã chọn ' + services[index]['label']!);
                    },
                  );
                },
                childCount: services.length,
              )
            ),
          ),

          //Bản đồ

          SliverToBoxAdapter(
            child: Card(
              margin: EdgeInsets.all(16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 6,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  children: [
                    // Cột map bên trái, chiếm ~40% chiều rộng
                    Expanded(
                      flex: 6,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'assets/images/preview_map.png',
                          height: 140,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 16), // Khoảng cách giữa 2 cột
                    // Cột text + button bên phải, chiếm ~60% chiều rộng
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Trải nghiệm tìm kiếm phòng khám uy tín gần khu vực của bạn',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              shape: StadiumBorder(),
                              backgroundColor: Colors.teal,
                            ),
                            child: Text('Đăng nhập',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),

                          ),
                          SizedBox(height: 6),
                          Text(
                            "Đăng nhập để trải nghiệm nhiều hơn",
                            style: TextStyle(color: Colors.black54, fontSize: 12, fontFamily: 'Roboto'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // // --- Card đánh giá khách hàng ---
          // SliverToBoxAdapter(
          //   child: Card(
          //     margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          //     elevation: 5,
          //     child: Padding(
          //       padding: EdgeInsets.all(12),
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Text('Đánh giá từ khách hàng', style: TextStyle(fontWeight: FontWeight.bold)),
          //           SizedBox(height: 8),
          //           // Ví dụ review lặp:
          //           ...List.generate(4, (i) => Row(
          //             children: [
          //               CircleAvatar(
          //                 backgroundImage: AssetImage('assets/images/user_avatar.jpg'),
          //                 radius: 18,
          //               ),
          //               SizedBox(width: 8),
          //               Text('Giao hàng sớm'),
          //               SizedBox(width: 8),
          //               Row(
          //                 children: List.generate(5, (j) => Icon(Icons.star, color: Colors.amber, size: 18)),
          //               ),
          //             ],
          //           )),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ), // appBar: MyAppBar(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
