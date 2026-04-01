import '../../../model/songs/song.dart';
import 'song_repository.dart';

class SongRepositoryMock implements SongRepository {
  final List<Song> _songs = [];
  List<Song>? _cachedSongs;

  @override
  Future<List<Song>> fetchSongs() async {
    if (_cachedSongs != null) {
      return _cachedSongs!;
    }

    final songs = await Future.delayed(const Duration(seconds: 4), () {
      return _songs;
    });

    _cachedSongs = songs;

    return songs;
  }

  @override
  Future<Song?> fetchSongById(String id) async {
    if (_cachedSongs != null) {
      return _cachedSongs!.firstWhere(
        (song) => song.id == id,
        orElse: () => throw Exception("No song with id $id in the database"),
      );
    }

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

  @override
  void clearCache() {
    _cachedSongs = null;
  }
}