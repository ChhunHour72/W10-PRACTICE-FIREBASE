import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../model/artist/comment.dart';
import '../../../../model/songs/song.dart';
import '../../../theme/theme.dart';
import '../../../utils/async_value.dart';
import '../view_model/artist_detail_view_model.dart';
import 'comment_tile.dart';
import 'song_tile.dart';

class ArtistDetailContent extends StatefulWidget {
  const ArtistDetailContent({super.key});

  @override
  State<ArtistDetailContent> createState() => _ArtistDetailContentState();
}

class _ArtistDetailContentState extends State<ArtistDetailContent> {
  final TextEditingController _commentController = TextEditingController();
  bool _isPosting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitComment(ArtistDetailViewModel vm) async {
    final text = _commentController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comment cannot be empty')),
      );
      return;
    }

    setState(() => _isPosting = true);
    try {
      await vm.addComment(text);
      _commentController.clear();
    } finally {
      setState(() => _isPosting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ArtistDetailViewModel>();
    final artist = vm.artist;

    return Scaffold(
      appBar: AppBar(
        title: Text(artist.name),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Artist header
          Row(
            children: [
              CircleAvatar(
                radius: 36,
                backgroundImage: NetworkImage(artist.imageUrl.toString()),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(artist.name, style: AppTextStyles.body),
                  Text(artist.genre, style: AppTextStyles.title),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Songs section
          Text('Songs', style: AppTextStyles.heading),
          const SizedBox(height: 8),
          _buildSongs(vm),

          const SizedBox(height: 24),

          // Comments section
          Text('Comments', style: AppTextStyles.heading),
          const SizedBox(height: 8),
          _buildComments(vm),

          // Extra bottom padding so content isn't hidden behind the input bar
          const SizedBox(height: 80),
        ],
      ),
      bottomNavigationBar: _buildCommentInput(vm),
    );
  }

  Widget _buildSongs(ArtistDetailViewModel vm) {
    final asyncSongs = vm.songsValue;
    switch (asyncSongs.state) {
      case AsyncValueState.loading:
        return const Center(child: CircularProgressIndicator());
      case AsyncValueState.error:
        return Text('Error: ${asyncSongs.error}',
            style: const TextStyle(color: Colors.red));
      case AsyncValueState.success:
        final List<Song> songs = asyncSongs.data!;
        if (songs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text('No songs available for this artist.'),
          );
        }
        return Column(
          children: songs.map((s) => SongTile(song: s)).toList(),
        );
    }
  }

  Widget _buildComments(ArtistDetailViewModel vm) {
    final asyncComments = vm.commentsValue;
    switch (asyncComments.state) {
      case AsyncValueState.loading:
        return const Center(child: CircularProgressIndicator());
      case AsyncValueState.error:
        return Text('Error: ${asyncComments.error}',
            style: const TextStyle(color: Colors.red));
      case AsyncValueState.success:
        final List<Comment> comments = asyncComments.data!;
        if (comments.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text('No comments yet. Be the first to comment!'),
          );
        }
        return Column(
          children: comments.map((c) => CommentTile(comment: c)).toList(),
        );
    }
  }

  Widget _buildCommentInput(ArtistDetailViewModel vm) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: 'Add a comment…',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _submitComment(vm),
              ),
            ),
            const SizedBox(width: 8),
            _isPosting
                ? const SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(),
                  )
                : IconButton(
                    icon: const Icon(Icons.send),
                    color: AppColors.neutral,
                    onPressed: () => _submitComment(vm),
                  ),
          ],
        ),
      ),
    );
  }
}
