import '../../../model/songs/song.dart';
import 'song_repository.dart';

class SongRepositoryMock implements SongRepository {
  final List<Song> _songs = [];

  @override
  Future<List<Song>> fetchSongs() async {
    return Future.delayed(const Duration(seconds: 4), () {
      return _songs;
    });
  }

  @override
  Future<Song?> fetchSongById(String id) async {
    return Future.delayed(const Duration(seconds: 4), () {
      return _songs.firstWhere(
        (song) => song.id == id,
        orElse: () => throw Exception("No song with id $id in the database"),
      );
    });
  }

@override
  Future<void> likeSong(String songId, int currentLikes) async {
    return Future.delayed(const Duration(milliseconds: 500));
  }
}