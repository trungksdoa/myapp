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
                    NotificationUtils.showNotification(
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
            SliverToBoxAdapter(
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
            ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ShopMap(),
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
