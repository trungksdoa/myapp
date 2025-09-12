import 'package:flutter/material.dart';
import 'package:myapp/shared/index.dart';

/// A collection of commonly used widget utilities and components.
/// Provides static methods for creating consistent UI elements across the app,
/// including avatars, ratings, icons, loading states, error states, and more.
class CommonWidgets {
  /// Creates a widget displaying an avatar image with an associated name.
  ///
  /// Displays a circular avatar image alongside the name in a row layout.
  /// Useful for user profiles, comments, and member lists.
  ///
  /// [imageUrl] must not be null and should be a valid asset image path.
  /// [name] must not be null and will be displayed next to the avatar.
  static Widget avatarWithName({
    required String imageUrl,
    required String name,
    double avatarRadius = 20,
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w500,
    Color? textColor,
    Widget? fallbackIcon,
  }) {
    return Row(
      children: [
        CircleAvatar(
          radius: avatarRadius,
          backgroundImage: AssetImage(imageUrl),
          backgroundColor: Colors.grey.shade300,
          child: fallbackIcon,
        ),
        AppSpacing.horizontalMD,
        Text(
          name,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: textColor ?? Colors.black87,
          ),
        ),
      ],
    );
  }

  /// Creates a row of star icons representing a rating.
  ///
  /// Displays filled stars for the rated portion and outlined stars for the remainder.
  /// Useful for displaying ratings, reviews, and feedback scores.
  ///
  /// [rating] should be between 0 and [totalStars], defaults to 5.
  /// [totalStars] defines the maximum number of stars to display, defaults to 5.
  static Widget starRating({
    int rating = 5,
    int totalStars = 5,
    double size = 16,
    Color activeColor = Colors.amber,
    Color inactiveColor = Colors.grey,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        totalStars,
        (index) => Icon(
          Icons.star,
          color: index < rating ? activeColor : inactiveColor,
          size: size,
        ),
      ),
    );
  }

  /// Creates a widget displaying an icon alongside text.
  ///
  /// Arranges the icon and text in a row with consistent spacing.
  /// Commonly used for menu items, buttons, and feature descriptions.
  ///
  /// [icon] must not be null and will be displayed before the text.
  /// [text] must not be null and will be displayed after the icon.
  static Widget iconWithText({
    required IconData icon,
    required String text,
    double iconSize = 16,
    double fontSize = 14,
    Color? iconColor,
    Color? textColor,
    MainAxisAlignment alignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAlignment = CrossAxisAlignment.center,
  }) {
    return Row(
      mainAxisAlignment: alignment,
      crossAxisAlignment: crossAlignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: iconSize, color: iconColor ?? Colors.grey.shade600),
        AppSpacing.horizontalSM,
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            color: textColor ?? Colors.black87,
          ),
        ),
      ],
    );
  }

  /// Creates a loading indicator with optional message text.
  ///
  /// Displays a circular progress indicator, optionally with descriptive text below.
  /// Used during async operations and data loading states.
  ///
  /// [message] is optional and will be displayed below the loading indicator.
  static Widget loading({String? message, double size = 24, Color? color}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(color ?? Colors.teal),
          ),
        ),
        if (message != null) ...[
          AppSpacing.verticalSM,
          CustomText.caption(text: message, color: Colors.grey.shade600),
          // Text(
          //   message,
          //   style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          // ),
        ],
      ],
    );
  }

  /// Creates an empty state widget for when there's no content to display.
  ///
  /// Displays an icon, title, optional subtitle, and optional action button.
  /// Perfect for empty lists, search results, or data loading failures.
  ///
  /// [icon] must not be null and represents the empty state visually.
  /// [title] must not be null and provides the main message.
  static Widget emptyState({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? action,
    double iconSize = 64,
    Color? iconColor,
  }) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: iconSize, color: iconColor ?? Colors.grey.shade400),
          AppSpacing.verticalLG,
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
            textAlign: TextAlign.center,
          ),
          if (subtitle != null) ...[
            AppSpacing.verticalSM,
            Text(
              subtitle,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
              textAlign: TextAlign.center,
            ),
          ],
          if (action != null) ...[AppSpacing.verticalXL, action],
        ],
      ),
    );
  }

  /// Creates an error state widget with retry capability.
  ///
  /// Displays an error icon, message, and optional retry button.
  /// Used when operations fail and user might want to retry.
  ///
  /// [message] must not be null and describes the error.
  static Widget errorState({
    required String message,
    VoidCallback? onRetry,
    IconData icon = Icons.error_outline,
    Color? iconColor,
  }) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 64, color: iconColor ?? Colors.red.shade400),
          AppSpacing.verticalLG,
          Text(
            'Đã xảy ra lỗi',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.red.shade700,
            ),
            textAlign: TextAlign.center,
          ),
          AppSpacing.verticalSM,
          Text(
            message,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            AppSpacing.verticalXL,
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Thử lại'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Creates a tag/label widget with customizable styling.
  ///
  /// Displays text in a rounded container with background color.
  /// Commonly used for categories, tags, badges, and status indicators.
  ///
  /// [text] must not be null and represents the tag content.
  static Widget tag({
    required String text,
    Color? backgroundColor,
    Color? textColor,
    double borderRadius = 16,
    EdgeInsetsGeometry? padding,
  }) {
    return Container(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.teal.shade100,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textColor ?? Colors.teal.shade700,
        ),
      ),
    );
  }

  /// Creates a circular badge widget for displaying small amounts of information.
  ///
  /// Displays text in a circular container, useful for notifications,
  /// counters, and status indicators.
  ///
  /// [text] must not be null and represents the badge content.
  static Widget badge({
    required String text,
    Color? backgroundColor,
    Color? textColor,
    double? size,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.red,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: (size ?? 20) * 0.5,
            fontWeight: FontWeight.bold,
            color: textColor ?? Colors.white,
          ),
        ),
      ),
    );
  }

  /// Creates a chat input widget with send button.
  ///
  /// Provides a text field and send button for chat functionality.
  /// Includes prefix icon support and customizable appearance.
  ///
  /// [controller] must not be null and manages the text input.
  /// [onSend] must not be null and is called when send button is pressed.
  static Widget chatInput({
    required TextEditingController controller,
    required VoidCallback onSend,
    String? hintText,
    Widget? prefixIcon,
    bool enabled = true,
  }) {
    return Container(
      padding: AppPadding.lg,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (prefixIcon != null) ...[prefixIcon, AppSpacing.horizontalMD],
          Expanded(
            child: TextField(
              controller: controller,
              enabled: enabled,
              decoration: InputDecoration(
                hintText: hintText ?? 'Nhập tin nhắn...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: Colors.teal),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          AppSpacing.horizontalMD,
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.teal,
            child: IconButton(
              onPressed: enabled ? onSend : null,
              icon: const Icon(Icons.send, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  /// Creates a divider with text in the center.
  ///
  /// Displays horizontal lines with text positioned in the middle.
  /// Useful for section separators and content organization.
  ///
  /// [text] must not be null and will be displayed between the divider lines.
  static Widget dividerWithText({
    required String text,
    Color? textColor,
    Color? lineColor,
    double thickness = 1,
  }) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: lineColor ?? Colors.grey.shade300,
            thickness: thickness,
          ),
        ),
        Padding(
          padding: AppPadding.horizontalMD,
          child: Text(
            text,
            style: TextStyle(
              color: textColor ?? Colors.grey.shade600,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: lineColor ?? Colors.grey.shade300,
            thickness: thickness,
          ),
        ),
      ],
    );
  }
}
