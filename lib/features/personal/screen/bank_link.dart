import 'package:flutter/material.dart';
import 'package:myapp/features/personal/screen/bank_verify_otp.dart';
import 'package:myapp/shared/widgets/common/custom_text_field.dart';
import 'package:myapp/shared/widgets/common/custom_elevated_button.dart';
import 'package:myapp/shared/widgets/common/info_tip_widget.dart';

class BankAccountLinkingBodyWidget extends StatefulWidget {
  final String bankName;

  const BankAccountLinkingBodyWidget({super.key, required this.bankName});

  @override
  State<BankAccountLinkingBodyWidget> createState() =>
      _BankAccountLinkingBodyWidgetState();
}

class _BankAccountLinkingBodyWidgetState
    extends State<BankAccountLinkingBodyWidget> {
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _accountNameController = TextEditingController();
  final TextEditingController _cccdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bank info section
          const Text(
            'Thông tin tài ngân hàng',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          // Account number field
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Số tài khoản',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _accountNumberController,
                labelText: 'Số tài khoản',
                hintText: 'Nhập số tài khoản',
                keyboardType: TextInputType.number,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Account name field
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tên chủ tài khoản',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _accountNameController,
                labelText: 'Tên chủ tài khoản',
                hintText: 'Nhập tên chủ tài khoản',
              ),
            ],
          ),

          const SizedBox(height: 16),

          // CCCD/CMND field
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'CCCD/CMND',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _cccdController,
                labelText: 'CCCD/CMND',
                hintText: 'Nhập số CCCD/CMND',
                keyboardType: TextInputType.number,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Info note
          InfoTipWidget(
            message:
                'Các thông tin được nhập sẽ hoàn toàn bảo mật và chỉ được sử dụng để xử lý giao dịch.',
          ),

          const Spacer(),

          // Continue button
          CustomElevatedButton.login(text: 'Tiếp tục', onPressed: _linkAccount),
        ],
      ),
    );
  }

  void _linkAccount() {
    if (_accountNumberController.text.isEmpty ||
        _accountNameController.text.isEmpty ||
        _cccdController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng điền đầy đủ thông tin'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Navigate to OTP verification screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const OTPVerificationBodyWidget(),
      ),
    );
  }
}
