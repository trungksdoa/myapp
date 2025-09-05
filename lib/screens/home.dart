import 'package:flutter/material.dart';
import 'package:myapp/core/utils/device_size.dart';
import 'package:myapp/core/utils/performance_monitor.dart';
import 'package:myapp/core/utils/image_cache.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../component/card_item.dart'; // Nếu cần

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _HomeState(); // Đổi tên state class cho rõ ràng
}

class _HomeState extends State<Home> {
  final services = [
    {'icon': "assets/images/Home1.png", 'label': 'Dịch vụ chăm sóc thú cưng'},
    {'icon': "assets/images/Home2.png", 'label': 'Sức khỏe và vệ sinh'},
    {'icon': "assets/images/Home3.png", 'label': 'Thức ăn và dinh dưỡng'},
    {'icon': "assets/images/Home4.png", 'label': 'Phụ kiện và đồ dùng'},
    {'icon': "assets/images/Home5.png", 'label': 'Y tế thú y'},
    {'icon': "assets/images/Home6.png", 'label': 'Khác'},
  ];

  @override
  void initState() {
    super.initState();
    _preloadImages();
  }

  void _preloadImages() {
    // Preload service images
    final imagePaths = services.map((s) => s['icon']!).toList();

    // Add other images used in HomeScreen
    imagePaths.add('assets/images/preview_map.png');
    imagePaths.add('assets/images/user_avatar.jpg');

    // Preload images without context first (basic caching)
    for (final path in imagePaths) {
      ImageCacheManager.getCachedImage(path);
    }

    // Detailed preloading will happen in build method
  }

  void showNotification(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(16),
      backgroundColor: Colors.black87,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    PerformanceMonitor.start('HomeScreen build');

    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = DeviceSize.getResponsiveFontSize(screenWidth);

    final widget = SizedBox(
      child: CustomScrollView(
        slivers: [
          // MyAppBar(), // Đã di chuyển vào MainLayout
          SliverPadding(
            padding: EdgeInsets.all(20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 20,
                childAspectRatio: 0.72,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                return PetServiceCard(
                  assetIcon: services[index]['icon']!,
                  label: services[index]['label']!,
                  size: 75,
                  onTap: () {
                    showNotification(
                      context,
                      'Đã chọn ${services[index]['label']!}',
                    );
                  },
                );
              }, childCount: services.length),
            ),
          ),

          //Bản đồ
          SliverToBoxAdapter(
            child: Card(
              margin: EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 6,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  children: [
                    Flexible(
                      flex: 6,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: 140,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/images/preview_map.png',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Flexible(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Trải nghiệm tìm kiếm phòng khám uy tín gần khu vực của bạn',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: fontSize + 2,
                            ),
                          ),
                          SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                shape: StadiumBorder(),
                                backgroundColor: Colors.teal,
                                padding: EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 24,
                                ),
                              ),
                              child: Text(
                                'Đăng nhập',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: fontSize + 1,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            "Đăng nhập để trải nghiệm nhiều hơn",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: fontSize - 2,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // --- Card đánh giá khách hàng ---
          SliverToBoxAdapter(
            child: Card(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 5,
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Đánh giá từ khách hàng',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    // Thay List.generate hiện tại bằng Column với padding giữa các hàng
                    Column(
                      children: List.generate(4, (i) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundImage: AssetImage(
                                  'assets/images/user_avatar.jpg',
                                ),
                                radius: 16, // hơi nhỏ lại cho gọn
                                backgroundColor: Colors.grey.shade300,
                              ),
                              SizedBox(width: 12),
                              // Text chiếm không gian còn lại để dãy sao đẩy sang phải
                              Expanded(
                                child: Text(
                                  'Giao hàng sớm',
                                  style: TextStyle(fontSize: fontSize),
                                ),
                              ),
                              SizedBox(width: 8),
                              // Star row nhỏ gọn
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(
                                  5,
                                  (j) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 16, // nhỏ hơn để hợp tỷ lệ
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    PerformanceMonitor.stop('HomeScreen build');
    return widget;
  }
}
