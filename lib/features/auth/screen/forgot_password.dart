import 'package:flutter/material.dart';
import 'package:myapp/core/colors.dart';
import 'package:myapp/route/navigate_helper.dart';
import 'package:myapp/shared/widgets/common/app_spacing.dart';
import 'package:myapp/shared/widgets/common/custom_text.dart';
import 'package:myapp/shared/widgets/common/custom_card.dart';
import 'package:myapp/shared/widgets/common/custom_text_field.dart';
import 'package:myapp/shared/widgets/common/custom_elevated_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleSendResetLink() {
    // TODO: Implement send reset password email logic
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
      // Navigate to OTP screen
      _navigateToOTP();
    });
  }

  void _navigateToOTP() {
    NavigateHelper.goToOTPVerification(context, email: _emailController.text);
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
                      color: Colors.black.withValues(alpha: (0.1)),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.lock_outline,
                  size: 50,
                  color: AppColors.primary,
                ),
              ),
              AppSpacing.vertical(32),

              // Title
              CustomText.title(text: 'Quên mật khẩu', color: Colors.white),
              AppSpacing.vertical(16),

              // Description
              CustomText.body(
                text: 'Nhập email của bạn để nhận liên kết đặt lại mật khẩu',
                textAlign: TextAlign.center,
                color: Colors.white70,
              ),
              AppSpacing.vertical(40),

              // Form
              CustomCard.service(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Email Field
                    CustomTextField.email(
                      controller: _emailController,
                      hintText: 'Nhập địa chỉ email của bạn',
                    ),
                    AppSpacing.vertical(24),

                    // Send Reset Link Button
                    CustomElevatedButton.login(
                      text: 'Gửi mã',
                      onPressed: _isLoading ? null : _handleSendResetLink,
                      isLoading: _isLoading,
                    ),
                  ],
                ),
              ),
              AppSpacing.vertical(32),

              // Back to Login Link
              CustomElevatedButton.secondary(
                text: 'Quay lại đăng nhập',
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
