import 'package:flutter/material.dart';

/// Standardized spacing constants for consistent layout throughout the app.
/// Provides predefined spacing values and utility widgets for quick implementation.
/// Values are measured in logical pixels and follow a consistent scale.
///
/// Usage:
/// - AppSpacing.verticalMD for vertical spacing
/// - AppSpacing.horizontalSM for horizontal spacing
/// - AppSpacing.space to create custom spacing
class AppSpacing {
  /// Extra small spacing: 4.0 dp - for fine-grained spacing
  static const double xs = 4.0;

  /// Small spacing: 8.0 dp - for compact layouts
  static const double sm = 8.0;

  /// Medium spacing: 12.0 dp - default spacing for most UI elements
  static const double md = 12.0;

  /// Large spacing: 16.0 dp - for comfortable separation
  static const double lg = 16.0;

  /// Extra large spacing: 20.0 dp - for card margins and major sections
  static const double xl = 20.0;

  /// Double extra large spacing: 24.0 dp - for prominent separation
  static const double xxl = 24.0;

  /// Triple extra large spacing: 32.0 dp - for page margins and headers
  static const double xxxl = 32.0;

  /// Square spacing widget: height: xs (4.0), width: xs (4.0)
  static const Widget spaceXS = SizedBox(height: xs, width: xs);

  /// Square spacing widget: height: sm (8.0), width: sm (8.0)
  static const Widget spaceSM = SizedBox(height: sm, width: sm);

  /// Square spacing widget: height: md (12.0), width: md (12.0)
  static const Widget spaceMD = SizedBox(height: md, width: md);

  /// Square spacing widget: height: lg (16.0), width: lg (16.0)
  static const Widget spaceLG = SizedBox(height: lg, width: lg);

  /// Square spacing widget: height: xl (20.0), width: xl (20.0)
  static const Widget spaceXL = SizedBox(height: xl, width: xl);

  /// Square spacing widget: height: xxl (24.0), width: xxl (24.0)
  static const Widget spaceXXL = SizedBox(height: xxl, width: xxl);

  /// Square spacing widget: height: xxxl (32.0), width: xxxl (32.0)
  static const Widget spaceXXXL = SizedBox(height: xxxl, width: xxxl);

  /// Vertical spacing widget: height: xs (4.0)
  static const Widget verticalXS = SizedBox(height: xs);

  /// Vertical spacing widget: height: sm (8.0)
  static const Widget verticalSM = SizedBox(height: sm);

  /// Vertical spacing widget: height: md (12.0)
  static const Widget verticalMD = SizedBox(height: md);

  /// Vertical spacing widget: height: lg (16.0)
  static const Widget verticalLG = SizedBox(height: lg);

  /// Vertical spacing widget: height: xl (20.0)
  static const Widget verticalXL = SizedBox(height: xl);

  /// Vertical spacing widget: height: xxl (24.0)
  static const Widget verticalXXL = SizedBox(height: xxl);

  /// Vertical spacing widget: height: xxxl (32.0)
  static const Widget verticalXXXL = SizedBox(height: xxxl);

  /// Horizontal spacing widget: width: xs (4.0)
  static const Widget horizontalXS = SizedBox(width: xs);

  /// Horizontal spacing widget: width: sm (8.0)
  static const Widget horizontalSM = SizedBox(width: sm);

  /// Horizontal spacing widget: width: md (12.0)
  static const Widget horizontalMD = SizedBox(width: md);

  /// Horizontal spacing widget: width: lg (16.0)
  static const Widget horizontalLG = SizedBox(width: lg);

  /// Horizontal spacing widget: width: xl (20.0)
  static const Widget horizontalXL = SizedBox(width: xl);

  /// Horizontal spacing widget: width: xxl (24.0)
  static const Widget horizontalXXL = SizedBox(width: xxl);

  /// Horizontal spacing widget: width: xxxl (32.0)
  static const Widget horizontalXXXL = SizedBox(width: xxxl);

  /// Creates custom vertical spacing with specified height.
  ///
  /// [height] the vertical spacing value in logical pixels.
  static SizedBox vertical(double height) => SizedBox(height: height);

