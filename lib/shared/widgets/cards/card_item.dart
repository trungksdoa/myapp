import 'package:flutter/material.dart';

import 'package:myapp/core/colors.dart';
import 'package:myapp/core/utils/device_size.dart';
import 'package:myapp/core/utils/image_cache.dart';

class PetServiceCard extends StatelessWidget {
  final String assetIcon;
  final String label;
  final double size;
  final VoidCallback? onTap;

  const PetServiceCard({
    super.key,
    required this.assetIcon,
    required this.label,
    required this.size,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Lấy thông tin màn hình
    final screenWidth = MediaQuery.of(context).size.width;

    // Auto-scale dựa trên screen size
    final scaleFactor = DeviceSize.getScaleFactor(screenWidth);
    final responsiveSize = size * scaleFactor;
    final responsiveFontSize = DeviceSize.getResponsiveFontSize(screenWidth);
    final responsivePadding = DeviceSize.getResponsivePadding(screenWidth);
    final responsiveBorderRadius = DeviceSize.getResponsiveBorderRadius(
      screenWidth,
    );

    // Với màn hình rất hẹp, tăng padding ngang cho text 1 chút
    final extraTight = screenWidth < 340;
    final textHPad = extraTight ? responsivePadding : responsivePadding * 0.5;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4 * scaleFactor),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(responsiveBorderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.25),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: Colors.black26,
            width: screenWidth < 400
                ? 0.5
                : 1.0, // Thinner border cho màn hình nhỏ
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(responsivePadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Auto-scale image with caching
              Flexible(
                flex: 3,
                child: CachedImage(
                  assetPath: assetIcon,
                  width: responsiveSize,
                  height: responsiveSize,
                  fit: BoxFit.contain,
                ),
              ),

              // Responsive spacing
              SizedBox(height: 10 * responsiveSize / size),

              // Auto-fit text: clamp font theo chiều rộng khả dụng và độ dài label
              Flexible(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: textHPad),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final availableW = constraints.maxWidth;

                      // Estimate font size dựa trên độ dài label và chiều rộng khả dụng
                      final clampedLen = label.length.clamp(6, 24);
                      final estimated = (availableW / clampedLen) * 1.6;

                      // Giới hạn min/max để đồng bộ với hệ responsive hiện có
                      final minFont = 10.0;
                      final maxFont = responsiveFontSize;
                      final font = estimated.clamp(minFont, maxFont);

                      // Letter spacing nhẹ khi font đủ lớn để nhìn cân đối hơn
                      final ls = font >= 14 ? 0.2 : 0.0;

                      return Text(
                        label,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: font.toDouble(),
                          height: 1.2,
                          letterSpacing: ls,
                        ),
                      );
                    },
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
