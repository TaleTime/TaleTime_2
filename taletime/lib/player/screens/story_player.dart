import "package:audio_service/audio_service.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:taletime/internationalization/localizations_ext.dart";
import "package:taletime/main.dart";
import "package:taletime/player/widgets/favorite_button.dart";
import "package:taletime/player/widgets/player_controls.dart";
import "package:taletime/player/widgets/player_loading_spinner.dart";
import "package:taletime/player/widgets/progress_bar.dart";
import "package:taletime/player/widgets/story_image.dart";
import "package:taletime/player/widgets/story_metadata.dart";
import "package:taletime/state/profile_state.dart";

import "../../common/models/added_story.dart";

enum PlaybackMode { sequential, random, repeat }

class StoryPlayer extends StatelessWidget {
  const StoryPlayer({super.key});

  static void playStory(BuildContext context, AddedStory story) {
    audioHandler.playMediaItem(MediaItem(
      id: story.id,
      title: story.title ?? AppLocalizations.of(context)!.noTitle,
      artist: story.author ?? AppLocalizations.of(context)!.noName,
      artUri: story.imageUrl != null ? Uri.parse(story.imageUrl!) : null,
      extras: {
        // This might be an invalid url, but the player will detect this and
        // go into the error state
        "url": story.audioUrl ?? ""
      },
    ));

    // Set timestamp
    var storyRef = Provider.of<ProfileState>(context, listen: false)
        .storiesRef!
        .doc(story.id);
    storyRef
        .update({"timeLastListened": DateTime.now().millisecondsSinceEpoch});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.teal.shade600,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        actions: <Widget>[
          const PlayerLoadingSpinner(),
          FavoriteButton(),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.more_vert,
              color: Colors.teal.shade600,
            ),
          )
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // This is a dummy box so that spaceBetween will set
                  // equal amount of space above and below the image.
                  SizedBox(),
                  StoryImage(),
                  Column(
                    children: [
                      StoryMetadata(),
                      ProgressBar(),
                      PlayerControls(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