  /// Creates custom horizontal spacing with specified width.
  ///
  /// [width] the horizontal spacing value in logical pixels.
  static SizedBox horizontal(double width) => SizedBox(width: width);

  /// Creates custom spacing with specified width and height.
  ///
  /// [width] the horizontal spacing value in logical pixels.
  /// [height] the vertical spacing value in logical pixels.
  static SizedBox custom(double width, double height) =>
      SizedBox(width: width, height: height);
}

class AppPadding {
  /// All-direction padding: value = xs (4.0 dp)
  static const EdgeInsets xs = EdgeInsets.all(AppSpacing.xs);

  /// All-direction padding: value = sm (8.0 dp)
  static const EdgeInsets sm = EdgeInsets.all(AppSpacing.sm);

  /// All-direction padding: value = md (12.0 dp)
  static const EdgeInsets md = EdgeInsets.all(AppSpacing.md);

  /// All-direction padding: value = lg (16.0 dp)
  static const EdgeInsets lg = EdgeInsets.all(AppSpacing.lg);

  /// All-direction padding: value = xl (20.0 dp)
  static const EdgeInsets xl = EdgeInsets.all(AppSpacing.xl);

  /// All-direction padding: value = xxl (24.0 dp)
  static const EdgeInsets xxl = EdgeInsets.all(AppSpacing.xxl);

  /// All-direction padding: value = xxxl (32.0 dp)
  static const EdgeInsets xxxl = EdgeInsets.all(AppSpacing.xxxl);

  /// Symmetric padding: horizontal: xs (4.0), vertical: xs (4.0)
  static const EdgeInsets symmetricXS = EdgeInsets.symmetric(
    horizontal: AppSpacing.xs,
    vertical: AppSpacing.xs,
  );

  /// Symmetric padding: horizontal: sm (8.0), vertical: sm (8.0)
  static const EdgeInsets symmetricSM = EdgeInsets.symmetric(
    horizontal: AppSpacing.sm,
    vertical: AppSpacing.sm,
  );

  /// Symmetric padding: horizontal: md (12.0), vertical: md (12.0)
  static const EdgeInsets symmetricMD = EdgeInsets.symmetric(
    horizontal: AppSpacing.md,
    vertical: AppSpacing.md,
  );

  /// Symmetric padding: horizontal: lg (16.0), vertical: lg (16.0)
  static const EdgeInsets symmetricLG = EdgeInsets.symmetric(
    horizontal: AppSpacing.lg,
    vertical: AppSpacing.lg,
  );

  /// Symmetric padding: horizontal: xl (20.0), vertical: xl (20.0)
  static const EdgeInsets symmetricXL = EdgeInsets.symmetric(
    horizontal: AppSpacing.xl,
    vertical: AppSpacing.xl,
  );

  /// Horizontal-only padding: horizontal: xs (4.0)
  static const EdgeInsets horizontalXS = EdgeInsets.symmetric(
    horizontal: AppSpacing.xs,
  );

  /// Horizontal-only padding: horizontal: sm (8.0)
  static const EdgeInsets horizontalSM = EdgeInsets.symmetric(
    horizontal: AppSpacing.sm,
  );

  /// Horizontal-only padding: horizontal: md (12.0)
  static const EdgeInsets horizontalMD = EdgeInsets.symmetric(
    horizontal: AppSpacing.md,
  );

  /// Horizontal-only padding: horizontal: lg (16.0)
  static const EdgeInsets horizontalLG = EdgeInsets.symmetric(
    horizontal: AppSpacing.lg,
  );

  /// Horizontal-only padding: horizontal: xl (20.0)
  static const EdgeInsets horizontalXL = EdgeInsets.symmetric(
    horizontal: AppSpacing.xl,
  );

  /// Horizontal-only padding: horizontal: xxl (24.0)
  static const EdgeInsets horizontalXXL = EdgeInsets.symmetric(
    horizontal: AppSpacing.xxl,
  );

