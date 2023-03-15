import "package:audioplayers/audioplayers.dart";
import "package:flutter/material.dart";
import "package:taletime/common%20utils/constants.dart";
import "package:taletime/common%20utils/tale_time_logger.dart";

class MyPlayStory extends StatefulWidget {
  final story;
  const MyPlayStory(this.story, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyPlayStoryState(story);
  }
}

class _MyPlayStoryState extends State<MyPlayStory> {
  final logger = TaleTimeLogger.getLogger();
  final story;

  _MyPlayStoryState(this.story);

  bool isPlaying = false;

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
  }

  displayDoubleDigits(int digit) {
    if (digit < 10) {
      return "0$digit";
    } else {
      return "$digit";
    }
  }

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
                onPressed: () {},
                icon: story["isLiked"]
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
                onPressed: () {},
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
                        onPressed: () {
                          setState(() {
                            _currentValue = 0;
                          });
                        },
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
                        onPressed: () {},
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
                      onPressed: () {},
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
