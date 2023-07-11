import "package:audioplayers/audioplayers.dart";
import "package:flutter/material.dart";
import "package:taletime/common%20utils/constants.dart";
import "package:taletime/common%20utils/tale_time_logger.dart";
import "package:share/share.dart";
import "dart:io";
import "package:http/http.dart" as http;
import "package:path_provider/path_provider.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:open_file/open_file.dart";

class MyPlayStory extends StatefulWidget {
  final story;
  final stories;

  //final CollectionReference storiesCollection;
  //final List<Map<String, dynamic>> stories;

  //const MyPlayStory(this.story, this.storiesCollection, this.stories, {Key? key}) : super(key: key);
  const MyPlayStory(this.story, this.stories, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyPlayStoryState(story, stories);
    // return _MyPlayStoryState(story, storiesCollection, stories);
  }
}

class _MyPlayStoryState extends State<MyPlayStory> {
  final logger = TaleTimeLogger.getLogger();
  final story;
  final stories;

  //final CollectionReference storiesCollection;
  //final List<Map<String, dynamic>> stories;

  //_MyPlayStoryState(this.story, this.storiesCollection, this.stories);
  _MyPlayStoryState(this.story, this.stories);
  //_MyPlayStoryState(this.story, this.storiesCollection, this.stories);

  bool isPlaying = false;
  bool isFavorite = false;

  final AudioPlayer player = AudioPlayer();

  double changeVoice = 0.0;
  double _currentValue = 0;

  Duration? duration = const Duration(seconds: 0);

  void initPlayer() async {
    await player.setSource(UrlSource(story["audio"]));
    duration = await player.getDuration();
  }

  @override
  void initState() {
    super.initState();
    initPlayer();
    checkFavoriteStatus();
  }

  displayDoubleDigits(int digit) {
    if (digit < 10) {
      return "0$digit";
    } else {
      return "$digit";
    }
  }

  Future<void> deleteStory(String storyId) {
    return stories.doc(storyId).delete().then((value) {
      logger.v("Story deleted");
      Navigator.of(context).pop();
      setState(() {});
    }).catchError((error) => logger.e("Failed to delete story: $error"));
  }