  /// Vertical-only padding: vertical: xs (4.0)
  static const EdgeInsets verticalXS = EdgeInsets.symmetric(
    vertical: AppSpacing.xs,
  );

  /// Vertical-only padding: vertical: sm (8.0)
  static const EdgeInsets verticalSM = EdgeInsets.symmetric(
    vertical: AppSpacing.sm,
  );

  /// Vertical-only padding: vertical: md (12.0)
  static const EdgeInsets verticalMD = EdgeInsets.symmetric(
    vertical: AppSpacing.md,
  );

  /// Vertical-only padding: vertical: lg (16.0)
  static const EdgeInsets verticalLG = EdgeInsets.symmetric(
    vertical: AppSpacing.lg,
  );

  /// Vertical-only padding: vertical: xl (20.0)
  static const EdgeInsets verticalXL = EdgeInsets.symmetric(
    vertical: AppSpacing.xl,
  );

  /// Vertical-only padding: vertical: xxl (24.0)
  static const EdgeInsets verticalXXL = EdgeInsets.symmetric(
    vertical: AppSpacing.xxl,
  );

  /// Standard page padding: all sides = lg (16.0)
  static const EdgeInsets page = EdgeInsets.all(AppSpacing.lg);

  /// Page horizontal padding: horizontal = lg (16.0)
  static const EdgeInsets pageHorizontal = EdgeInsets.symmetric(
    horizontal: AppSpacing.lg,
  );

  /// Page vertical padding: vertical = lg (16.0)
  static const EdgeInsets pageVertical = EdgeInsets.symmetric(
    vertical: AppSpacing.lg,
  );

  /// Standard card padding: all sides = lg (16.0)
  static const EdgeInsets card = EdgeInsets.all(AppSpacing.lg);

  /// Small card padding: all sides = md (12.0)
  static const EdgeInsets cardSmall = EdgeInsets.all(AppSpacing.md);

  /// Large card padding: all sides = xl (20.0)
  static const EdgeInsets cardLarge = EdgeInsets.all(AppSpacing.xl);

  /// Standard button padding: horizontal = xl (20.0), vertical = md (12.0)
  static const EdgeInsets button = EdgeInsets.symmetric(
    horizontal: AppSpacing.xl,
    vertical: AppSpacing.md,
  );

  /// Small button padding: horizontal = lg (16.0), vertical = sm (8.0)
  static const EdgeInsets buttonSmall = EdgeInsets.symmetric(
    horizontal: AppSpacing.lg,
    vertical: AppSpacing.sm,
  );

  /// Large button padding: horizontal = xxl (24.0), vertical = lg (16.0)
  static const EdgeInsets buttonLarge = EdgeInsets.symmetric(
    horizontal: AppSpacing.xxl,
    vertical: AppSpacing.lg,
  );

  /// Standard input field padding: horizontal = lg (16.0), vertical = lg (16.0)
  static const EdgeInsets inputField = EdgeInsets.symmetric(
    horizontal: AppSpacing.lg,
    vertical: AppSpacing.lg,
  );

  /// Small input field padding: horizontal = md (12.0), vertical = md (12.0)
  static const EdgeInsets inputFieldSmall = EdgeInsets.symmetric(
    horizontal: AppSpacing.md,
    vertical: AppSpacing.md,
  );

  /// Creates uniform padding on all sides with the specified value.
  ///
  /// [value] the padding value for all sides in logical pixels.
  static EdgeInsets all(double value) => EdgeInsets.all(value);

  /// Creates symmetric padding with horizontal and vertical values.
  ///
  /// [horizontal] padding for left and right sides (default: 0).
  /// [vertical] padding for top and bottom sides (default: 0).
  static EdgeInsets symmetric({double horizontal = 0, double vertical = 0}) =>
      EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);

  /// Creates padding for specific sides with individual values.
  ///
  /// All parameters are optional and default to 0.
  static EdgeInsets only({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) => EdgeInsets.only(left: left, top: top, right: right, bottom: bottom);
}

class AppMargin {
  /// All-direction margin: value = xs (4.0 dp)
  static const EdgeInsets xs = EdgeInsets.all(AppSpacing.xs);

