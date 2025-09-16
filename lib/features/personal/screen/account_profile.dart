import 'package:flutter/material.dart';
import 'package:myapp/route/navigate_helper.dart';
import 'package:myapp/shared/widgets/common/custom_text_field.dart';
import 'package:myapp/shared/widgets/common/custom_elevated_button.dart';

class AccountProfileBodyWidget extends StatefulWidget {
  const AccountProfileBodyWidget({super.key});

  @override
  State<AccountProfileBodyWidget> createState() =>
      _AccountProfileBodyWidgetState();
}

class _AccountProfileBodyWidgetState extends State<AccountProfileBodyWidget> {
  final TextEditingController _nameController = TextEditingController(
    text: 'Mèo thần chết',
  );
  final TextEditingController _birthdateController = TextEditingController(
    text: '01/01/2000',
  );
  String _selectedGender = 'Nữ';

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

            // Name field
            CustomTextField(
              controller: _nameController,
              labelText: 'Họ và tên',
              hintText: 'Nhập họ và tên',
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

            //Change password button
            CustomElevatedButton.login(
              text: 'Đổi mật khẩu',
              onPressed: _navigateToChangePassword,
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

  void _navigateToChangePassword() {
    NavigateHelper.goToChangePassword(context);
    // Navigate to change password screen
  }
}
