class Comment {
  final String id;
  final String text;
  final DateTime timestamp;

  Comment({
    required this.id,
    required this.text,
    required this.timestamp,
  });

  @override
  String toString() {
    return 'Comment(id: $id, text: $text, timestamp: $timestamp)';
  }
}
