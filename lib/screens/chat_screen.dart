import 'package:flutter/material.dart';

// Model đơn giản cho tin nhắn
class ChatMessage {
  final String message;
  final bool isUser;

  ChatMessage({required this.message, required this.isUser});
}

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
    // Nếu có tin nhắn ban đầu, gửi luôn
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
          // Danh sách tin nhắn
          Expanded(
            child: _messages.isEmpty
                ? _buildEmptyState()
                : _buildMessagesList(),
          ),
          // Vùng nhập tin nhắn
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.pets, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Bắt đầu cuộc trò chuyện!',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length + (_isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _messages.length && _isLoading) {
          return _buildLoadingIndicator();
        }

        final message = _messages[index];
        return _buildMessageBubble(message);
      },
    );
  }

  Widget _buildLoadingIndicator() {
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

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: message.isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: message.isUser ? Colors.blue : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              message.message,
              style: TextStyle(
                color: message.isUser ? Colors.white : Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Nhập tin nhắn...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onSubmitted: (message) {
                if (message.trim().isNotEmpty) {
                  _sendMessage(message.trim());
                }
              },
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Colors.blue,
            child: IconButton(
              onPressed: () {
                final message = _messageController.text.trim();
                if (message.isNotEmpty) {
                  _sendMessage(message);
                }
              },
              icon: const Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String message) {
    if (message.trim().isEmpty) return;

    setState(() {
      // Thêm tin nhắn người dùng
      _messages.add(ChatMessage(message: message, isUser: true));
      _isLoading = true;
    });

    _messageController.clear();

    // Giả lập phản hồi AI
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
}
