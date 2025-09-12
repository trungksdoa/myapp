import 'package:flutter/material.dart';
import 'package:myapp/shared/widgets/common/app_spacing.dart';
import 'package:myapp/shared/widgets/common/custom_card.dart';
import 'package:myapp/shared/widgets/common/custom_text.dart';

class MemberCard extends StatelessWidget {
  final Map<String, dynamic> member;
  final bool isAdmin;
  final VoidCallback? onRemovePressed;
  final VoidCallback? onLongPress;

  const MemberCard({
    super.key,
    required this.member,
    required this.isAdmin,
    this.onRemovePressed,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.md),
      child: CustomCard.blog(
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          leading: CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage(member['avatar'] as String),
          ),
          title: Row(
            children: [
              CustomText(
                text: member['name'] as String,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              if (member['role'] == 'admin')
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.teal.shade200, width: 1),
                  ),
                  child: CustomText(
                    text: 'Quản trị viên',
                    fontSize: 12,
                    color: Colors.teal.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
          trailing: member['role'] == 'admin'
              ? null
              : TextButton(
                  onPressed: onRemovePressed,
                  style: TextButton.styleFrom(
                    minimumSize: const Size(40, 40),
                    padding: const EdgeInsets.all(0),
                  ),
                  child: CustomText.button(text: 'Xoá', color: Colors.red),
                ),
          onLongPress: onLongPress,
        ),
      ),
    );
  }
}
