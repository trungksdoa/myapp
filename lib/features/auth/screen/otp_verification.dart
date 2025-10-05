import 'package:flutter/material.dart';
import 'package:myapp/core/colors.dart';
import 'package:myapp/route/navigate_helper.dart';
import 'package:myapp/shared/index.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String email;

  const OTPVerificationScreen({super.key, required this.email});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  bool _isLoading = false;
  int _resendCountdown = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    setState(() {
      _resendCountdown = 60;
      _canResend = false;
    });

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          _resendCountdown--;
        });
        if (_resendCountdown <= 0) {
          setState(() {
            _canResend = true;
          });
          return false;
        }
        return true;
      }
      return false;
    });
  }

  void _verifyOTP([String? otp]) {
    // TODO: Use the otp parameter for verification logic
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        // Navigate to reset password screen
        _navigateToResetPassword();
      }
    });
  }

  void _resendOTP() {
    if (!_canResend) return;

    // TODO: Implement resend OTP logic
    _startCountdown();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Mã OTP mới đã được gửi')));
  }

  void _navigateToResetPassword() {
    NavigateHelper.goToResetPassword(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  size: 50,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 32),

              // Title
              CustomText.title(text: 'Xác nhận OTP', color: Colors.white),
              AppSpacing.vertical(16),

              // Description
              CustomText.body(
                text: 'Chúng tôi đã gửi mã xác nhận 4 số đến\n${widget.email}',
                textAlign: TextAlign.center,
                color: Colors.white70,
              ),
              AppSpacing.vertical(40),

              // OTP Input
              CustomCard.service(
                child: Column(
                  children: [
                    OTPInputWidget(onCompleted: _verifyOTP),
                    AppSpacing.vertical(32),

                    // Verify Button
                    CustomElevatedButton.login(
                      text: 'Xác nhận',
                      onPressed: _isLoading ? null : () => _verifyOTP(),
                      isLoading: _isLoading,
                    ),
                  ],
                ),
              ),
              AppSpacing.vertical(32),

              // Resend OTP
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText.body(
                    text: 'Không nhận được mã? ',
                    color: Colors.white70,
                  ),
                  TextButton(
                    onPressed: _canResend ? _resendOTP : null,
                    child: Text(
                      _canResend
                          ? 'Gửi lại mã'
                          : 'Gửi lại sau ${_resendCountdown}s',
                      style: TextStyle(
                        color: _canResend ? Colors.white : Colors.white60,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
