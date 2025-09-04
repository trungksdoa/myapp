import 'package:flutter/material.dart';
import 'package:myapp/core/colors.dart';
import 'package:myapp/route/navigate_helper.dart';

class CustomDialog extends StatelessWidget {
  final String? alertTile;
  final String content;
  final String buttonText;
  final IconData? iconData;
  final Color? iconColor;

  const CustomDialog({
    super.key,
    this.alertTile,
    required this.content,
    this.buttonText = 'Tôi đã hiểu',
    this.iconData,
    this.iconColor,
  });

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
            onPressed: () => NavigateHelper.pop(context),
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
