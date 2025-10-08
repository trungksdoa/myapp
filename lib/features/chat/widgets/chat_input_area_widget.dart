import 'package:flutter/material.dart';

class ChatInputAreaWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSendMessage;
  final bool isLoading;

  const ChatInputAreaWidget({
    super.key,
    required this.controller,
    required this.onSendMessage,
    this.isLoading = false, // ✅ Default value
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Emoji/Attachment button (optional)
          IconButton(
            icon: Icon(
              Icons.add_circle_outline,
              color: Colors.grey[400],
              size: 24,
            ),
            onPressed: isLoading
                ? null
                : () {
                    // Show attachment options
                    _showAttachmentOptions(context);
                  },
          ),

          // Text input
          Expanded(
            child: TextField(
              controller: controller,
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
              enabled: !isLoading,
              decoration: InputDecoration(
                hintText: 'Nhập tin nhắn...',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 12,
                ),
              ),
              onSubmitted: isLoading
                  ? null
                  : (value) {
                      if (value.trim().isNotEmpty) {
                        onSendMessage(value);
                      }
                    },
            ),
          ),

          // Send button
          Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              gradient: isLoading
                  ? null
                  : const LinearGradient(
                      colors: [Color(0xFF4A90A4), Color(0xFF357A8C)],
                    ),
              color: isLoading ? Colors.grey[300] : null,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: isLoading
                  ? null
                  : () {
                      final message = controller.text.trim();
                      if (message.isNotEmpty) {
                        onSendMessage(message);
                      }
                    },
              icon: Icon(
                isLoading ? Icons.hourglass_empty : Icons.send_rounded,
                color: Colors.white,
                size: 20,
              ),
              padding: const EdgeInsets.all(10),
              constraints: const BoxConstraints(),
            ),
          ),
        ],
      ),
    );
  }

  void _showAttachmentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Đính kèm',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAttachmentOption(
                  icon: Icons.photo_library,
                  label: 'Ảnh',
                  color: Colors.blue,
                  onTap: () {
                    Navigator.pop(context);
                    // Handle photo upload
                  },
                ),
                _buildAttachmentOption(
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  color: Colors.orange,
                  onTap: () {
                    Navigator.pop(context);
                    // Handle camera
                  },
                ),
                _buildAttachmentOption(
                  icon: Icons.description,
                  label: 'File',
                  color: Colors.purple,
                  onTap: () {
                    Navigator.pop(context);
                    // Handle file upload
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 80,
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
