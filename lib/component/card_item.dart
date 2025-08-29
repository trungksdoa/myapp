import 'package:flutter/material.dart';
import 'package:myapp/core/colors.dart';
import 'package:myapp/core/utils/device_size.dart';

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

    return GestureDetector(
      onTap: onTap,
      child: Container(
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
              // Auto-scale image
              Flexible(
                flex: 3,
                child: Image.asset(
                  assetIcon,
                  width: responsiveSize,
                  height: responsiveSize,
                  fit: BoxFit.contain,
                ),
              ),

              // Responsive spacing
              SizedBox(height: 10 * responsiveSize / size),

              // Auto-scale text
              Flexible(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsivePadding * 0.5,
                  ),
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: responsiveFontSize,
                      height: 1.2, // Line height
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
