class ChatMessage {
  final String message;
  final bool isUser;
  final DateTime? timestamp;

  ChatMessage({required this.message, required this.isUser, this.timestamp});
}
