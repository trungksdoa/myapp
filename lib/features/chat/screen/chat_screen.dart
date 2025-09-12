import 'package:flutter/material.dart';
import 'package:myapp/features/chat/widgets/chat_empty_state_widget.dart';
import 'package:myapp/features/chat/widgets/chat_input_area_widget.dart';
import 'package:myapp/features/chat/widgets/chat_messages_list_widget.dart';
import 'package:myapp/shared/model/chart_message.dart';

class ChatScreen extends StatefulWidget {
  final String? initialMessage;
  final String? petName;

  const ChatScreen({super.key, this.initialMessage, this.petName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _sendMessage(widget.initialMessage!);
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage(String message) {
    if (message.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(message: message, isUser: true));
      _isLoading = true;
    });

    _messageController.clear();

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      final response = _generateResponse(message);
      setState(() {
        _messages.add(ChatMessage(message: response, isUser: false));
        _isLoading = false;
      });
    });
  }

  String _generateResponse(String userMessage) {
    final message = userMessage.toLowerCase();
    if (message.contains('ăn') || message.contains('thức ăn')) {
      return 'Thú cưng cần ăn thức ăn chất lượng và đúng giờ nhé! 🍽️';
    } else if (message.contains('khỏe') || message.contains('sức khỏe')) {
      return 'Hãy đưa thú cưng đi khám định kỳ và tiêm vaccine đầy đủ! 🏥';
    } else if (message.contains('chơi') || message.contains('vui')) {
      return 'Thú cưng cần vui chơi mỗi ngày để khỏe mạnh! 🎾';
    } else if (message.contains('tắm') || message.contains('vệ sinh')) {
      return 'Nên tắm cho thú cưng 1-2 lần/tuần với sản phẩm chuyên dụng! 🛁';
    } else {
      return 'Cảm ơn bạn! Tôi sẵn sàng giúp bạn chăm sóc thú cưng tốt nhất! 🐾';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Chat với ${widget.petName ?? 'Pet'}'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? const ChatEmptyStateWidget()
                : ChatMessagesListWidget(
                    messages: _messages,
                    isLoading: _isLoading,
                  ),
          ),
          ChatInputAreaWidget(
            controller: _messageController,
            onSendMessage: _sendMessage,
          ),
        ],
      ),
    );
  }
}
