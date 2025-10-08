import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/core/colors.dart';
import 'package:myapp/route/navigate_helper.dart';
import 'package:myapp/shared/index.dart';
import 'package:myapp/features/auth/service/auth_service.dart';

class RegisterOTPVerificationScreen extends StatefulWidget {
  final String email;
  final String xKeyApt;

  const RegisterOTPVerificationScreen({
    super.key,
    required this.email,
    required this.xKeyApt,
  });

  @override
  State<RegisterOTPVerificationScreen> createState() =>
      _RegisterOTPVerificationScreenState();
}

class _RegisterOTPVerificationScreenState
    extends State<RegisterOTPVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  int _resendCountdown = 0;

  @override
  void initState() {
    super.initState();
    _authService.initialize();
    _startResendCountdown();
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _startResendCountdown() {
    setState(() {
      _resendCountdown = 60;
    });

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          _resendCountdown--;
        });
        return _resendCountdown > 0;
      }
      return false;
    });
  }

  void _onOtpChanged(String value, int index) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }

    // Auto verify when all fields are filled
    if (_controllers.every((controller) => controller.text.isNotEmpty)) {
      _verifyOtp();
    }
  }

  void _onBackspace(int index) {
    if (index > 0 && _controllers[index].text.isEmpty) {
      _controllers[index - 1].clear();
      _focusNodes[index - 1].requestFocus();
    }
  }

  String get _otpCode {
    return _controllers.map((controller) => controller.text).join();
  }

  void _verifyOtp() async {
    if (_otpCode.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đầy đủ mã OTP')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.verifyRegisterOTP(
        widget.email,
        _otpCode,
        widget.xKeyApt,
      );

      if (mounted) {
        NavigateHelper.goToRegistrationSuccess(context);
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = 'Xác thực OTP thất bại';
        if (e.toString().contains('invalid')) {
          errorMessage = 'Mã OTP không hợp lệ';
        } else if (e.toString().contains('expired')) {
          errorMessage = 'Mã OTP đã hết hạn';
        } else if (e.toString().contains('network')) {
          errorMessage = 'Lỗi kết nối mạng';
        }

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _resendOtp() async {
    // Note: You might need to implement resend OTP API endpoint
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Đã gửi lại mã OTP')));
    _startResendCountdown();
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Logo and Title
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.verified_user,
                  size: 50,
                  color: AppColors.primary,
                ),
              ),
              AppSpacing.verticalLG,
              CustomText.title(text: 'Xác thực OTP', color: Colors.white),
              AppSpacing.verticalSM,
              CustomText.subtitle(
                text: 'Nhập mã xác thực',
                color: Colors.white,
              ),
              CustomText.caption(
                text: 'Chúng tôi đã gửi mã OTP đến email: ${widget.email}',
                color: Colors.white70,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // OTP Form
              CustomCard(
                padding: AppPadding.xl,
                borderRadius: 20.0,
                backgroundColor: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomText.body(
                      text: 'Mã xác thực',
                      color: Colors.grey.shade700,
                      textAlign: TextAlign.center,
                    ),
                    AppSpacing.verticalLG,

                    // OTP Input Fields
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(6, (index) {
                        return SizedBox(
                          width: 45,
                          height: 55,
                          child: TextField(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              counterText: '',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: AppColors.primary,
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                            ),
                            onChanged: (value) => _onOtpChanged(value, index),
                            onTap: () {
                              _controllers[index].selection =
                                  TextSelection.fromPosition(
                                    TextPosition(
                                      offset: _controllers[index].text.length,
                                    ),
                                  );
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                        );
                      }),
                    ),
                    AppSpacing.verticalXXL,

                    // Verify Button
                    CustomElevatedButton.login(
                      text: 'Xác thực',
                      onPressed: _verifyOtp,
                      isLoading: _isLoading,
                    ),
                    AppSpacing.verticalLG,

                    // Resend OTP
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText.caption(
                          text: 'Không nhận được mã?',
                          color: Colors.grey.shade600,
                        ),
                        if (_resendCountdown > 0) ...[
                          CustomText.caption(
                            text: ' Gửi lại sau ${_resendCountdown}s',
                            color: Colors.grey.shade500,
                          ),
                        ] else ...[
                          TextButton(
                            onPressed: _resendOtp,
                            child: CustomText.caption(
                              text: ' Gửi lại',
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ],
                    ),
                    AppSpacing.verticalLG,

                    // Note
                    CustomCard.info(
                      child: Column(
                        children: [
                          CustomText.small(
                            text: 'Lưu ý:',
                            color: Colors.grey.shade700,
                          ),
                          AppSpacing.verticalXS,
                          CustomText.small(
                            text:
                                '• Mã OTP có hiệu lực trong 5 phút\n• Kiểm tra hộp thư spam nếu không nhận được email\n• Đảm bảo kết nối internet ổn định',
                            color: Colors.grey.shade600,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.verticalXXL,

              // Help Text
              CustomText.caption(
                text: 'Bạn gặp vấn đề? Liên hệ hỗ trợ',
                color: Colors.white70,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
