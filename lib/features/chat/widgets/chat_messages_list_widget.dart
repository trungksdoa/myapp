import 'package:flutter/material.dart';
import 'package:myapp/shared/model/chart_message.dart';
import 'package:myapp/shared/widgets/forms/chat_message_widget.dart';

class ChatMessagesListWidget extends StatelessWidget {
  final List<ChatMessage> messages;
  final bool isLoading;

  const ChatMessagesListWidget({
    super.key,
    required this.messages,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: messages.length + (isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == messages.length && isLoading) {
          return const ChatLoadingIndicatorWidget();
        }

        final message = messages[index];
        return ChatMessageWidget(
          message: message.message,
          isFromCurrentUser: message.isUser,
          timestamp: '12:30',
        );
      },
    );
  }
}

class ChatLoadingIndicatorWidget extends StatelessWidget {
  const ChatLoadingIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          CircularProgressIndicator(strokeWidth: 2),
          SizedBox(width: 16),
          Text('Đang trả lời...', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
