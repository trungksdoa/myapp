import 'package:flutter/material.dart';
import 'package:myapp/features/personal/screen/bank_success.dart';
import 'package:myapp/shared/widgets/common/custom_elevated_button.dart';
import 'package:myapp/shared/widgets/forms/otp_input_widget.dart';

class OTPVerificationBodyWidget extends StatefulWidget {
  const OTPVerificationBodyWidget({super.key});

  @override
  State<OTPVerificationBodyWidget> createState() =>
      _OTPVerificationBodyWidgetState();
}

class _OTPVerificationBodyWidgetState extends State<OTPVerificationBodyWidget> {
  String _otpCode = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Illustration
          Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Icon(
                  Icons.mail_outline,
                  size: 80,
                  color: Colors.orange.shade300,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Vui lòng kiểm tra mã OTP đã được gửi tới ngân hàng',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // OTP input fields
          OTPInputWidget(
            length: 6,
            onCompleted: (otp) {
              setState(() {
                _otpCode = otp;
              });
            },
          ),

          const SizedBox(height: 32),

          // Verify button
          CustomElevatedButton.login(text: 'Xác nhận', onPressed: _verifyOTP),

          const SizedBox(height: 16),

          // Resend OTP
          TextButton(
            onPressed: _resendOTP,
            child: const Text(
              'Gửi lại mã OTP',
              style: TextStyle(
                color: Color(0xFF4A9B8E),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _verifyOTP() {
    if (_otpCode.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập đầy đủ mã OTP'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Navigate to success screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SuccessBodyWidget()),
    );
  }

  void _resendOTP() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã gửi lại mã OTP'),
        backgroundColor: Color(0xFF4A9B8E),
      ),
    );
  }
}
