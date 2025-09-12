import 'package:flutter/material.dart';

class NotificationUtils {
  // Phương thức cơ bản - chỉ hiển thị message
  static void showNotification(BuildContext context, String message) {
    SnackBar snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(16),
      backgroundColor: Colors.black87,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Phương thức với action - sử dụng named parameters
  static void showNotificationWithAction(
    BuildContext context,
    String message, {
    String actionLabel = 'Undo',
    required Function() onPressed,
    Color actionTextColor = Colors.yellow,
  }) {
    SnackBar snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(16),
      backgroundColor: Colors.black87,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      action: SnackBarAction(
        label: actionLabel,
        textColor: actionTextColor,
        onPressed: onPressed,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Phương thức với nhiều tùy chọn - sử dụng optional parameters
  static void showCustomNotification(
    BuildContext context,
    String message, {
    Duration? duration,
    Color? backgroundColor,
    bool? showAction,
    String? actionLabel,
    Function()? onActionPressed,
    Color? actionTextColor,
  }) {
    SnackBar snackBar = SnackBar(
      content: Text(message),
      duration: duration ?? Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(16),
      backgroundColor: backgroundColor ?? Colors.black87,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      action: (showAction ?? false)
          ? SnackBarAction(
              label: actionLabel ?? 'Action',
              textColor: actionTextColor ?? Colors.yellow,
              onPressed: onActionPressed ?? () {},
            )
          : null,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void hideCurrentNotification(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }
}
