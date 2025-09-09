import 'package:flutter/material.dart';
import 'package:myapp/core/colors.dart';
import 'package:myapp/widget/index.dart';

class ChatMessageWidget extends StatelessWidget {
  final String message;
  final bool isFromCurrentUser;
  final String timestamp;
  final String? avatarUrl;
  final String? senderName;

  const ChatMessageWidget({
    super.key,
    required this.message,
    required this.isFromCurrentUser,
    required this.timestamp,
    this.avatarUrl,
    this.senderName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: isFromCurrentUser ? 64 : AppSpacing.lg,
        right: isFromCurrentUser ? AppSpacing.lg : 64,
        bottom: AppSpacing.md,
      ),
      child: Row(
        mainAxisAlignment: isFromCurrentUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isFromCurrentUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundImage: avatarUrl != null
                  ? AssetImage(avatarUrl!)
                  : null,
              backgroundColor: Colors.grey.shade300,
              child: avatarUrl == null ? Icon(Icons.person, size: 16) : null,
            ),
            AppSpacing.horizontalMD,
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isFromCurrentUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                if (senderName != null && !isFromCurrentUser)
                  Padding(
                    padding: EdgeInsets.only(bottom: AppSpacing.xs),
                    child: CustomText.caption(
                      text: senderName!,
                      color: Colors.grey.shade600,
                    ),
                  ),
                Container(
                  padding: EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: isFromCurrentUser
                        ? AppColors.primary
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isFromCurrentUser ? 16 : 4),
                      bottomRight: Radius.circular(isFromCurrentUser ? 4 : 16),
                    ),
                  ),
                  child: CustomText.body(
                    text: message,
                    color: isFromCurrentUser ? Colors.white : Colors.black87,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: AppSpacing.xs),
                  child: CustomText.small(
                    text: timestamp,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          if (isFromCurrentUser) ...[
            AppSpacing.horizontalMD,
            CircleAvatar(
              radius: 16,
              backgroundImage: avatarUrl != null
                  ? AssetImage(avatarUrl!)
                  : null,
              backgroundColor: Colors.grey.shade300,
              child: avatarUrl == null ? Icon(Icons.person, size: 16) : null,
            ),
          ],
        ],
      ),
    );
  }
}