  Future<String> getLocalPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<void> downloadStory(String storyId, String audioUrl) async {
    try {
      final httpClient = http.Client();
      final response = await httpClient.get(Uri.parse(audioUrl));
      final bytes = response.bodyBytes;

      final localPath = await getLocalPath();
      final file = File("$localPath/story_$storyId.mp3");

      await file.writeAsBytes(bytes);

      Fluttertoast.showToast(
        //checker if story downloaded or not
        msg: "Story downloaded",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } catch (error) {
      print("Failed to download story: $error");
    }
  }

  void shareStory() async {
    try {
      final localPath = await getLocalPath();
      final file = File('$localPath/story_${story['id']}.mp3');
      final text = 'Check out this story: ${story['title']}\n\n${story['author']}';
      await file.writeAsString(text, flush: true);

      Share.shareFiles([(file.path)], text: text);
    } catch (error) {
      logger.e("Failed to share story: $error");
    }
  }

  bool _isStoryDownloaded(String storyId) {
    final localPath = getLocalPath().toString();
    final file = File("$localPath/story_$storyId.mp3");
    return file.existsSync();
  }

  void openDownloadedStory(String storyId) async {
    final localPath = await getLocalPath();
    final file = File("$localPath/story_$storyId.mp3");

    if (file.existsSync()) {
      // Open the file with the default app
      await OpenFile.open(file.path);
    } else {
      Fluttertoast.showToast(
        msg: "Story not downloaded yet",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  void showOptionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Options"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text("Delete Story"),
                  onTap: () {
                    //deleteStory(story["id"]).then((_) {
                    deleteStory(story["id"]).then((_) {
                      Navigator.of(context).pop();
                      //});
                    });
                  }),

              ListTile(
                leading: const Icon(Icons.file_download),
                title: const Text("Download Story"),
                onTap: () {
                  Navigator.of(context).pop();
                  downloadStory(story["id"], story["audio"]);
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
                  }),
              if (_isStoryDownloaded(story["id"]))
                ListTile(
                  leading: const Icon(Icons.open_in_new),
                  title: const Text("Open Downloaded Story"),
                  onTap: () {
                    Navigator.of(context).pop();
                    openDownloadedStory(story["id"]);
                  },
                ),

              // If more options needed
            ],
          ),
        );
      },
    );
  }

  final TextEditingController _commentController = TextEditingController();

  void showAddCommentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Return a dialog to enter the comment
        return AlertDialog(
          title: const Text("Add Comment"),
          content: const TextField(
            // Customize the text field for comment input
            decoration: InputDecoration(hintText: "Enter your comment"),
          ),
          actions: [
            TextButton(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop(); // Cancel the comment
                }),
            TextButton(
              child: const Text("Add"),
              onPressed: () {
                final String commentText = _commentController.text;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> checkFavoriteStatus() async {
    final favoriteSnapshot = await stories.doc(story["id"]).get();
    setState(() {
      isFavorite = story["isLiked"];
    });
  }

  Future<void> toggleFavoriteStatus() async {
    setState(() {
      story["isLiked"] = !story["isLiked"];
      checkFavoriteStatus(); //Check isFavorites Var again after changes
    });
  }

  // void shareStory() {
  //   final String text =
  //       'Check out this story: ${story['title']}\n\n${story['author']}\n\n${story['image']}\n\n${story['audio']}';
  //   Share.share(text); //share functionality method
  // }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Stack(
      children: [
        Positioned(
          top: 10,
          left: 8,
          right: 8,
          child: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.teal.shade600,
              ),
              onPressed: () {
                player.stop();
                Navigator.of(context).pop();
              },
            ),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  toggleFavoriteStatus();
                  setState(() {
                    stories
                        .doc(story["id"])
                        .update({"isLiked": isFavorite})
                        .then((value) => logger.v("List updated"))
                        .catchError((error) => logger.e("Failed to update list: $error"));
                  });
                }, //TODO Monzr BUG FIX (after changing the favorite status the changes are not commited in homepage and favPage)
                icon: isFavorite
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
                  showOptionsDialog(); //I DID THIS
                }, //TODO Monzr
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.teal.shade600,
                ),
              )
            ],
          ),
        ),
        Positioned(
          top: 110,
          left: 10,
          right: 10,
          child: SizedBox(
            height: 300,
            child: Column(
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.transparent,
                  ),
                  child:
                      Image.network(story["image"] == "" ? storyImagePlaceholder : story["image"]),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 360,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.only(top: 7, left: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: screenWidth * 0.8,
                  child: Text(
                    story["title"],
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.teal, fontSize: 21.0, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.8,
                  child: Text(
                    story["author"],
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.teal,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 450,
          left: 10,
          right: 10,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.transparent,
            ),
            child: Column(
              children: [
                SizedBox(
                  width: 300,
                  child: Slider.adaptive(
                      activeColor: kPrimaryColor,
                      inactiveColor: Colors.teal.shade100,
                      value: _currentValue,
                      min: 0.0,
                      max: duration!.inSeconds.toDouble(),
                      onChanged: (double value) {},
                      onChangeEnd: (double value) async {
                        setState(() {
                          _currentValue = value;
                          logger.d("Current Slider value: $_currentValue");
                        });
                        player.pause();
                        await player.seek(Duration(seconds: value.toInt()));
                        await player.resume();
                      }),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${displayDoubleDigits((_currentValue / 60).floor())}:${displayDoubleDigits((_currentValue % 60).floor())}",
                      style: TextStyle(
                          fontSize: 14, color: kPrimaryColor, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "/",
                      style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${displayDoubleDigits(duration!.inMinutes)}:${displayDoubleDigits(duration!.inSeconds % 60)}",
                      style: TextStyle(fontSize: 14, color: kPrimaryColor),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: 200,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          padding: const EdgeInsets.only(top: 4),
                          icon: Icon(
                            Icons.skip_previous,
                            size: 30,
                            color: kPrimaryColor,
                          ),
                          onPressed: () {} //playPreviousStory
                          //() {
                          // setState(() {
                          //   _currentValue = 0;
                          // });
                          //},
                          ),
                      IconButton(
                        padding: const EdgeInsets.only(bottom: 10),
                        icon: isPlaying == false
                            ? Icon(
                                Icons.play_circle_fill,
                                color: kPrimaryColor,
                                size: 50,
                              )
                            : Icon(
                                Icons.pause_circle_filled,
                                color: kPrimaryColor,
                                size: 50,
                              ),
                        onPressed: () async {
                          if (isPlaying) {
                            await player.pause();
                            setState(() {
                              isPlaying = false;
                            });
                          } else {
                            await player.resume();
                            setState(() {
                              isPlaying = true;
                            });
                            player.onPositionChanged.listen((position) {
                              setState(() {
                                _currentValue = position.inSeconds.toDouble();
                              });
                            });
                          }
                          duration = await player.getDuration();
                        },
                      ),
                      IconButton(
                          padding: const EdgeInsets.only(top: 4),
                          icon: Icon(
                            Icons.skip_next,
                            size: 30,
                            color: kPrimaryColor,
                          ),
                          onPressed: () {} //playNextStory,
                          ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 45,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      padding: const EdgeInsets.only(top: 7),
                      icon: Icon(
                        Icons.replay_10,
                        size: 22,
                        color: kPrimaryColor,
                      ),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.queue_music_outlined,
                        size: 22,
                        color: kPrimaryColor,
                      ),
                      onPressed: () {},
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
                      padding: const EdgeInsets.only(top: 7),
                      icon: Icon(
                        Icons.forward_10,
                        size: 22,
                        color: kPrimaryColor,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(
                  height: 45,
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.volume_up_outlined,
                        color: kPrimaryColor,
                      ),
                    ),
                    Expanded(
                        flex: 5,
                        child: Slider(
                          activeColor: kPrimaryColor,
                          inactiveColor: Colors.teal.shade100,
                          min: 0,
                          max: 1,
                          value: changeVoice,
                          onChanged: (val) {
                            setState(() {
                              changeVoice = val;
                              player.setVolume(changeVoice);
                            });
                          },
                        )),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
