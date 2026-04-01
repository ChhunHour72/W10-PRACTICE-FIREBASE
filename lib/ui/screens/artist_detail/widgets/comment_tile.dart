import 'package:flutter/material.dart';
import '../../../../model/artist/comment.dart';
import '../../../../ui/theme/theme.dart';

class CommentTile extends StatelessWidget {
  const CommentTile({super.key, required this.comment});

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          leading: const CircleAvatar(
            child: Icon(Icons.person),
          ),
          title: Text(comment.text, style: AppTextStyles.label),
          subtitle: Text(
            _formatDate(comment.timestamp),
            style: TextStyle(color: AppColors.textLight, fontSize: 12),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}  ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
