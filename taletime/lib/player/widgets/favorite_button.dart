import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:taletime/common/services/story_service.dart";
import "package:taletime/main.dart";
import "package:taletime/state/profile_state.dart";

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({super.key});

  Widget _buildButton(BuildContext context, String? id) {
    var story = Provider.of<ProfileState>(context).storiesRef?.doc(id);

    return StreamBuilder(
      stream: story?.snapshots(),
      builder: (context, snapshot) {
        var story = snapshot.data?.data();
        if (story == null) {
          return const SizedBox();
        }

        return IconButton(
          icon: Icon(story.liked ? Icons.favorite : Icons.favorite_border),
          color: Colors.teal.shade600,
          onPressed: () {
            StoryService.likeStory(snapshot.data!.reference, !story.liked);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: audioHandler.mediaItem,
        builder: (context, mediaItem) {
          return _buildButton(context, mediaItem.data?.id);
        });
  }
}
