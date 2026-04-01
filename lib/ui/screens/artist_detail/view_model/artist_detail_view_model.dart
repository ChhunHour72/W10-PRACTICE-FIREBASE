import 'package:flutter/material.dart';
import '../../../../data/repositories/artist/artist_repository.dart';
import '../../../../data/repositories/songs/song_repository.dart';
import '../../../../model/artist/artist.dart';
import '../../../../model/artist/comment.dart';
import '../../../../model/songs/song.dart';
import '../../../utils/async_value.dart';

class ArtistDetailViewModel extends ChangeNotifier {
  final ArtistRepository artistRepository;
  final SongRepository songRepository;
  final Artist artist;

  AsyncValue<List<Song>> songsValue = AsyncValue.loading();
  AsyncValue<List<Comment>> commentsValue = AsyncValue.loading();

  ArtistDetailViewModel({
    required this.artistRepository,
    required this.songRepository,
    required this.artist,
  }) {
    fetchData();
  }

  void fetchData() async {
    songsValue = AsyncValue.loading();
    commentsValue = AsyncValue.loading();
    notifyListeners();

    // Fetch songs (filter by artistId from the cached songs list)
    try {
      final allSongs = await songRepository.fetchSongs();
      songsValue = AsyncValue.success(
        allSongs.where((s) => s.artistId == artist.id).toList(),
      );
    } catch (e) {
      songsValue = AsyncValue.error(e);
    }
    notifyListeners();

    // Fetch comments
    try {
      final comments = await artistRepository.fetchComments(artist.id);
      commentsValue = AsyncValue.success(comments);
    } catch (e) {
      commentsValue = AsyncValue.error(e);
    }
    notifyListeners();
  }

  Future<void> addComment(String text) async {
    final newComment = Comment(
      id: '',
      text: text,
      timestamp: DateTime.now(),
    );

    final saved = await artistRepository.addComment(artist.id, newComment);

    if (commentsValue.state == AsyncValueState.success) {
      final updated = List<Comment>.from(commentsValue.data!)..add(saved);
      commentsValue = AsyncValue.success(updated);
      notifyListeners();
    }
  }
}
