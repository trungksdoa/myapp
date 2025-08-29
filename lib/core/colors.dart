import 'package:flutter/material.dart';

/// Utility class chứa tất cả các màu sắc được sử dụng trong ứng dụng
class AppColors {
  // Màu chính (Primary Colors)
  static const Color primary = Color(0xFF2ea19c);
  static const Color primaryLight = Color(0xFF4eb5b0);
  static const Color primaryDark = Color(0xFF1a8f8a);
  static const Color primaryVariant = Color(0xFF0d7a75);

  // Màu phụ (Secondary Colors)
  static const Color secondary = Color(0xFF9c27b0);
  static const Color secondaryLight = Color(0xFFba68c8);
  static const Color secondaryDark = Color(0xFF7b1fa2);
  static const Color secondaryVariant = Color(0xFF6a1b9a);

  // Màu nền (Background Colors)
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color scaffoldBackground = Color(0xFFF8F9FA);

  // Màu văn bản (Text Colors)
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);
  static const Color textDisabled = Color(0xFF9E9E9E);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnSecondary = Color(0xFFFFFFFF);

  // Màu trạng thái (Status Colors)
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFF81C784);
  static const Color successDark = Color(0xFF388E3C);

  static const Color error = Color(0xFFF44336);
  static const Color errorLight = Color(0xFFEF5350);
  static const Color errorDark = Color(0xFFC62828);

  static const Color warning = Color(0xFFFF9800);
  static const Color warningLight = Color(0xFFFFB74D);
  static const Color warningDark = Color(0xFFF57C00);

  static const Color info = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFF64B5F6);
  static const Color infoDark = Color(0xFF1976D2);

  // Màu viền và divider
  static const Color border = Color(0xFFE0E0E0);
  static const Color borderLight = Color(0xFFF0F0F0);
  static const Color divider = Color(0xFFBDBDBD);

  // Màu shadow và elevation
  static const Color shadow = Color(0x1F000000); // 12% opacity black
  static const Color shadowLight = Color(0x0F000000); // 6% opacity black

  // Màu gradient
  static const List<Color> primaryGradient = [primary, primaryLight];

  static const List<Color> secondaryGradient = [secondary, secondaryLight];

  // Màu đặc biệt cho các tính năng cụ thể
  static const Color favorite = Color(0xFFE91E63);
  static const Color favoriteLight = Color(0xFFF48FB1);

  static const Color notification = Color(0xFFFF5722);
  static const Color notificationLight = Color(0xFFFF8A65);

  // Màu cho các icon
  static const Color iconPrimary = textPrimary;
  static const Color iconSecondary = textSecondary;
  static const Color iconDisabled = textDisabled;
  static const Color iconWhite = Color(0xFFFFFFFF);

  // Màu cho các button states
  static const Color buttonPrimary = primary;
  static const Color buttonSecondary = secondary;
  static const Color buttonDisabled = Color(0xFFBDBDBD);
  static const Color buttonPressed = primaryDark;

  // Màu cho input fields
  static const Color inputBorder = border;
  static const Color inputBorderFocused = primary;
  static const Color inputBorderError = error;
  static const Color inputFill = Color(0xFFFAFAFA);

  // Màu cho card states
  static const Color cardHover = Color(0xFFF8F9FA);
  static const Color cardSelected = Color(0xFFE3F2FD);

  // Màu cho navigation
  static const Color navBackground = Color(0xFF2C3E50);
  static const Color navSelected = primary;
  static const Color navUnselected = Color(0xFF95A5A6);

  // Màu cho loading và skeleton
  static const Color loadingBackground = Color(0xFFE0E0E0);
  static const Color skeletonBase = Color(0xFFE0E0E0);
  static const Color skeletonHighlight = Color(0xFFF5F5F5);

  // Màu cho rating stars
  static const Color starActive = Color(0xFFFFC107);
  static const Color starInactive = Color(0xFFE0E0E0);

  // Màu cho các loại thông báo
  static const Color toastSuccess = success;
  static const Color toastError = error;
  static const Color toastWarning = warning;
  static const Color toastInfo = info;

  // Màu cho overlay và modal
  static const Color overlay = Color(0xB3000000); // 70% opacity black
  static const Color modalBarrier = Color(0x99000000); // 60% opacity black

  // Màu cho các theme đặc biệt
  static const Color christmasRed = Color(0xFFD32F2F);
  static const Color christmasGreen = Color(0xFF388E3C);
  static const Color halloweenOrange = Color(0xFFFF8F00);
  static const Color halloweenPurple = Color(0xFF9C27B0);

  // Màu cho branding CareNest
  static const Color careOrange = Color(0xFFFF6E40); // deepOrangeAccent
  static const Color nestWhite = Color(0xFFFFFFFF);

  /// Tạo MaterialColor từ một Color cơ bản
  static MaterialColor createMaterialColor(Color color) {
    List<double> strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }

    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }

    return MaterialColor(color.value, swatch);
  }

  /// Lấy MaterialColor từ primary color
  static MaterialColor get primaryMaterialColor => createMaterialColor(primary);

  /// Lấy MaterialColor từ secondary color
  static MaterialColor get secondaryMaterialColor =>
      createMaterialColor(secondary);

  /// Lấy màu ngẫu nhiên từ danh sách màu có sẵn
  static Color get randomColor {
    final colors = [
      primary,
      secondary,
      success,
      error,
      warning,
      info,
      favorite,
      notification,
    ];
    return colors[DateTime.now().millisecondsSinceEpoch % colors.length];
  }

  /// Lấy màu dựa trên index (có thể dùng cho avatar, tag, etc.)
  static Color getColorByIndex(int index) {
    final colors = [
      primary,
      secondary,
      success,
      warning,
      info,
      favorite,
      Color(0xFF607D8B),
      Color(0xFF795548),
      Color(0xFF8BC34A),
      Color(0xFFCDDC39),
      Color(0xFFFFEB3B),
      Color(0xFFFFC107),
      Color(0xFFFF9800),
      Color(0xFFFF5722),
      Color(0xFFF44336),
      Color(0xFFE91E63),
      Color(0xFF9C27B0),
      Color(0xFF673AB7),
      Color(0xFF3F51B5),
      Color(0xFF2196F3),
      Color(0xFF03A9F4),
      Color(0xFF00BCD4),
      Color(0xFF009688),
      Color(0xFF4CAF50),
      Color(0xFF8BC34A),
      Color(0xFFCDDC39),
    ];
    return colors[index % colors.length];
  }

  /// Kiểm tra xem màu có phải là màu tối không
  static bool isDarkColor(Color color) {
    return color.computeLuminance() < 0.5;
  }

  /// Lấy màu văn bản phù hợp với background color
  static Color getContrastTextColor(Color backgroundColor) {
    return isDarkColor(backgroundColor) ? Colors.white : textPrimary;
  }

  /// Lấy màu với opacity
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }

  /// Blend hai màu với nhau
  static Color blendColors(Color color1, Color color2, double ratio) {
    final r = (color1.red * ratio + color2.red * (1 - ratio)).round();
    final g = (color1.green * ratio + color2.green * (1 - ratio)).round();
    final b = (color1.blue * ratio + color2.blue * (1 - ratio)).round();
    final a = (color1.alpha * ratio + color2.alpha * (1 - ratio)).round();
    return Color.fromARGB(a, r, g, b);
  }
}

