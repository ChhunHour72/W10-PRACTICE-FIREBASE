import 'package:flutter/material.dart';
import '../view_model/library_item_data.dart';
import 'package:provider/provider.dart';
import '../view_model/library_view_model.dart';

class LibraryItemTile extends StatelessWidget {
  const LibraryItemTile({
    super.key,
    required this.data,
    required this.isPlaying,
    required this.onTap,
  });

  final LibraryItemData data;
  final bool isPlaying;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          onTap: onTap,
          title: Text(data.song.title),
          subtitle: Row(
            children: [
              Text("${data.song.duration.inMinutes} mins"),
              SizedBox(width: 20),
              Text("${data.song.likes} likes", style: const TextStyle(color: Colors.grey)),
              Text(data.artist.name),
              SizedBox(width: 20),
              Text(data.artist.genre),
            ],
          ),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(data.song.imageUrl.toString()),
          ),
          trailing: IconButton(
            icon: Icon(Icons.favorite, color: Colors.blue[200], size: 30),
            onPressed: () {
              context.read<LibraryViewModel>().likeSong(data.song);
            },
          ),
        ),
      ),
    );
  }
}
