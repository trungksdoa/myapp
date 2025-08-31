import 'package:flutter/material.dart';
import 'package:myapp/route/app_router.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? titleWidget;
  final VoidCallback? onReset;
  final VoidCallback? onSave;
  final String saveButtonText;
  final Icon? actionButtonIcon;
  final VoidCallback? onActionPressed; // Add callback for action button
  final bool? isUseTextButton; // Control visibility of action button
  const CustomAppBar({
    super.key,
    required this.title,
    this.onReset,
    this.onSave,
    this.saveButtonText = 'Lưu',
    this.actionButtonIcon,
    this.onActionPressed,
    this.isUseTextButton,
    this.titleWidget,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => AppRouter.pop(context),
      ),
      title:
          titleWidget ??
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
      centerTitle: false,
      actions: [
        if (onReset != null)
          Container(
            margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
            child: IconButton(
              icon: const Icon(Icons.refresh, color: Colors.grey),
              onPressed: () => _showResetDialog(context),
              tooltip: 'Reset tất cả',
            ),
          ),

        if (actionButtonIcon != null &&
            (isUseTextButton == null || isUseTextButton == false))
          Container(
            margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
            child: IconButton(
              icon: actionButtonIcon!,
              onPressed: onActionPressed,
              tooltip: 'Action',
            ),
          ),

        if (onSave != null &&
            (isUseTextButton == null || isUseTextButton == true))
          Container(
            margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            child: ElevatedButton(
              onPressed: onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                saveButtonText,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
      shadowColor: Colors.black.withValues(alpha: 0.15),
      elevation: 4.0,
      surfaceTintColor: Colors.transparent,
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận'),
          content: const Text('Bạn có chắc muốn reset tất cả thông tin?'),
          actions: [
            TextButton(
              onPressed: () => AppRouter.pop(context),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                AppRouter.pop(context);
                onReset?.call();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đã reset tất cả thông tin!'),
                    backgroundColor: Colors.blue,
                  ),
                );
              },
              child: const Text('Reset', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