/// Extension để thêm các method tiện ích cho Color
extension ColorExtension on Color {
  /// Kiểm tra xem màu có phải là màu tối không
  bool get isDark => AppColors.isDarkColor(this);

  /// Lấy màu văn bản tương phản
  Color get contrastText => AppColors.getContrastTextColor(this);

  /// Tạo MaterialColor từ Color hiện tại
  MaterialColor get asMaterialColor => AppColors.createMaterialColor(this);

  /// Lấy màu với opacity
  Color withOpacityValue(double opacity) =>
      AppColors.withOpacity(this, opacity);

  /// Blend với màu khác
  Color blendWith(Color other, double ratio) =>
      AppColors.blendColors(this, other, ratio);
}

/// Theme data cho ứng dụng
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primary,
      primaryColorLight: AppColors.primaryLight,
      primaryColorDark: AppColors.primaryDark,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        error: AppColors.error,
        onPrimary: AppColors.textOnPrimary,
        onSecondary: AppColors.textOnSecondary,
        onSurface: AppColors.textPrimary,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.scaffoldBackground,
      cardColor: AppColors.cardBackground,
      dividerColor: AppColors.divider,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.textPrimary),
        bodyMedium: TextStyle(color: AppColors.textPrimary),
        bodySmall: TextStyle(color: AppColors.textSecondary),
        labelLarge: TextStyle(color: AppColors.textPrimary),
        labelMedium: TextStyle(color: AppColors.textSecondary),
        labelSmall: TextStyle(color: AppColors.textHint),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.inputBorder),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.inputBorderFocused),
          borderRadius: BorderRadius.circular(8),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.inputBorderError),
          borderRadius: BorderRadius.circular(8),
        ),
        fillColor: AppColors.inputFill,
        filled: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonPrimary,
          foregroundColor: AppColors.textOnPrimary,
          disabledBackgroundColor: AppColors.buttonDisabled,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.primary),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      primaryColor: AppColors.primary,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: Color(0xFF1E1E1E),
        error: AppColors.error,
        onPrimary: AppColors.textOnPrimary,
        onSecondary: AppColors.textOnSecondary,
        onSurface: Colors.white,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      cardColor: const Color(0xFF1E1E1E),
      dividerColor: const Color(0xFF333333),
    );
  }
}
