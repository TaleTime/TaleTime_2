/// the class [my_record]enables the user, to play back (listen to)
/// the history . the class offers many functions, such as a button to go forward/back 5/1/15 seconds.
library;
import "dart:async";
import "dart:core";
import "dart:io";
import "package:audioplayers/audioplayers.dart";
import "package:avatar_glow/avatar_glow.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:taletime/common%20utils/decoration_util.dart";
import "package:taletime/common%20utils/tale_time_logger.dart";
import "package:taletime/storyteller/screens/save_or_upload_story.dart";
import "package:taletime/common%20utils/constants.dart";
import "package:taletime/storyteller/utils/record_class.dart";
import "package:taletime/storyteller/utils/sound_recorder.dart";

class MyRecordStory extends StatefulWidget {
  final Story myStory;
  final profile;
  final CollectionReference storiesCollection;
  const MyRecordStory(this.myStory, this.profile, this.storiesCollection, {super.key});

  @override
  State<MyRecordStory> createState() =>
      _MyRecordStoryState(myStory, profile, storiesCollection);
}

class _MyRecordStoryState extends State<MyRecordStory> {
  final logger = TaleTimeLogger.getLogger();
  final Story? myStory;
  final profile;
  final CollectionReference storiesCollection;

  _MyRecordStoryState(this.myStory, this.profile, this.storiesCollection);

  SoundRecorder recorder = SoundRecorder();
  final AudioPlayer player = AudioPlayer();
  bool isPlaying = false;
  // instance of Firebase to use Firebase functions; here: register with email and password
  final FirebaseAuth auth = FirebaseAuth.instance;

  /// Recording-time of the current recording
  Duration recordingTime = Duration.zero;

  /// If [playbackReady] is true the recording can be played by the Audioplayer; is initially set to false
  ///
  /// gets set to true when the current recording is finished
  /// and set to fault if the recording gets discarded.
  bool playbackReady = false;

  /// initiliazes the Recorder and the Audioplayer
  @override
  void initState() {
    super.initState();
    recorder.initRecorder();
  }

  /// disposes the recorder
  @override
  void dispose() {
    super.dispose();
    recorder.dispose();
  }

  /// counts the Recording Time
  void recordTime() {
    var startTime = DateTime.now();
    Timer.periodic(const Duration(seconds: 1), (Timer t) {
      recordingTime = DateTime.now().difference(startTime);

      if (!recorder.isRecording) {
        t.cancel(); //cancel function calling
      }

      setState(() {});
    });
  }

  /// Discards the current recording
  ///
  /// Shows the user a confirm dialog if he really wants to discard the current recording
  ///
  /// sets [playbackReady] to false
  ///
  /// resets [recordingTime] and the path of the recorded file
  void discardRecording() {
    showDialog(
      context: context,
      builder: (context) => Decorations().confirmationDialog(
        "Do you really want to discard the current recording?",
        "",
        context,
        () {
          recorder.closeRecorder();
          setState(() {
            playbackReady = false;
            recordingTime = Duration.zero;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  /// Saves the current recording and redirects the user to the save or upload page
  ///
  /// Creates a recordedStory Object with the recording and the story details from the create stories page
  /// and passes it on to the save or upload page
  void saveRecording() {
    File newAudio = File(recorder.getPath);
    logger
        .v("recorded audioPath: ${recorder.getPath}, recorded audio $newAudio");
    setState(() {});

    MyRecord record = MyRecord(newAudio.path);
    RecordedStory recordedStory = RecordedStory(myStory!, record);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SaveOrUploadStory(
                recordedStory, profile, storiesCollection, false)));
  }

  Widget buildStart() {
    final isRecording = recorder.isRecording;
    final icon = isRecording ? Icons.stop : Icons.mic;
    final text = isRecording ? "STOP" : "START";

    final backgroundColor = isRecording ? Colors.teal.shade100 : kPrimaryColor;

    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(175, 50),
        backgroundColor: backgroundColor,
      ),
      icon: Icon(icon, color: Colors.white),
      label: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
      onPressed: playbackReady
          ? null
          : () {
              if (isRecording) {
                recorder.stop();

                setState(() {
                  playbackReady = true;
                });
              } else {
                recorder.record();
                setState(() {
                  playbackReady = false;
                });
                recordTime();
              }
            },
    );
  }

  Widget buildPlay() {
    final icon = isPlaying ? Icons.stop : Icons.play_arrow;
    final text = isPlaying ? "Stop playing" : "Start Playing";
    final backgroundColor =
        playbackReady ? kPrimaryColor : Colors.grey.shade100;

    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor, minimumSize: const Size(175, 50)),
      icon: Icon(icon, color: Colors.white),
      label: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
      onPressed: playbackReady
          ? () {
              if (isPlaying) {
                player.stop();
                isPlaying = false;
              } else {
                player.play(UrlSource(recorder.getPath));

                setState(() {
                  isPlaying = true;
                });
                player.onPlayerComplete.listen((event) {
                  setState(() {
                    isPlaying = false;
                  });
                });
              }
            }
          : null,
    );
  }

  ///shows the recording time of the current recording
  ///and the text 'Now Recording' or 'Press Start' depending on if the recorder is recording or not
  Widget buildPlayer() {
    final recoder = recorder.isRecording;
    final text = recoder ? "Now Recording" : "Press Start";
    final animate = recoder;

    return AvatarGlow(
      endRadius: 140,
      animate: animate,
      repeatPauseDuration: const Duration(milliseconds: 100),
      child: CircleAvatar(
        radius: 100,
        backgroundColor: Colors.teal.shade100,
        child: CircleAvatar(
          radius: 92,
          backgroundColor: kPrimaryColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "TaleTime",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                printDuration(recordingTime),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 50,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                text,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSave() {
    final backgroundColor =
        playbackReady ? kPrimaryColor : Colors.grey.shade100;
    return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(150, 40),
          backgroundColor: backgroundColor,
        ),
        icon: const Icon(Icons.save_alt, color: Colors.white),
        label: const Text(
          "SAVE",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: playbackReady ? saveRecording : null);
  }

  Widget buildDiscard() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: kPrimaryColor,
          minimumSize: const Size(150, 40)),
      icon: const Icon(Icons.delete_forever, color: Colors.white),
      label: const Text(
        "DISCARD",
        style: TextStyle(color: Colors.white),
      ),
      onPressed: playbackReady ? discardRecording : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Story Recorder",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          )),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 75,
            ),
            buildPlayer(),
            const SizedBox(
              height: 40,
            ),
            buildStart(),
            const SizedBox(
              height: 40,
            ),
            buildPlay(),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildDiscard(),
                const SizedBox(
                  width: 35,
                ),
                buildSave()
              ],
            )
          ],
        ),
      ),
    );
  }
}
