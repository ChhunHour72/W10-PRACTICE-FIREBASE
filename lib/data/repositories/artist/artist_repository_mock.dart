import '../../../model/artist/artist.dart';
import 'artist_repository.dart';

class ArtistRepositoryMock implements ArtistRepository {
  final List<Artist> _artists = [];
  List<Artist>? _cachedArtists;

  @override
  Future<List<Artist>> fetchArtists() async {
    if (_cachedArtists != null) {
      return _cachedArtists!;
    }

    final artists = await Future.delayed(Duration(seconds: 4), () {
      return _artists;
    });

    _cachedArtists = artists;

    return artists;
  }

  @override
  Future<Artist?> fetchArtistById(String id) async {
    if (_cachedArtists != null) {
      return _cachedArtists!.firstWhere(
        (artist) => artist.id == id,
        orElse: () => throw Exception("No artist with id $id in the database"),
      );
    }

    return Future.delayed(Duration(seconds: 4), () {
      return _artists.firstWhere(
        (artist) => artist.id == id,
        orElse: () => throw Exception("No artist with id $id in the database"),
      );
    });
  }

  @override
  void clearCache() {
    _cachedArtists = null;
  }
}
