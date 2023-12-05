import "dart:math";

import "package:audio_service/audio_service.dart";
import "package:flutter/material.dart";
import "package:path_provider/path_provider.dart";
import "package:taletime/common%20utils/constants.dart";
import "package:taletime/common%20utils/tale_time_logger.dart";
import "package:taletime/internationalization/localizations_ext.dart";
import "package:taletime/main.dart";
import "package:taletime/player/player_loading_spinner.dart";
import "package:taletime/player/progress_bar.dart";
import "package:taletime/settings/downloads.dart";

import '../common/models/added_story.dart';

class MyPlayStory extends StatefulWidget {
  final AddedStory story;
  final List<AddedStory> stories;

  const MyPlayStory(this.story, this.stories, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyPlayStoryState();
  }
}

enum PlaybackMode { sequential, random, repeat }

class _MyPlayStoryState extends State<MyPlayStory> {
  _MyPlayStoryState();

  final logger = TaleTimeLogger.getLogger();

  bool playerFullyInitialized = false;

  // TODO error handling

  @override
  void initState() {
    super.initState();
    audioHandler.playMediaItem(MediaItem(
      id: widget.story.id,
      title: widget.story.title ?? AppLocalizations.of(context)!.noTitle,
      artist: widget.story.author ?? AppLocalizations.of(context)!.noName,
      artUri: Uri.parse(widget.story.imageUrl ?? ""),
      extras: {"url": widget.story.audioUrl ?? ""},
    ));
  }

