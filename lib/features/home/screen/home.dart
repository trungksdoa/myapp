import 'package:flutter/material.dart';
import 'package:myapp/service/auth_factory.dart';
import 'package:myapp/core/utils/device_size.dart';
import 'package:myapp/core/utils/performance_monitor.dart';
import 'package:myapp/core/utils/image_cache.dart';
import 'package:myapp/mock_data/shop_mock.dart';
import 'package:myapp/features/shop/widgets/shop_map.dart';
import 'package:myapp/shared/widgets/cards/card_item.dart';
import 'package:myapp/shared/widgets/common/custom_elevated_button.dart';
import 'package:myapp/shared/widgets/common/notification.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _HomeState(); // Đổi tên state class cho rõ ràng
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    _preloadImages();
    // Show skeleton/loading state briefly on first load
    _simulateLoading();
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

  final auth = AuthFactory.instance;

  bool _enabled = true;

  //Create simple delay time then set _enabled to false
  Future<void> _simulateLoading() async {
    await Future.delayed(const Duration(seconds: 20));
    if (mounted) {
      setState(() {
        _enabled = false;
      });
    }
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
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Xin chào!',
                    style: TextStyle(
                      fontSize: fontSize + 8,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Chọn dịch vụ bạn cần',
                    style: TextStyle(
                      fontSize: fontSize - 2,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                return Hero(
                  tag: 'service-${services[index]['key']}',
                  child: Material(
                    color: Colors.transparent,
                    child: PetServiceCard(
                      assetIcon: services[index]['icon']!,
                      label: services[index]['label']!,
                      size: 75,
                      onTap: () {
                        NotificationUtils.showNotification(
                          context,
                          'Đã chọn ${services[index]['label']!}',
                        );
                      },
                    ),
                  ),
                );
              }, childCount: services.length),
            ),
          ),

          // Thay khối SliverToBoxAdapter đăng nhập
          if (!auth.isAuthenticated)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.blue[50]!, Colors.blue[100]!],
                        ),
                      ),
                      child: LayoutBuilder(
                        builder: (context, c) {
                          final titleSize = c.maxWidth < 340
                              ? fontSize
                              : fontSize + 2;
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 6,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: Image.asset(
                                      'assets/images/preview_map.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Tìm phòng khám uy tín gần bạn',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: titleSize,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.blueGrey.shade900,
                                        height: 1.1,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    // Buffer phải 2px tránh cảnh báo overflow biên phải
                                    Padding(
                                      padding: const EdgeInsets.only(right: 2),
                                      child: SizedBox(
                                        height: 44,
                                        width: double.infinity,
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.centerRight,
                                          child: CustomElevatedButton.primary(
                                            text: 'Đăng nhập ngay',
                                            onPressed: () {},
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Đăng nhập để trải nghiệm đầy đủ',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: fontSize - 4,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),

          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: const ShopMap(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Row(
                children: [
                  Text(
                    'Đánh giá từ khách hàng',
                    style: TextStyle(
                      fontSize: fontSize + 2,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(
              height: 140,
              child: PageView.builder(
                controller: PageController(viewportFraction: 0.88),
                itemCount: 5, // có thể thay bằng dữ liệu thật
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 16, right: 12),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundImage: const AssetImage(
                                'assets/images/user_avatar.jpg',
                              ),
                              backgroundColor: Colors.grey.shade300,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Người dùng #$i',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: fontSize - 2,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      // rating mini
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: List.generate(
                                          5,
                                          (j) => Icon(
                                            Icons.star_rounded,
                                            color: Colors.amber[600],
                                            size: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Giao hàng sớm, dịch vụ chu đáo. Sẽ ủng hộ lần sau!',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: fontSize - 4,
                                      color: Colors.grey[700],
                                      height: 1.25,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // 6) Indicator nho nhỏ
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 6, bottom: 16),
              child: Center(
                child: Container(
                  height: 4,
                  width: 36,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    PerformanceMonitor.stop('HomeScreen build');
    // if (auth.isAuthenticated) {
    //   return ShopMap(title: "map");
    // }

    return Skeletonizer(enabled: _enabled, child: widget);
  }
}
