import 'package:flutter/material.dart';
import 'package:myapp/auth_factory.dart';
import 'package:myapp/core/utils/device_size.dart';
import 'package:myapp/core/utils/performance_monitor.dart';
import 'package:myapp/core/utils/image_cache.dart';
import 'package:myapp/widget/shop_map.dart';

import '../component/card_item.dart';
import '../widget/index.dart';

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

  final auth = AuthFactory.instance;

  Widget _buildMapService(double fontSize) {
    return SliverToBoxAdapter(
      child: CustomCard(
        margin: AppMargin.lg,
        padding: AppPadding.md,
        borderRadius: 16.0,
        elevation: 6.0,
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
                      image: AssetImage('assets/images/preview_map.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            AppSpacing.horizontalLG,
            Flexible(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText.title(
                    text:
                        'Trải nghiệm tìm kiếm phòng khám uy tín gần khu vực của bạn',
                    fontSize: fontSize + 2,
                  ),
                  AppSpacing.verticalLG,
                  CustomElevatedButton.primary(
                    text: 'Đăng nhập',
                    onPressed: () {},
                    width: double.infinity,
                  ),
                  AppSpacing.verticalXS,
                  CustomText.caption(
                    text: "Đăng nhập để trải nghiệm nhiều hơn",
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    PerformanceMonitor.start('HomeScreen build');
    double fontSize = DeviceSize.getResponsiveFontSize(
      MediaQuery.of(context).size.width,
    );
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

          if (!auth.isAuthenticated)
            //Bản đồ
            _buildMapService(fontSize),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ShopMap(title: "map"),
            ),
          ),
          // --- Card đánh giá khách hàng ---
          // SliverToBoxAdapter(
          //   child: CustomCard(
          //     margin: AppMargin.symmetric(horizontal: 16, vertical: 8),
          //     padding: AppPadding.lg,
          //     borderRadius: 16.0,
          //     elevation: 5.0,
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         CustomText.subtitle(text: 'Đánh giá từ khách hàng'),
          //         AppSpacing.verticalSM,
          //         Column(
          //           children: List.generate(4, (i) {
          //             return Padding(
          //               padding: AppPadding.verticalSM,
          //               child: Row(
          //                 crossAxisAlignment: CrossAxisAlignment.center,
          //                 children: [
          //                   CircleAvatar(
          //                     backgroundImage: AssetImage(
          //                       'assets/images/user_avatar.jpg',
          //                     ),
          //                     radius: 16,
          //                     backgroundColor: Colors.grey.shade300,
          //                   ),
          //                   AppSpacing.horizontalMD,
          //                   Expanded(
          //                     child: CustomText.body(text: 'Giao hàng sớm'),
          //                   ),
          //                   AppSpacing.horizontalSM,
          //                   CommonWidgets.starRating(rating: 5, size: 16),
          //                 ],
          //               ),
          //             );
          //           }),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );

    PerformanceMonitor.stop('HomeScreen build');
    // if (auth.isAuthenticated) {
    //   return ShopMap(title: "map");
    // }

    return widget;
  }
}
