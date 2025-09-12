import 'package:flutter/material.dart';
import 'package:myapp/core/colors.dart';
import 'package:myapp/route/navigate_helper.dart';

/// A customizable dialog widget with predefined styles for common use cases.
/// Provides factory constructors for success, error, and delete confirmation dialogs.
/// Includes static methods for easy dialog displaying without creating instances.
///
/// This widget extends AlertDialog and provides consistent styling across the app
/// with support for icons, colors, and callback functions.
class CustomDialog extends StatelessWidget {
  /// The title of the dialog (optional).
  /// If null, no title will be displayed.
  final String? alertTile;

  /// The main content text to display in the dialog.
  /// This is typically a message explaining the purpose of the dialog.
  final String content;

  /// The text displayed on the action button.
  /// Defaults to 'Tôi đã hiểu' if not specified.
  final String buttonText;

  /// The icon to display at the top of the dialog.
  /// If null, no icon will be shown.
  final IconData? iconData;

  /// The color of the icon.
  /// If null, the default color will be used.
  final Color? iconColor;

  /// Callback function executed when the button is pressed.
  /// If null, the dialog will be dismissed automatically.
  final void Function()? onButtonPressed;

  /// Creates a customizable dialog widget.
  ///
  /// [content] must not be null and should provide context for the dialog.
  ///
  /// Example:
  /// ```dart
  /// CustomDialog(
  ///   content: 'Are you sure you want to delete this item?',
  ///   buttonText: 'Delete',
  ///   iconData: Icons.warning,
  ///   iconColor: Colors.red,
  ///   onButtonPressed: () => deleteItem(),
  /// )
  /// ```
  const CustomDialog({
    super.key,
    this.alertTile,
    required this.content,
    this.buttonText = 'Tôi đã hiểu',
    this.iconData,
    this.iconColor,
    this.onButtonPressed,
  });

  /// Creates a success dialog with green check icon.
  ///
  /// Pre-configured for success messages with appropriate styling.
  ///
  /// [content] must not be null.
  factory CustomDialog.success({
    required String content,
    String buttonText = 'Tôi đã hiểu',
  }) {
    return CustomDialog(
      content: content,
      buttonText: buttonText,
      iconData: Icons.check,
      iconColor: Colors.green,
    );
  }

  /// Creates an error dialog with red error icon.
  ///
  /// Pre-configured for error messages with appropriate styling.
  ///
  /// [content] must not be null.
  factory CustomDialog.error({
    required String content,
    String buttonText = 'Tôi đã hiểu',
  }) {
    return CustomDialog(
      content: content,
      buttonText: buttonText,
      iconData: Icons.error,
      iconColor: Colors.red,
    );
  }

  /// Creates a delete confirmation dialog with red delete icon.
  ///
  /// Pre-configured for delete confirmation messages with appropriate styling.
  ///
  /// [content] must not be null.
  factory CustomDialog.deleteConfirm({
    required String content,
    String buttonText = 'Tôi đã hiểu',
  }) {
    return CustomDialog(
      content: content,
      buttonText: buttonText,
      iconData: Icons.delete,
      iconColor: Colors.red,
    );
  }

  /// Shows a custom dialog using the showDialog method.
  ///
  /// This is a convenience method that creates and displays a CustomDialog
  /// without requiring manual dialog creation.
  ///
  /// [context] must not be null and should be a valid BuildContext.
  /// [title] is passed as alertTile to the CustomDialog.
  /// [content] must not be null.
  static void show(
    BuildContext context,
    String title,
    String content, {
    String buttonText = 'Tôi đã hiểu',
    IconData? iconData,
    Color? iconColor,
  }) {
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
        alertTile: title,
        content: content,
        buttonText: buttonText,
        iconData: iconData,
        iconColor: iconColor,
      ),
    );
  }

  /// Shows a confirmation dialog with custom callback.
  ///
  /// Similar to [show] but allows specifying a custom callback function
  /// that will be executed when the dialog button is pressed.
  ///
  /// [context] must not be null and should be a valid BuildContext.
  /// [title] must not be null.
  /// [content] must not be null.
  static void showConfirm(
    BuildContext context, {
    required String title,
    required String content,
    String buttonText = 'Tôi đã hiểu',
    IconData? iconData,
    Color? iconColor,
    void Function()? onButtonPressed,
  }) {
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
        alertTile: title,
        content: content,
        buttonText: buttonText,
        iconData: iconData,
        iconColor: iconColor,
        onButtonPressed: onButtonPressed,
      ),
    );
  }

  /// Builds the CustomDialog widget.
  ///
  /// Returns an AlertDialog with the specified content, icon, and action button.
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(
        content,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      icon: Icon(iconData, color: iconColor, size: 35),
      actions: [
        SizedBox(
          width: double.infinity, // Chiếm toàn bộ chiều rộng
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonPressed,
            ),
            onPressed: () => onButtonPressed != null
                ? onButtonPressed!()
                : NavigateHelper.pop(context),
            child: Text(
              buttonText,
              style: TextStyle(color: AppColors.textOnPrimary),
            ),
          ),
        ),
      ],
    );
  }
}
