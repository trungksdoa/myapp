import 'package:flutter/material.dart';

class InfoGuideWidget extends StatelessWidget {
  final String message;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;

  const InfoGuideWidget({
    super.key,
    required this.message,
    this.backgroundColor,
    this.textColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? Colors.blue.shade50;
    final txtColor = textColor ?? Colors.blue.shade700;
    final iconData = icon ?? Icons.warning_outlined;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          Icon(iconData, color: Colors.blue.shade600),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: txtColor, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
