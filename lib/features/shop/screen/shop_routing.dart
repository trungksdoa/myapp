import 'package:flutter/material.dart';
import 'package:myapp/route/navigate_helper.dart';
import 'package:myapp/shared/widgets/common/custom_card.dart';
import 'package:myapp/shared/widgets/common/custom_text.dart';
import 'package:myapp/shared/widgets/common/app_spacing.dart';

class ShopRoutingScreen extends StatelessWidget {
  const ShopRoutingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenHeight = constraints.maxHeight;
            final isSmallScreen = screenHeight < 600;

            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: screenHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            SizedBox(height: isSmallScreen ? 20 : 40),
                            // Welcome section
                            CustomText.title(
                              text: 'Chào mừng đến với chúng tôi',
                              color: Colors.black87,
                              textAlign: TextAlign.center,
                            ),
                            AppSpacing.verticalSM,
                            CustomText.body(
                              text: 'Chọn loại sản phẩm bạn muốn xem',
                              color: Colors.grey.shade600,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: isSmallScreen ? 30 : 60),
                          ],
                        ),

                        // Service options section
                        Column(
                          children: [
                            _buildOptionCard(
                              context: context,
                              title: 'Dịch Vụ',
                              subtitle:
                                  'Khám chữa bệnh, spa, grooming, khách sạn thú cưng',
                              icon: Icons.medical_services,
                              color: Colors.blue,
                              onTap: () =>
                                  NavigateHelper.goToShopServices(context),
                              isSmallScreen: isSmallScreen,
                            ),
                            SizedBox(height: isSmallScreen ? 16 : 24),

                            // Product option
                            _buildOptionCard(
                              context: context,
                              title: 'Sản Phẩm',
                              subtitle:
                                  'Thức ăn, đồ chơi, phụ kiện, thuốc cho thú cưng',
                              icon: Icons.shopping_bag,
                              color: Colors.orange,
                              onTap: () =>
                                  NavigateHelper.goToShopProducts(context),
                              isSmallScreen: isSmallScreen,
                            ),
                          ],
                        ),

                        // Bottom text
                        Column(
                          children: [
                            SizedBox(height: isSmallScreen ? 20 : 40),
                            CustomText.caption(
                              text:
                                  'Bạn có thể chuyển đổi giữa các loại bất kỳ lúc nào',
                              color: Colors.grey.shade500,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: isSmallScreen ? 15 : 20),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    bool isSmallScreen = false,
  }) {
    return CustomCard(
      onTap: onTap,
      backgroundColor: Colors.white,
      borderRadius: 16.0,
      elevation: 4,
      child: Container(
        padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
        child: Row(
          children: [
            // Icon container
            Container(
              width: isSmallScreen ? 50 : 60,
              height: isSmallScreen ? 50 : 60,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: isSmallScreen ? 24 : 30, color: color),
            ),
            SizedBox(width: isSmallScreen ? 16 : 20),

            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText.subtitle(text: title, color: Colors.black87),
                  AppSpacing.verticalXS,
                  CustomText.caption(
                    text: subtitle,
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
            ),

            // Arrow icon
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey.shade400,
              size: isSmallScreen ? 16 : 20,
            ),
          ],
        ),
      ),
    );
  }
}
