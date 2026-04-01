import 'dart:convert';

import 'package:http/http.dart' as http;
 
import '../../../model/artist/artist.dart';
import '../../../model/artist/comment.dart';
import '../../dtos/artist_dto.dart';
import '../../dtos/comment_dto.dart';
import 'artist_repository.dart';

class ArtistRepositoryFirebase implements ArtistRepository {
  final Uri artistsUri = Uri.https(
    'test-a2a77-default-rtdb.asia-southeast1.firebasedatabase.app',
    '/artists.json',
  );

  List<Artist>? _cachedArtists;

  @override
  Future<List<Artist>> fetchArtists() async {
    if (_cachedArtists != null) {
      return _cachedArtists!;
    }

    final http.Response response = await http.get(artistsUri);

    if (response.statusCode == 200) {
      Map<String, dynamic> artistJson = json.decode(response.body);

      List<Artist> result = [];
      for (final entry in artistJson.entries) {
        result.add(ArtistDto.fromJson(entry.key, entry.value));
      }

      _cachedArtists = result;

      return result;
    } else {
      throw Exception('Failed to load posts');
    }
  }

  @override
  Future<Artist?> fetchArtistById(String id) async {}

  @override
  Future<List<Comment>> fetchComments(String artistId) async {
    final uri = Uri.https(
      'test-a2a77-default-rtdb.asia-southeast1.firebasedatabase.app',
      '/comments/$artistId.json',
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      if (body == null) return [];

      final Map<String, dynamic> commentJson = body;
      return commentJson.entries
          .map((e) => CommentDto.fromJson(e.key, e.value))
          .toList();
    } else {
      throw Exception('Failed to load comments');
    }
  }

  @override
  Future<Comment> addComment(String artistId, Comment comment) async {
    final uri = Uri.https(
      'test-a2a77-default-rtdb.asia-southeast1.firebasedatabase.app',
      '/comments/$artistId.json',
    );

    final response = await http.post(
      uri,
      body: json.encode(CommentDto.toJson(comment)),
    );

    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      final generatedId = responseJson['name'] as String;
      return Comment(id: generatedId, text: comment.text, timestamp: comment.timestamp);
    } else {
      throw Exception('Failed to post comment');
    }
  }

  @override
  void clearCache() {
    _cachedArtists = null;
  }
}
