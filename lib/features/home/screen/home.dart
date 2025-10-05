import 'package:flutter/material.dart';
import 'package:myapp/core/utils/device_size.dart';
import 'package:myapp/core/utils/performance_monitor.dart';
import 'package:myapp/core/utils/image_cache.dart';
import 'package:myapp/core/colors.dart';
import 'package:myapp/features/shop/widgets/shop_map.dart';
import 'package:myapp/shared/widgets/common/custom_elevated_button.dart';
import 'package:myapp/shared/widgets/common/notification.dart';
import 'package:myapp/features/auth/service/auth_service.dart';
import 'package:skeletonizer/skeletonizer.dart';

// Mock services data
const List<Map<String, String>> services = [
  {'key': 'vet', 'icon': 'assets/images/vet_icon.png', 'label': 'Thú y'},
  {
    'key': 'grooming',
    'icon': 'assets/images/grooming_icon.png',
    'label': 'Spa & Grooming',
  },
  {
    'key': 'hotel',
    'icon': 'assets/images/hotel_icon.png',
    'label': 'Khách sạn',
  },
  {'key': 'food', 'icon': 'assets/images/food_icon.png', 'label': 'Thức ăn'},
  {
    'key': 'pharmacy',
    'icon': 'assets/images/pharmacy_icon.png',
    'label': 'Nhà thuốc',
  },
  {
    'key': 'training',
    'icon': 'assets/images/training_icon.png',
    'label': 'Huấn luyện',
  },
];

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _HomeState(); // Đổi tên state class cho rõ ràng
}

class _HomeState extends State<Home> {
  double? _fontSize;
  double? _screenWidth;

  @override
  void initState() {
    super.initState();
    _preloadImages();
    // Show skeleton/loading state briefly on first load
    _simulateLoading();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Cache expensive MediaQuery operations
    _screenWidth = MediaQuery.of(context).size.width;
    _fontSize = DeviceSize.getResponsiveFontSize(_screenWidth!);
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

  final AuthService auth = AuthService();

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
    final fontSize = _fontSize ?? 14.0; // Use cached value

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
                final service = services[index];
                return RepaintBoundary(
                  child: Hero(
                    tag: 'service-${service['key']}',
                    child: Material(
                      color: Colors.transparent,
                      child: _OptimizedServiceCard(
                        key: ValueKey(service['key']),
                        assetIcon: service['icon']!,
                        label: service['label']!,
                        onTap: () {
                          NotificationUtils.showNotification(
                            context,
                            'Đã chọn ${service['label']!}',
                          );
                        },
                      ),
                    ),
                  ),
                );
              }, childCount: services.length),
            ),
          ),

          // Login section — wrap the non-sliver content with RepaintBoundary inside the SliverToBoxAdapter
          // Note: Using FutureBuilder for async authentication check
          SliverToBoxAdapter(
            child: FutureBuilder<bool>(
              future: auth.isAuthenticated(),
              builder: (context, snapshot) {
                final isAuthenticated = snapshot.data ?? false;
                if (isAuthenticated) return const SizedBox.shrink();
                return RepaintBoundary(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: _buildLoginPrompt(fontSize),
                  ),
                );
              },
            ),
          ),

          // Map section — apply RepaintBoundary to the box child inside SliverToBoxAdapter
          SliverToBoxAdapter(
            child: FutureBuilder<bool>(
              future: auth.isAuthenticated(),
              builder: (context, snapshot) {
                final isAuthenticated = snapshot.data ?? false;
                if (!isAuthenticated) return const SizedBox.shrink();
                return RepaintBoundary(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: const ShopMap(),
                  ),
                );
              },
            ),
          ),

          // Reviews section title
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

          // Optimized reviews list — keep RepaintBoundary around the box child inside SliverToBoxAdapter
          SliverToBoxAdapter(
            child: RepaintBoundary(
              child: SizedBox(
                height: 140,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemBuilder: (context, index) =>
                      RepaintBoundary(child: _buildReviewCard(index, fontSize)),
                ),
              ),
            ),
          ),

          // Bottom indicator
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: 6, bottom: 16),
              child: Center(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                  ),
                  child: SizedBox(height: 4, width: 36),
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

  // Helper method to build login prompt section
  Widget _buildLoginPrompt(double fontSize) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, 4),
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
            builder: (context, constraints) {
              final titleSize = constraints.maxWidth < 340
                  ? fontSize
                  : fontSize + 2;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Expanded(
                    flex: 6,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image(
                          image: AssetImage('assets/images/preview_map.png'),
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
    );
  }

  // Helper method to build optimized review cards
  Widget _buildReviewCard(int index, double fontSize) {
    final screenWidth = _screenWidth ?? 375.0; // Use cached value with fallback

    return Container(
      width: screenWidth * 0.88,
      margin: const EdgeInsets.only(right: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 22,
              backgroundImage: AssetImage('assets/images/user_avatar.jpg'),
              backgroundColor: Colors.grey,
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
                          'Người dùng #$index',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: fontSize - 2,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Optimized star rating
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                            size: 14,
                          ),
                          Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                            size: 14,
                          ),
                          Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                            size: 14,
                          ),
                          Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                            size: 14,
                          ),
                          Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                            size: 14,
                          ),
                        ],
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
    );
  }
}

// Optimized service card that minimizes rebuilds
class _OptimizedServiceCard extends StatelessWidget {
  final String assetIcon;
  final String label;
  final VoidCallback? onTap;

  const _OptimizedServiceCard({
    super.key,
    required this.assetIcon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
          border: Border.all(color: Colors.black26, width: 1.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Fixed size image with caching
              Flexible(
                flex: 3,
                child: CachedImage(
                  assetPath: assetIcon,
                  width: 60,
                  height: 60,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 8),

              // Optimized text with fixed styling
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      height: 1.2,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
