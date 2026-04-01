import '../../model/artist/comment.dart';

class CommentDto {
  static const String textKey = 'text';
  static const String timestampKey = 'timestamp';

  static Comment fromJson(String id, Map<String, dynamic> json) {
    assert(json[textKey] is String);
    assert(json[timestampKey] is int);

    return Comment(
      id: id,
      text: json[textKey],
      timestamp: DateTime.fromMillisecondsSinceEpoch(json[timestampKey]),
    );
  }

  static Map<String, dynamic> toJson(Comment comment) {
    return {
      textKey: comment.text,
      timestampKey: comment.timestamp.millisecondsSinceEpoch,
    };
  }
}
