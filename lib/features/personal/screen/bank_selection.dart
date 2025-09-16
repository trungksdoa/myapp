import 'package:flutter/material.dart';
import 'package:myapp/features/personal/screen/bank_link.dart';
import 'package:myapp/shared/widgets/common/custom_text_field.dart';

class BankSelectionBodyWidget extends StatelessWidget {
  const BankSelectionBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Search bar
          CustomTextField.search(
            controller: searchController,
            hintText: 'Tìm kiếm ngân hàng',
          ),

          const SizedBox(height: 20),

          // Popular banks section
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Ngân hàng phổ biến',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 12),

          // Popular banks grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              _buildBankItem(
                'Vietcombank',
                'assets/images/vcb.png',
                () => _selectBank(context, 'Vietcombank'),
              ),
              _buildBankItem(
                'BIDV',
                'assets/images/bidv.png',
                () => _selectBank(context, 'BIDV'),
              ),
              _buildBankItem(
                'Vietinbank',
                'assets/images/vietinbank.png',
                () => _selectBank(context, 'Vietinbank'),
              ),
              _buildBankItem(
                'Techcombank',
                'assets/images/tcb.png',
                () => _selectBank(context, 'Techcombank'),
              ),
              _buildBankItem(
                'Agribank',
                'assets/images/agribank.png',
                () => _selectBank(context, 'Agribank'),
              ),
              _buildBankItem(
                'Sacombank',
                'assets/images/sacombank.png',
                () => _selectBank(context, 'Sacombank'),
              ),
              _buildBankItem(
                'ACB',
                'assets/images/acb.png',
                () => _selectBank(context, 'ACB'),
              ),
              _buildBankItem(
                'Nam A Bank',
                'assets/images/namabank.png',
                () => _selectBank(context, 'Nam A Bank'),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // All banks section
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Toàn bộ ngân hàng',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 12),

          // All banks list
          Expanded(
            child: ListView(
              children: [
                _buildBankListItem(
                  'Vietcombank',
                  'assets/images/vcb.png',
                  () => _selectBank(context, 'Vietcombank'),
                ),
                _buildBankListItem(
                  'TP Bank',
                  'assets/images/tpbank.png',
                  () => _selectBank(context, 'TP Bank'),
                ),
                _buildBankListItem(
                  'LP Bank',
                  'assets/images/lpbank.png',
                  () => _selectBank(context, 'LP Bank'),
                ),
                _buildBankListItem(
                  'Bac A Bank',
                  'assets/images/bacabank.png',
                  () => _selectBank(context, 'Bac A Bank'),
                ),
                _buildBankListItem(
                  'NCB',
                  'assets/images/ncb.png',
                  () => _selectBank(context, 'NCB'),
                ),
                _buildBankListItem(
                  'BIDV',
                  'assets/images/bidv.png',
                  () => _selectBank(context, 'BIDV'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankItem(String name, String imagePath, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, width: 32, height: 32, fit: BoxFit.contain),
            const SizedBox(height: 4),
            Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBankListItem(String name, String imagePath, VoidCallback onTap) {
    return ListTile(
      leading: Image.asset(
        imagePath,
        width: 40,
        height: 40,
        fit: BoxFit.contain,
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _selectBank(BuildContext context, String bankName) {
    // Navigate to bank account linking screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BankAccountLinkingBodyWidget(bankName: bankName),
      ),
    );
  }
}
