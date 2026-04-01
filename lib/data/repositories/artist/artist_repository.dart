import '../../../model/artist/artist.dart';
import '../../../model/artist/comment.dart';

abstract class ArtistRepository {
  Future<List<Artist>> fetchArtists();

  Future<Artist?> fetchArtistById(String id);
  void clearCache();

  Future<List<Comment>> fetchComments(String artistId);
  Future<Comment> addComment(String artistId, Comment comment);
}
