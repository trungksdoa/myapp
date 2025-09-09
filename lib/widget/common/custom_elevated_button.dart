import 'package:flutter/material.dart';

/// Custom elevated button with comprehensive styling options and predefined styles.
/// Supports loading states, icons, and various factory constructors for common button types.
/// Optimized for consistent button appearance across the app with customizable properties.
///
/// Includes support for elevation, borders, padding, and text styling.
class CustomElevatedButton extends StatelessWidget {
  /// The text content displayed on the button.
  final String text;

  /// Callback function executed when the button is pressed.
  final VoidCallback? onPressed;

  /// The background color of the button.
  final Color? backgroundColor;

  /// The text color of the button text.
  final Color? textColor;

  /// Font size of the button text.
  final double? fontSize;

  /// Font weight of the button text.
  final FontWeight? fontWeight;

  /// Padding around the button content.
  final EdgeInsetsGeometry? padding;

  /// Border radius of the button corners.
  final double borderRadius;

  /// Whether to show a loading spinner instead of text.
  final bool isLoading;

  /// Icon widget to display before the text.
  final Widget? icon;

  /// Fixed width of the button container.
  final double? width;

  /// Fixed height of the button container.
  final double? height;

  /// Custom shape for the button border.
  final OutlinedBorder? shape;

  /// Creates a customizable elevated button.
  ///
  /// [text] must not be null and represents the button label.
  /// All other parameters are optional with sensible defaults.
  const CustomElevatedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.padding,
    this.borderRadius = 8.0,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height,
    this.shape,
  });

  /// Creates a primary button with teal background and stadium border.
  ///
  /// Pre-configured with:
  /// - Color: Colors.teal background, Colors.white text
  /// - Size: fontSize: 16, fontWeight: FontWeight.bold
  /// - Shape: StadiumBorder with borderRadius: 20
  /// - Padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24)
  ///
  /// Perfect for main actions and call-to-action buttons.
  factory CustomElevatedButton.primary({
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
    Widget? icon,
    double? width,
  }) {
    return CustomElevatedButton(
      text: text,
      onPressed: onPressed,
      backgroundColor: Colors.teal,
      textColor: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.bold,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      borderRadius: 20,
      isLoading: isLoading,
      icon: icon,
      width: width,
      shape: const StadiumBorder(),
    );
  }

  /// Creates a secondary button with gray background.
  ///
  /// Pre-configured with:
  /// - Color: Colors.grey[200] background, Colors.black87 text
  /// - Size: fontSize: 14, fontWeight: FontWeight.w600
  /// - Padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20)
  /// - Radius: borderRadius: 12
  ///
  /// Ideal for secondary actions and less prominent functions.
  factory CustomElevatedButton.secondary({
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
    Widget? icon,
    double? width,
  }) {
    return CustomElevatedButton(
      text: text,
      onPressed: onPressed,
      backgroundColor: Colors.grey.shade200,
      textColor: Colors.black87,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      borderRadius: 12,
      isLoading: isLoading,
      icon: icon,
      width: width,
    );
  }

  /// Creates a full-width login button with enhanced padding.
  ///
  /// Pre-configured with:
  /// - Color: Colors.teal background, Colors.white text
  /// - Size: fontSize: 16, fontWeight: FontWeight.bold
  /// - Width: double.infinity (full width)
  /// - Padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24)
  /// - Radius: borderRadius: 12
  ///
  /// Optimized for authentication screens and forms.
  factory CustomElevatedButton.login({
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return CustomElevatedButton(
      text: text,
      onPressed: onPressed,
      backgroundColor: Colors.teal,
      textColor: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.bold,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      borderRadius: 12,
      isLoading: isLoading,
      width: double.infinity,
    );
  }

  /// Creates a compact save button optimized for app bars.
  ///
  /// Pre-configured with:
  /// - Color: Colors.teal background, Colors.white text
  /// - Size: fontSize: 14, fontWeight: FontWeight.w600
  /// - Shape: StadiumBorder with borderRadius: 20
  /// - Padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20)
  ///
  /// Perfect for save actions in app bars and toolbars.
  factory CustomElevatedButton.appBarSave({
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return CustomElevatedButton(
      text: text,
      onPressed: onPressed,
      backgroundColor: Colors.teal,
      textColor: Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      borderRadius: 20,
      isLoading: isLoading,
      shape: const StadiumBorder(),
    );
  }

  /// Builds the CustomElevatedButton widget.
  ///
  /// Returns an ElevatedButton with the specified styling and optional loading state.
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Colors.teal,
          foregroundColor: textColor ?? Colors.white,
          padding:
              padding ??
              const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          shape:
              shape ??
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
          elevation: 2,
          disabledBackgroundColor: Colors.grey.shade300,
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    textColor ?? Colors.white,
                  ),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[icon!, const SizedBox(width: 8)],
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: fontSize ?? 16,
                      fontWeight: fontWeight ?? FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
