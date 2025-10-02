import 'package:flutter/material.dart';
import 'package:myapp/service/auth_factory.dart';
import 'package:myapp/core/colors.dart';
import 'package:myapp/route/navigate_helper.dart';
import 'package:myapp/service/interface/auth_repository.dart';
import 'package:myapp/shared/widgets/common/app_spacing.dart';
import 'package:myapp/shared/widgets/common/common_widgets.dart';
import 'package:myapp/shared/widgets/common/custom_text.dart';
import 'package:myapp/shared/widgets/common/custom_card.dart';
import 'package:myapp/shared/widgets/common/custom_text_field.dart';
import 'package:myapp/shared/widgets/common/custom_elevated_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  AuthRepository get _authService => AuthFactory.instance;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await _authService.login(
        _usernameController.text,
        _passwordController.text,
      );

      if (success) {
        if (mounted) {
          NavigateHelper.navigateAfterLogin(context);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Đăng nhập thất bại')));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _handleGoogleLogin() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final success = await _authService.loginWithGoogle();
      if (success && mounted) {
        NavigateHelper.navigateAfterLogin(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi đăng nhập Google: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _handleFacebookLogin() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final success = await _authService.loginWithFacebook();
      if (success && mounted) {
        NavigateHelper.navigateAfterLogin(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi đăng nhập Facebook: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _navigateToRegister() {
    NavigateHelper.goToRegister(context);
  }

  void _navigateToForgotPassword() {
    NavigateHelper.goToForgotPassword(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Logo and Title
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.pets,
                  size: 60,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 16),
              CustomText.title(text: 'CareNest', color: Colors.white),
              AppSpacing.verticalSM,
              CustomText.subtitle(text: 'Đăng nhập', color: Colors.white),
              CustomText.caption(
                text: 'Nhập thông tin để bắt đầu sử dụng',
                color: Colors.white70,
              ),
              const SizedBox(height: 40),

              // Login Form
              CustomCard(
                padding: AppPadding.xl,
                borderRadius: 20.0,
                backgroundColor: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Username Field
                    CustomTextField.username(
                      controller: _usernameController,
                      hintText: 'Nhập tên đăng nhập',
                    ),
                    AppSpacing.verticalLG,

                    // Password Field
                    CustomTextField.password(
                      controller: _passwordController,
                      labelText: 'Mật khẩu',
                      isPasswordVisible: _isPasswordVisible,
                      onToggleVisibility: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      hintText: 'Nhập mật khẩu',
                    ),
                    AppSpacing.verticalSM,

                    // Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _navigateToForgotPassword,
                        child: CustomText.caption(
                          text: 'Quên mật khẩu?',
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    AppSpacing.verticalLG,

                    // Login Button
                    CustomElevatedButton.login(
                      text: 'Đăng nhập',
                      onPressed: _handleLogin,
                      isLoading: _isLoading,
                    ),
                    AppSpacing.verticalXXL,

                    // Divider
                    CommonWidgets.dividerWithText(
                      text: 'Hoặc',
                      textColor: Colors.grey,
                      lineColor: Colors.grey.shade300,
                    ),
                    AppSpacing.verticalXXL,

                    // Social Login Buttons
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: OutlinedButton.icon(
                    //         onPressed: _handleGoogleLogin,
                    //         icon: const Icon(
                    //           Icons.g_mobiledata,
                    //           color: Colors.red,
                    //         ),
                    //         label: CustomText.body(text: 'Google'),
                    //         style: OutlinedButton.styleFrom(
                    //           padding: AppPadding.verticalMD,
                    //           shape: RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.circular(12),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     AppSpacing.horizontalLG,
                    //     Expanded(
                    //       child: OutlinedButton.icon(
                    //         onPressed: _handleFacebookLogin,
                    //         icon: const Icon(
                    //           Icons.facebook,
                    //           color: Colors.blue,
                    //         ),
                    //         label: CustomText.body(text: 'Facebook'),
                    //         style: OutlinedButton.styleFrom(
                    //           padding: AppPadding.verticalMD,
                    //           shape: RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.circular(12),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
              AppSpacing.verticalXXL,

              // Register Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText.caption(
                    text: 'Bạn chưa có tài khoản?',
                    color: Colors.white70,
                  ),
                  TextButton(
                    onPressed: _navigateToRegister,
                    child: CustomText.caption(
                      text: 'Đăng ký',
                      color: Colors.white,
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
