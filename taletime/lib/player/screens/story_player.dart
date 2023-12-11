import "package:audio_service/audio_service.dart";
import "package:flutter/material.dart";
import "package:path_provider/path_provider.dart";
import "package:taletime/common%20utils/tale_time_logger.dart";
import "package:taletime/internationalization/localizations_ext.dart";
import "package:taletime/main.dart";
import "package:taletime/player/widgets/player_controls.dart";
import "package:taletime/player/widgets/player_loading_spinner.dart";
import "package:taletime/player/widgets/progress_bar.dart";
import "package:taletime/player/widgets/story_image.dart";
import "package:taletime/player/widgets/story_metadata.dart";

import "../../common/models/added_story.dart";

class StoryPlayer extends StatefulWidget {
  const StoryPlayer({super.key});

  @override
  State<StatefulWidget> createState() => _StoryPlayerState();

  static void playStory(BuildContext context, AddedStory story) {
    audioHandler.playMediaItem(MediaItem(
      id: story.id,
      title: story.title ?? AppLocalizations.of(context)!.noTitle,
      artist: story.author ?? AppLocalizations.of(context)!.noName,
      artUri: Uri.parse(story.imageUrl ?? ""),
      extras: {"url": story.audioUrl ?? ""},
    ));
  }
}

enum PlaybackMode { sequential, random, repeat }

class _StoryPlayerState extends State<StoryPlayer> {
  _StoryPlayerState();

  final logger = TaleTimeLogger.getLogger();

  bool playerFullyInitialized = false;

  @override
  void initState() {
    super.initState();
  }

  Future<String> getLocalPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  bool isContextValid(BuildContext context) {
    final NavigatorState? navigator =
        context.findAncestorStateOfType<NavigatorState>();
    return navigator != null && navigator.mounted;
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
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          const PlayerLoadingSpinner(),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.favorite_border,
              color: Colors.teal.shade600,
            ),
          ),
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