  /// All-direction margin: value = sm (8.0 dp)
  static const EdgeInsets sm = EdgeInsets.all(AppSpacing.sm);

  /// All-direction margin: value = md (12.0 dp)
  static const EdgeInsets md = EdgeInsets.all(AppSpacing.md);

  /// All-direction margin: value = lg (16.0 dp)
  static const EdgeInsets lg = EdgeInsets.all(AppSpacing.lg);

  /// All-direction margin: value = xl (20.0 dp)
  static const EdgeInsets xl = EdgeInsets.all(AppSpacing.xl);

  /// All-direction margin: value = xxl (24.0 dp)
  static const EdgeInsets xxl = EdgeInsets.all(AppSpacing.xxl);

  /// Symmetric margin: horizontal: xs (4.0), vertical: xs (4.0)
  static const EdgeInsets symmetricXS = EdgeInsets.symmetric(
    horizontal: AppSpacing.xs,
    vertical: AppSpacing.xs,
  );
  static const EdgeInsets symmetricSM = EdgeInsets.symmetric(
    horizontal: AppSpacing.sm,
    vertical: AppSpacing.sm,
  );
  static const EdgeInsets symmetricMD = EdgeInsets.symmetric(
    horizontal: AppSpacing.md,
    vertical: AppSpacing.md,
  );
  static const EdgeInsets symmetricLG = EdgeInsets.symmetric(
    horizontal: AppSpacing.lg,
    vertical: AppSpacing.lg,
  );

  // Horizontal margin
  static const EdgeInsets horizontalXS = EdgeInsets.symmetric(
    horizontal: AppSpacing.xs,
  );
  static const EdgeInsets horizontalSM = EdgeInsets.symmetric(
    horizontal: AppSpacing.sm,
  );
  static const EdgeInsets horizontalMD = EdgeInsets.symmetric(
    horizontal: AppSpacing.md,
  );
  static const EdgeInsets horizontalLG = EdgeInsets.symmetric(
    horizontal: AppSpacing.lg,
  );
  static const EdgeInsets horizontalXL = EdgeInsets.symmetric(
    horizontal: AppSpacing.xl,
  );

  // Vertical margin
  static const EdgeInsets verticalXS = EdgeInsets.symmetric(
    vertical: AppSpacing.xs,
  );
  static const EdgeInsets verticalSM = EdgeInsets.symmetric(
    vertical: AppSpacing.sm,
  );
  static const EdgeInsets verticalMD = EdgeInsets.symmetric(
    vertical: AppSpacing.md,
  );
  static const EdgeInsets verticalLG = EdgeInsets.symmetric(
    vertical: AppSpacing.lg,
  );
  static const EdgeInsets verticalXL = EdgeInsets.symmetric(
    vertical: AppSpacing.xl,
  );

  /// Standard card margin: all sides = md (12.0 dp)
  static const EdgeInsets card = EdgeInsets.all(AppSpacing.md);

  /// Card vertical margin: vertical = sm (8.0 dp)
  static const EdgeInsets cardVertical = EdgeInsets.symmetric(
    vertical: AppSpacing.sm,
  );

  /// Card horizontal margin: horizontal = lg (16.0 dp)
  static const EdgeInsets cardHorizontal = EdgeInsets.symmetric(
    horizontal: AppSpacing.lg,
  );

  /// Creates uniform margin on all sides with the specified value.
  ///
  /// [value] the margin value for all sides in logical pixels.
  static EdgeInsets all(double value) => EdgeInsets.all(value);

  /// Creates symmetric margin with horizontal and vertical values.
  ///
  /// [horizontal] margin for left and right sides (default: 0).
  /// [vertical] margin for top and bottom sides (default: 0).
  static EdgeInsets symmetric({double horizontal = 0, double vertical = 0}) =>
      EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);

  /// Creates margin for specific sides with individual values.
  ///
  /// All parameters are optional and default to 0.
  static EdgeInsets only({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) => EdgeInsets.only(left: left, top: top, right: right, bottom: bottom);
}
