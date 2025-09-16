import 'package:flutter/material.dart';

/// Font types for different text elements
enum FontType { title, subtitle, body, caption }

class DeviceSize {
  /// Calculate scale factor based on screen width
  static double getScaleFactor(double screenWidth) {
    if (screenWidth < 350) return 0.85; // Very small phones
    if (screenWidth < 400) return 0.95; // Small phones
    if (screenWidth < 500) return 1.0; // Normal phones
    if (screenWidth < 600) return 1.1; // Large phones
    if (screenWidth < 900) return 1.2; // Tablets
    if (screenWidth < 1200) return 1.3; // Large tablets
    return 1.4; // Desktop
  }

  static double calculateHeight(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final availableHeight =
        screenHeight -
        mediaQuery.viewPadding.top -
        mediaQuery.viewPadding.bottom;

    // Base percentage
    double basePercentage = 0.2;

    // Adjust percentage based on screen size
    if (screenHeight < 700) {
      basePercentage = 0.25; // More space on small screens
    } else if (screenHeight > 1000) {
      basePercentage = 0.18; // Less percentage but still larger absolute value
    }

    double calculatedHeight = availableHeight * basePercentage;

    // Dynamic constraints
    double minHeight = screenHeight * 0.15; // 15% minimum
    double maxHeight = screenHeight * 0.3; // 30% maximum

    return calculatedHeight.clamp(minHeight, maxHeight);
  }

  static double getResponsiveImage(double screenWidth) {
    if (screenWidth < 350) return 40; // Rất nhỏ
    if (screenWidth < 400) return 50; // Nhỏ
    if (screenWidth < 500) return 60; // Thường
    if (screenWidth < 600) return 70; // Lớn
    if (screenWidth < 900) return 80; // Tablet
    if (screenWidth < 1200) return 90; // Tablet lớn
    return 100; // Desktop
  }

  /// Font size responsive with scale factor
  static double getResponsiveFontSize(double screenWidth) {
    // Base font sizes for different text types
    const baseSizeNormal = 14.0;

    // Get scale factor based on screen width
    double scaleFactor = getScaleFactor(screenWidth);

    // Calculate responsive font size with minimum and maximum bounds
    double responsiveSize = baseSizeNormal * scaleFactor;

    // Ensure font size stays within reasonable bounds
    return responsiveSize.clamp(12.0, 24.0);
  }

  /// Get specific font size for different text types
  static double getSpecificFontSize(
    double screenWidth, {
    required FontType type,
    double customScale = 1.0,
  }) {
    double baseSize = getResponsiveFontSize(screenWidth);

    switch (type) {
      case FontType.title:
        return (baseSize * 1.5 * customScale).clamp(16.0, 32.0);
      case FontType.subtitle:
        return (baseSize * 1.25 * customScale).clamp(14.0, 28.0);
      case FontType.body:
        return (baseSize * customScale).clamp(12.0, 24.0);
      case FontType.caption:
        return (baseSize * 0.85 * customScale).clamp(10.0, 20.0);
    }
  }

  /// Padding responsive
  static double getResponsivePadding(double screenWidth) {
    if (screenWidth < 350) return 4; // Rất nhỏ
    if (screenWidth < 400) return 6; // Nhỏ
    if (screenWidth < 500) return 8; // Thường
    if (screenWidth < 600) return 10; // Lớn
    if (screenWidth < 900) return 12; // Tablet
    if (screenWidth < 1200) return 14; // Tablet lớn
    return 16; // Desktop
  }

  /// Border radius responsive
  static double getResponsiveBorderRadius(double screenWidth) {
    if (screenWidth < 350) return 8; // Rất nhỏ
    if (screenWidth < 400) return 10; // Nhỏ
    if (screenWidth < 500) return 12; // Thường
    if (screenWidth < 600) return 14; // Lớn
    if (screenWidth < 900) return 16; // Tablet
    if (screenWidth < 1200) return 18; // Tablet lớn
    return 20; // Desktop
  }
}
