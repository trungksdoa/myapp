import 'package:flutter/material.dart';
import 'package:myapp/core/colors.dart';

class SuccessDiaglog extends StatelessWidget {
  final String alertTile;
  final String content;
  const SuccessDiaglog({
    super.key,
    required this.alertTile,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // title: Text(alertTile, style: TextStyle(fontSize: 16)),
      content: Text(
        content,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      icon: Icon(Icons.check, color: Colors.green, size: 35),
      actions: [
        SizedBox(
          width: double.infinity, // Chiếm toàn bộ chiều rộng
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonPressed,
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Tôi đã hiểu',
              style: TextStyle(color: AppColors.textOnPrimary),
            ),
          ),
        ),
      ],
    );
  }
}
