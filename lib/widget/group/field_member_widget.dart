import 'package:flutter/material.dart';

class MemberFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final VoidCallback? onRemove;
  final bool canRemove;
  final String tooltipText;
  const MemberFieldWidget({
    super.key,
    required this.controller,
    required this.label,
    this.tooltipText = 'Xóa thành viên',
    this.onRemove,
    this.canRemove = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: label,
                labelStyle: TextStyle(color: Colors.grey.shade600),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.teal, width: 2),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
                prefixIcon: const Icon(
                  Icons.person_outline,
                  color: Colors.teal,
                ),
              ),
            ),
          ),
          if (canRemove) ...[
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.red.shade400,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.shade400.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.remove, color: Colors.white, size: 20),
                onPressed: onRemove,
                tooltip: 'Xóa thành viên',
              ),
            ),
          ],
        ],
      ),
    );
  }
}
