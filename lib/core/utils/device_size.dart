class DeviceSize {
  /// Tính scale factor dựa trên screen width
  static double getScaleFactor(double screenWidth) {
    if (screenWidth < 350) return 0.7; // Điện thoại rất nhỏ
    if (screenWidth < 400) return 0.8; // Điện thoại nhỏ
    if (screenWidth < 500) return 0.9; // Điện thoại thường
    if (screenWidth < 600) return 1.0; // Điện thoại lớn
    if (screenWidth < 900) return 1.2; // Tablet nhỏ
    if (screenWidth < 1200) return 1.4; // Tablet lớn
    return 1.6; // Desktop
  }

  /// Font size responsive
  static double getResponsiveFontSize(double screenWidth) {
    if (screenWidth < 350) return 10; // Rất nhỏ
    if (screenWidth < 400) return 11; // Nhỏ
    if (screenWidth < 500) return 12; // Thường
    if (screenWidth < 600) return 13; // Lớn
    if (screenWidth < 900) return 14; // Tablet
    if (screenWidth < 1200) return 16; // Tablet lớn
    return 18; // Desktop
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
