import 'package:flutter/material.dart';
import 'package:myapp/service/auth_factory.dart';
import 'package:myapp/core/utils/device_size.dart';
import 'package:myapp/core/utils/performance_monitor.dart';
import 'package:myapp/core/utils/image_cache.dart';
import 'package:myapp/mock_data/shop_mock.dart';
import 'package:myapp/features/shop/widgets/shop_map.dart';
import 'package:myapp/shared/widgets/common/card_item.dart';
import 'package:myapp/shared/widgets/common/custom_card.dart';
import 'package:myapp/shared/widgets/common/app_spacing.dart';
import 'package:myapp/shared/widgets/common/custom_text.dart';
import 'package:myapp/shared/widgets/common/custom_elevated_button.dart';
import 'package:myapp/shared/widgets/common/notification.dart';

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

          if (!auth.isAuthenticated)
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: CustomCard(
                  margin: EdgeInsets.zero,
                  padding: AppPadding.md,
                  borderRadius: 20.0,
                  elevation: 4.0,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.blue[50]!, Colors.blue[100]!],
                      ),
                    ),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 6,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              height: 160,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                                image: const DecorationImage(
                                  image: AssetImage(
                                    'assets/images/preview_map.png',
                                  ),
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
                                text: 'Tìm phòng khám uy tín gần bạn',
                                fontSize: fontSize + 2,
                              ),
                              AppSpacing.verticalLG,
                              CustomElevatedButton.primary(
                                text: 'Đăng nhập ngay',
                                onPressed: () {},
                                width: double.infinity,
                              ),
                              AppSpacing.verticalSM,
                              CustomText.caption(
                                text: "Đăng nhập để trải nghiệm đầy đủ",
                                color: Colors.black54,
                              ),
                            ],
                          ),
                        ),
                      ],
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