  Future<void> deleteStory(String storyId) {
    // TODO implement delete logic properly

    return Future(() => null);

    /* return widget.stories.doc(storyId).delete().then((value) {
      logger.v("Story deleted");
      Navigator.of(context).pop();
      setState(() {});
    }).catchError((error) => logger.e("Failed to delete story: $error")); */
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

  void shareStory() async {
    /* try {
      final localPath = await getLocalPath();
      final file = File("$localPath/story_${widget.story.title}.mp3");
      final text =
          'Check out this story: ${widget.story.title}\n\n${widget.story.author}';
      await file.writeAsString(text, flush: true);

      Share.shareFiles([(file.path)], text: text);
    } catch (error) {
      logger.e("Failed to share story: $error");
    } */ // TODO share story
  }

  Future<void> downloadStory() async {
    /* String fileName = "${widget.story.title} - ${widget.story.author}.mp3";
    String? downloadUrl = widget.story.audioUrl;

    if (downloadUrl == null) {
      return Future(() => null);
    }

    final localPath = await getLocalPath();
    final filePath = path.join(localPath, fileName);

    if (await File(filePath).exists()) {
      showSuccessDialog(filePath);
    } else {
      try {
        final response = await http.get(Uri.parse(downloadUrl));
        if (response.statusCode == 200) {
          final totalBytes = response.bodyBytes.length;
          int downloadedBytes = 0;

          if (!context.mounted) return;

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Downloading..."),
                content: StatefulBuilder(
                  builder: (context, setState) {
                    final progress =
                        (downloadedBytes / totalBytes).clamp(0.0, 1.0);
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        LinearProgressIndicator(value: progress),
                        Text("${(progress * 100).toStringAsFixed(2)}%"),
                      ],
                    );
                  },
                ),
              );
            },
          );

          await File(filePath).writeAsBytes(response.bodyBytes, flush: true);

          Navigator.of(context).pop();
          showSuccessDialog(filePath);
        } else {
          Fluttertoast.showToast(
            msg: "Failed to download story",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        }
      } catch (error) {
        Fluttertoast.showToast(
          msg: "Failed to download story: $error",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } */ // TODO download story
  }

  void showSuccessDialog(String filePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Download Success"),
          content: const Text("The story has been downloaded successfully."),
          actions: [
            TextButton(
              child: const Text("View Downloads"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DownloadsPage()),
                );
              },
            ),
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showAddCommentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add Comment"),
          content: const TextField(
            decoration: InputDecoration(hintText: "Enter your comment"),
          ),
          actions: [
            TextButton(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            TextButton(
              child: const Text("Add"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showOptionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Options"),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                ListTile(
                    leading: const Icon(Icons.delete),
                    title: const Text("Delete Story"),
                    onTap: () {
                      deleteStory(widget.story.id).then((_) {
                        Navigator.of(context).pop();
                      });
                    }),
                ListTile(
                  leading: const Icon(Icons.file_download),
                  title: const Text("Download Story"),
                  onTap: () {
                    Navigator.of(context).pop();

                    downloadStory();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.share),
                  title: const Text("Share Story"),
                  onTap: () {
                    Navigator.of(context).pop();
                    shareStory();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.comment),
                  title: const Text("Add Comment"),
                  onTap: () {
                    Navigator.of(context).pop();
                    showAddCommentDialog();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> toggleFavoriteStatus() async {
    // TODO toggle favourite
    return Future(() => null);

    /* bool newStatus = !widget.story.liked;
    await widget.stories
        .doc(widget.story.id)
        .update({"isLiked": newStatus}).then((value) {
      logger.v("List updated");
      setState(() {
        widget.story.liked = newStatus;
        checkFavoriteStatus();
      });
    }).catchError((error) => logger.e("Failed to update list: $error")); */
  }

  // TODO Next / prev story

  // TODO playback mode

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    final imageSize = min(screenHeight, screenWidth) * 0.6;

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
            onPressed: toggleFavoriteStatus,
            icon: widget.story.liked
                ? Icon(
                    Icons.favorite,
                    color: Colors.teal.shade600,
                  )
                : Icon(
                    Icons.favorite_border_sharp,
                    color: Colors.teal.shade600,
                  ),
          ),
          IconButton(
            onPressed: () {
              showOptionsDialog();
            }, //TODO Monzr
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
            child: StreamBuilder<MediaItem?>(
              stream: audioHandler.mediaItem,
              builder: (context, mediaItemSnapshot) {
                return StreamBuilder<PlaybackState>(
                  stream: audioHandler.playbackState,
                  builder: (context, playbackStateSnapshot) {
                    PlaybackState playbackState = playbackStateSnapshot.data ??
                        PlaybackState(
                          updatePosition: Duration.zero,
                          playing: false,
                          processingState: AudioProcessingState.loading,
                        );

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(),
                          Container(
                            width: imageSize,
                            height: imageSize,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.transparent,
                            ),
                            child: Image(
                                fit: BoxFit.cover,
                                image: widget.story.imageUrl != null
                                    ? NetworkImage(widget.story.imageUrl!)
                                    : const AssetImage("assets/logo.png")
                                        as ImageProvider<Object>),
                          ),
                          Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 7),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        widget.story.title ??
                                            AppLocalizations.of(context)!
                                                .noTitle,
                                        softWrap: true,
                                        style: const TextStyle(
                                            color: Colors.teal,
                                            fontSize: 21.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        widget.story.author ??
                                            AppLocalizations.of(context)!
                                                .noName,
                                        softWrap: true,
                                        style: const TextStyle(
                                          color: Colors.teal,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const ProgressBar(),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.transparent,
                                ),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    SizedBox(
                                      width: 200,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          IconButton(
                                              padding:
                                                  const EdgeInsets.only(top: 4),
                                              icon: Icon(
                                                Icons.skip_previous,
                                                size: 30,
                                                color: kPrimaryColor,
                                              ),
                                              onPressed:
                                                  audioHandler.skipToPrevious),
                                          IconButton(
                                            padding: const EdgeInsets.only(
                                                bottom: 10),
                                            // disabledColor: Colors.grey,
                                            // color: kPrimaryColor,
                                            icon: Icon(
                                              playbackState.playing == false
                                                  ? Icons.play_circle_fill
                                                  : Icons.pause_circle_filled,
                                              size: 50,
                                            ),
                                            onPressed: playbackState.playing
                                                ? audioHandler.pause
                                                : audioHandler.play,
                                          ),
                                          IconButton(
                                              padding:
                                                  const EdgeInsets.only(top: 4),
                                              icon: Icon(
                                                Icons.skip_next,
                                                size: 30,
                                                color: kPrimaryColor,
                                              ),
                                              onPressed:
                                                  audioHandler.skipToNext),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        IconButton(
                                            padding:
                                                const EdgeInsets.only(top: 7),
                                            icon: Icon(
                                              Icons.replay_10,
                                              size: 22,
                                              color: kPrimaryColor,
                                            ),
                                            onPressed: () => audioHandler
                                                .seekBackward(false)),
                                        IconButton(
                                          icon: Icon(
                                            Icons.shuffle,
                                            // TODO icon selection
                                            size: 22,
                                            color: kPrimaryColor,
                                          ),
                                          onPressed:
                                              () {}, // TODO change playback mode
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.share_outlined,
                                            size: 22,
                                            color: kPrimaryColor,
                                          ),
                                          onPressed: shareStory,
                                        ),
                                        IconButton(
                                            padding:
                                                const EdgeInsets.only(top: 7),
                                            icon: Icon(
                                              Icons.forward_10,
                                              size: 22,
                                              color: kPrimaryColor,
                                            ),
                                            onPressed: () => audioHandler
                                                .seekForward(false)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
