import 'package:flutter/material.dart';
import 'package:myapp/route/navigate_helper.dart';
import 'package:myapp/shared/widgets/common/custom_text_field.dart';
import 'package:myapp/shared/widgets/common/custom_elevated_button.dart';
import 'package:myapp/shared/model/account.dart';
import 'package:myapp/features/auth/service/auth_service.dart';

// Mock AccountService for now
class AccountService {
  Future<Account?> getAccountById(String id) async {
    // Mock implementation
    return Account(
      accountId: id,
      fullName: 'Mèo thần chết',
      email: 'user@example.com',
    );
  }

  Future<Account?> getCurrentProfile() async {
    return Account(
      accountId: '1',
      fullName: 'Mèo thần chết',
      email: 'user@example.com',
    );
  }

  Future<void> updateProfile(Account account) async {
    // Mock implementation
    await Future.delayed(const Duration(milliseconds: 500));
  }
}

class AccountProfileBodyWidget extends StatefulWidget {
  const AccountProfileBodyWidget({super.key});

  @override
  State<AccountProfileBodyWidget> createState() =>
      _AccountProfileBodyWidgetState();
}

class _AccountProfileBodyWidgetState extends State<AccountProfileBodyWidget> {
  final String userId = AuthService().userId ?? "";

  final AccountService _accountService = AccountService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();

  Account? _currentAccount;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAccountData();
  }

  Future<void> _loadAccountData() async {
    try {
      setState(() => _isLoading = true);

      if (userId.isNotEmpty) {
        _currentAccount = await _accountService.getAccountById(userId);
      } else {
        _currentAccount = await _accountService.getCurrentProfile();
      }

      if (_currentAccount != null) {
        _nameController.text = _currentAccount!.fullName;
        _emailController.text = _currentAccount!.email;
      }
    } catch (e) {
      // Handle error - maybe show snackbar
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi tải dữ liệu: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hồ sơ của tôi')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar section
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: const AssetImage(
                      'assets/images/user_avatar.jpg',
                    ),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        onTap: _changeAvatar,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Loading indicator or form
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      // Name field
                      CustomTextField(
                        controller: _nameController,
                        labelText: 'Họ và tên',
                        hintText: 'Nhập họ và tên',
                      ),
                      const SizedBox(height: 16),

                      // Email field
                      CustomTextField(
                        controller: _emailController,
                        labelText: 'Email',
                        hintText: 'Nhập email',
                        readOnly: true, // Email usually not editable
                      ),
                      const SizedBox(height: 16),

                      // Birthdate field
                      GestureDetector(
                        onTap: _selectBirthDate,
                        child: AbsorbPointer(
                          child: CustomTextField(
                            controller: _birthdateController,
                            labelText: 'Ngày sinh',
                            hintText: 'Chọn ngày sinh',
                            suffixIcon: const Icon(Icons.calendar_today),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Save profile button
                      CustomElevatedButton.login(
                        text: 'Lưu thông tin',
                        onPressed: _saveProfile,
                      ),
                      const SizedBox(height: 16),

                      //Change password button
                      CustomElevatedButton.login(
                        text: 'Đổi mật khẩu',
                        onPressed: _navigateToChangePassword,
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  void _changeAvatar() {
    // Implement avatar change functionality
  }

  void _selectBirthDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthdateController.text =
            '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_currentAccount == null) return;

    try {
      final updatedAccount = Account(
        accountId: _currentAccount!.accountId,
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
      );

      await _accountService.updateProfile(updatedAccount);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Cập nhật thành công!')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi cập nhật: $e')));
    }
  }

  void _navigateToChangePassword() {
    NavigateHelper.goToChangePassword(context);
    // Navigate to change password screen
  }
}
