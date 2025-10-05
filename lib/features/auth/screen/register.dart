import 'package:flutter/material.dart';
import 'package:myapp/core/colors.dart';
import 'package:myapp/route/navigate_helper.dart';
import 'package:myapp/shared/index.dart';
import 'package:myapp/features/auth/service/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();

  final AuthService _authService = AuthService();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _agreeToTerms = false;
  String _selectedGender = 'MALE';
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _authService.initialize();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _userNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _birthdayController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(
        const Duration(days: 6570),
      ), // 18 years ago
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _birthdayController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  void _handleRegister() async {
    // Validate inputs
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng đồng ý với điều khoản sử dụng')),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mật khẩu xác nhận không khớp')),
      );
      return;
    }

    if (_userNameController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _fullNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _birthdayController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin')),
      );
      return;
    }

    // Email validation
    if (!RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(_emailController.text)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Email không hợp lệ')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _authService.register({
        'username': _userNameController.text,
        'fullName': _fullNameController.text,
        'birthday': _birthdayController.text,
        'gender': _selectedGender,
        'email': _emailController.text,
        'password': _passwordController.text,
        'reEnterPassword': _confirmPasswordController.text,
      });

      if (response.isNotEmpty && mounted) {
        NavigateHelper.goToRegistrationSuccess(context);
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = 'Đăng ký thất bại';
        if (e.toString().contains('already exists')) {
          errorMessage = 'Tên đăng nhập hoặc email đã tồn tại';
        } else if (e.toString().contains('network')) {
          errorMessage = 'Lỗi kết nối mạng';
        } else if (e.toString().contains('password')) {
          errorMessage = 'Mật khẩu không đủ mạnh';
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

  void _navigateToLogin() {
    NavigateHelper.goToLogin(context);
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
                  Icons.pets,
                  size: 50,
                  color: AppColors.primary,
                ),
              ),
              AppSpacing.verticalLG,
              CustomText.title(text: 'CareNest', color: Colors.white),
              AppSpacing.verticalSM,
              CustomText.subtitle(
                text: 'Đăng ký tài khoản',
                color: Colors.white,
              ),
              CustomText.caption(
                text: 'Tạo tài khoản để bắt đầu chăm sóc thú cưng',
                color: Colors.white70,
              ),
              const SizedBox(height: 32),

              // Register Form
              CustomCard(
                padding: AppPadding.xl,
                borderRadius: 20.0,
                backgroundColor: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Full Name Field
                    CustomTextField(
                      controller: _fullNameController,
                      labelText: 'Họ và Tên',
                      hintText: 'Nhập họ và tên của bạn',
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                    AppSpacing.verticalLG,

                    // Username Field
                    CustomTextField.username(
                      controller: _userNameController,
                      hintText: 'Nhập tên đăng nhập',
                    ),
                    AppSpacing.verticalLG,

                    // Email Field
                    CustomTextField(
                      controller: _emailController,
                      labelText: 'Email',
                      hintText: 'Nhập địa chỉ email',
                      prefixIcon: const Icon(Icons.email_outlined),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    AppSpacing.verticalLG,

                    // Birthday Field
                    CustomTextField(
                      controller: _birthdayController,
                      labelText: 'Ngày sinh',
                      hintText: 'Chọn ngày sinh',
                      prefixIcon: const Icon(Icons.calendar_today_outlined),
                      readOnly: true,
                      onTap: _selectDate,
                    ),
                    AppSpacing.verticalLG,

                    // Gender Field
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText.body(
                          text: 'Giới tính',
                          color: Colors.grey.shade700,
                        ),
                        AppSpacing.verticalSM,
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile<String>(
                                title: const Text('Nam'),
                                value: 'MALE',
                                groupValue: _selectedGender,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedGender = value!;
                                  });
                                },
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                            Expanded(
                              child: RadioListTile<String>(
                                title: const Text('Nữ'),
                                value: 'FEMALE',
                                groupValue: _selectedGender,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedGender = value!;
                                  });
                                },
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ],
                        ),
                      ],
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

                    // Password requirements
                    CustomCard.info(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText.small(
                            text: 'Mật khẩu cần có:',
                            color: Colors.grey.shade700,
                          ),
                          AppSpacing.verticalXS,
                          CustomText.small(
                            text:
                                '• Ít nhất 8 ký tự\n• Ít nhất 1 chữ hoa và 1 chữ thường\n• Ít nhất 1 số và 1 ký tự đặc biệt',
                            color: Colors.grey.shade600,
                          ),
                        ],
                      ),
                    ),
                    AppSpacing.verticalLG,

                    // Confirm Password Field
                    CustomTextField.password(
                      controller: _confirmPasswordController,
                      labelText: 'Xác nhận mật khẩu',
                      isPasswordVisible: _isConfirmPasswordVisible,
                      onToggleVisibility: () {
                        setState(() {
                          _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible;
                        });
                      },
                      hintText: 'Nhập lại mật khẩu',
                    ),
                    AppSpacing.verticalLG,

                    // Terms and Conditions
                    Row(
                      children: [
                        Checkbox(
                          value: _agreeToTerms,
                          onChanged: (value) {
                            setState(() {
                              _agreeToTerms = value ?? false;
                            });
                          },
                        ),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                              children: [
                                const TextSpan(text: 'Tôi đồng ý với '),
                                TextSpan(
                                  text: 'Điều khoản dịch vụ',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const TextSpan(text: ' và '),
                                TextSpan(
                                  text: 'Chính sách bảo mật',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.verticalXXL,

                    // Register Button
                    CustomElevatedButton.login(
                      text: 'Đăng ký',
                      onPressed: _handleRegister,
                      isLoading: _isLoading,
                    ),
                    AppSpacing.verticalXXL,

                    // Divider
                    CommonWidgets.dividerWithText(
                      text: 'Hoặc đăng ký bằng',
                      textColor: Colors.grey,
                      lineColor: Colors.grey.shade300,
                    ),
                    AppSpacing.verticalXXL,

                    // Note: Social login not available in current AuthService
                    CustomText.caption(
                      text: 'Tạo tài khoản để truy cập đầy đủ tính năng',
                      color: Colors.grey.shade600,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              AppSpacing.verticalXXL,

              // Login Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText.caption(
                    text: 'Đã có tài khoản?',
                    color: Colors.white70,
                  ),
                  TextButton(
                    onPressed: _navigateToLogin,
                    child: CustomText.caption(
                      text: 'Đăng nhập',
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
