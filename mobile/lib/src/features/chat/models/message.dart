class Message {
  final String id;
  final String text;
  final bool isMine;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.text,
    required this.isMine,
    required this.timestamp,
  });
}
