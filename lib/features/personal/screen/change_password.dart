import 'package:flutter/material.dart';
import 'package:myapp/shared/widgets/common/custom_text_field.dart';
import 'package:myapp/shared/widgets/common/custom_elevated_button.dart';

class ChangePasswordBodyWidget extends StatefulWidget {
  const ChangePasswordBodyWidget({super.key});

  @override
  State<ChangePasswordBodyWidget> createState() =>
      _ChangePasswordBodyWidgetState();
}

class _ChangePasswordBodyWidgetState extends State<ChangePasswordBodyWidget> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đổi mật khẩu')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField.password(
              controller: _currentPasswordController,
              labelText: 'Mật khẩu hiện tại',
              hintText: 'Nhập mật khẩu hiện tại',
              isPasswordVisible: _isCurrentPasswordVisible,
              onToggleVisibility: () {
                setState(() {
                  _isCurrentPasswordVisible = !_isCurrentPasswordVisible;
                });
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _newPasswordController,
              labelText: 'Mật khẩu mới',
              hintText: 'Nhập mật khẩu mới',
              isPassword: true,
              isPasswordVisible: _isNewPasswordVisible,
              onVisibilityToggle: () {
                setState(() {
                  _isNewPasswordVisible = !_isNewPasswordVisible;
                });
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _confirmPasswordController,
              labelText: 'Xác nhận mật khẩu mới',
              hintText: 'Nhập lại mật khẩu mới',
              isPassword: true,
              isPasswordVisible: _isConfirmPasswordVisible,
              onVisibilityToggle: () {
                setState(() {
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                });
              },
            ),
            const SizedBox(height: 32),
            CustomElevatedButton.login(
              text: 'Đổi mật khẩu',
              onPressed: _changePassword,
            ),
          ],
        ),
      ),
    );
  }

  void _changePassword() {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mật khẩu mới và xác nhận mật khẩu không khớp'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Implement password change logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đổi mật khẩu thành công'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context);
  }
}
