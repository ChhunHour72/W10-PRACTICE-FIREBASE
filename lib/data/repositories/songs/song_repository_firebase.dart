import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../model/songs/song.dart';
import '../../dtos/song_dto.dart';
import 'song_repository.dart';

class SongRepositoryFirebase extends SongRepository {
  final Uri songsUri = Uri.https(
    'w10-crud-743cd-default-rtdb.asia-southeast1.firebasedatabase.app',
    '/songs.json',
  );

  List<Song>? _cachedSongs;

  @override
  Future<List<Song>> fetchSongs() async {
    if (_cachedSongs != null) {
      return _cachedSongs!;
    }
    final http.Response response = await http.get(songsUri);

    if (response.statusCode == 200) {
      Map<String, dynamic> songJson = json.decode(response.body);

      List<Song> result = [];
      for (final entry in songJson.entries) {
        result.add(SongDto.fromJson(entry.key, entry.value));
      }

      _cachedSongs = result;

      return result;
    } else {
      throw Exception('Failed to load posts');
    }
  }

  @override
  Future<void> likeSong(String songId, int currentLikes) async {
    final Uri likeUri = Uri.https(
      'w10-crud-743cd-default-rtdb.asia-southeast1.firebasedatabase.app',
      '/songs/$songId.json', 
    );

    final response = await http.patch(
      likeUri,
      body: json.encode({
        'likes': currentLikes + 1,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update likes');
    }
  }

  @override
  Future<Song?> fetchSongById(String id) async {}
}
