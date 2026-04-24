class Message {
  final String id;
  final String text;
  final bool isMe;
  final String time;
  final MessageStatus status;

  const Message({
    required this.id,
    required this.text,
    required this.isMe,
    required this.time,
    this.status = MessageStatus.read,
  });
}

enum MessageStatus { sending, sent, delivered, read }