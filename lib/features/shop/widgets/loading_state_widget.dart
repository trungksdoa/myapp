import 'package:flutter/material.dart';

class LoadingStateWidget extends StatelessWidget {
  final String message;

  const LoadingStateWidget({super.key, this.message = 'Đang tải dữ liệu...'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dịch vụ thú cưng'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(message),
          ],
        ),
      ),
    );
  }
}
