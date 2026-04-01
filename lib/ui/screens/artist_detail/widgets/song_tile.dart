import 'package:flutter/material.dart';
import '../../../../model/songs/song.dart';
import '../../../../ui/theme/theme.dart';

class SongTile extends StatelessWidget {
  const SongTile({super.key, required this.song});

  final Song song;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(song.imageUrl.toString()),
          ),
          title: Text(song.title, style: AppTextStyles.label),
          subtitle: Row(
            children: [
              Text('${song.duration.inMinutes}:${(song.duration.inSeconds % 60).toString().padLeft(2, '0')}'),
              const SizedBox(width: 16),
              Icon(Icons.favorite, size: 16, color: Colors.blue[200]),
              const SizedBox(width: 4),
              Text('${song.likes}'),
            ],
          ),
        ),
      ),
    );
  }
}
