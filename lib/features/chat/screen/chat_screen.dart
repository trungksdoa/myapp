import 'package:flutter/material.dart';
import 'package:myapp/features/auth/service/auth_service.dart';
import 'package:myapp/features/auth/service/interface/i_auth_service.dart';
import 'package:myapp/features/chat/widgets/chat_empty_state_widget.dart';
import 'package:myapp/features/chat/widgets/chat_input_area_widget.dart';
import 'package:myapp/features/chat/widgets/chat_message_list_widget.dart';
import 'package:myapp/features/chat/service/chat_service.dart';
import 'package:myapp/shared/model/chart_message.dart';

class ChatScreen extends StatefulWidget {
  final String? initialMessage;
  final String? petName;
  final String? petId;

  const ChatScreen({super.key, this.initialMessage, this.petName, this.petId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  final ChatService _chatService = ChatService();
  final IAuthService _authService = AuthService();

  String? get currentUserId => _authService.userId;
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
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(message: message, isUser: true));
      _isLoading = true;
    });

    _messageController.clear();
    _scrollToBottom();

    try {
      final response = await _chatService.sendMessage(message, currentUserId);
      if (mounted) {
        setState(() {
          _messages.add(ChatMessage(message: response, isUser: false));
          _isLoading = false;
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add(
            ChatMessage(
              message: 'Xin lỗi, có lỗi xảy ra. Vui lòng thử lại!',
              isUser: false,
            ),
          );
          _isLoading = false;
        });
        _scrollToBottom();

        // Show error snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi kết nối: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Thử lại',
              textColor: Colors.white,
              onPressed: () => _sendMessage(message),
            ),
          ),
        );
      }
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallDevice = size.height < 700;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF4A90A4),
        foregroundColor: Colors.white,
        centerTitle: false,
        title: Row(
          children: [
            // Pet Avatar
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(Icons.pets, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.petName ?? 'Thú cưng',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Trợ lý thú y AI',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.8),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          // Info button
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              _showInfoDialog();
            },
            tooltip: 'Thông tin',
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages Area
          Expanded(
            child: _messages.isEmpty
                ? const ChatEmptyStateWidget()
                : Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F0),
                      image: DecorationImage(
                        image: const AssetImage('assets/images/chat_bg.png'),
                        fit: BoxFit.cover,
                        opacity: 0.03,
                        onError: (_, __) {},
                      ),
                    ),
                    child: ChatMessagesListWidget(
                      messages: _messages,
                      isLoading: _isLoading,
                      scrollController: _scrollController,
                    ),
                  ),
          ),

          // Input Area
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  16,
                  isSmallDevice ? 8 : 12,
                  16,
                  isSmallDevice ? 8 : 12,
                ),
                child: ChatInputAreaWidget(
                  controller: _messageController,
                  onSendMessage: _sendMessage,
                  isLoading: _isLoading,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF4A90A4).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.info_outline, color: Color(0xFF4A90A4)),
            ),
            const SizedBox(width: 12),
            const Text('Trợ lý thú y AI'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tôi là trợ lý AI chuyên tư vấn về sức khỏe động vật nhỏ.',
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              Icons.check_circle_outline,
              'Tư vấn về triệu chứng bệnh',
            ),
            _buildInfoRow(
              Icons.check_circle_outline,
              'Hướng dẫn chăm sóc cơ bản',
            ),
            _buildInfoRow(
              Icons.check_circle_outline,
              'Thông tin dựa trên tài liệu y học',
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber,
                    color: Colors.orange[700],
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Lưu ý: Thông tin chỉ mang tính tham khảo. Hãy tham khảo bác sĩ thú y.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange[900],
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF4A90A4)),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}
