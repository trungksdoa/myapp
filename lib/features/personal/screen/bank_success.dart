import 'package:flutter/material.dart';
import 'package:myapp/shared/widgets/common/custom_elevated_button.dart';

class SuccessBodyWidget extends StatelessWidget {
  const SuccessBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Success illustration
          Container(
            padding: const EdgeInsets.all(32),
            decoration: const BoxDecoration(
              color: Color(0xFF4A9B8E),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 80),
          ),

          const SizedBox(height: 32),

          // Success message
          const Text(
            'Đã liên kết thành công',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          const Text(
            'Tài khoản ngân hàng của bạn đã được liên kết thành công với ứng dụng.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),

          const SizedBox(height: 48),

          // Return to home button
          CustomElevatedButton.login(
            text: 'Quay lại ví của bạn',
            onPressed: () => _returnToHome(context),
          ),
        ],
      ),
    );
  }

  void _returnToHome(BuildContext context) {
    Navigator.popUntil(context, (route) => route.isFirst);
  }
}
