import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:taletime/common%20utils/decoration_util.dart';
import 'package:taletime/storyteller/screens/save_or_upload_story.dart';
import 'package:taletime/common%20utils/constants.dart';
import 'package:taletime/storyteller/utils/record_class.dart';
import 'package:taletime/storyteller/utils/sound_recorder.dart';

class MyRecordStory extends StatefulWidget {
  final Story? myStory;
  MyRecordStory(this.myStory);

  @override
  State<MyRecordStory> createState() => _MyRecordStoryState(myStory);
}

class _MyRecordStoryState extends State<MyRecordStory> {
  final Story? myStory;
  _MyRecordStoryState(this.myStory);

  SoundRecorder recorder = SoundRecorder();
  //FlutterSoundPlayer player = FlutterSoundPlayer();
  final AudioPlayer player = AudioPlayer();
  bool isPlaying = false;

  /// Recording-time of the current recording
  Duration recordingTime = Duration.zero;

  /// If [playbackReady] is true the recording can be played by the Audioplayer; is initially set to false
  ///
  /// gets set to true when the current recording is finished
  /// and set to fault if the recording gets discarded.
  bool playbackReady = false;
  var recordedFile = null;

  void initPlayer() async {
    await player.setSource(UrlSource(recorder.getPath));
  }

  /// initiliazes the Recorder and the Audioplayer
  @override
  void initState() {
    super.initState();
    recorder.initRecorder();
    initPlayer();
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
            recordedFile = null;
            recorder.path = '';
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
    File recording = File(recorder.getPath);
    Record record = new Record(recording, recordingTime);
    RecordedStory recordedStory = new RecordedStory(myStory!, record);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SaveOrUploadStory(recordedStory)));
  }

  Widget buildStart() {
    final isRecording = recorder.isRecording;
    final icon = isRecording ? Icons.stop : Icons.mic;
    final text = isRecording ? "STOP" : "START";

    final backgroundColor = isRecording ? Colors.teal.shade100 : kPrimaryColor;

    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(175, 50),
        backgroundColor: backgroundColor,
      ),
      icon: Icon(icon, color: Colors.white),
      label: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
      onPressed: playbackReady
          ? null
          : () {
              if (isRecording) {
                recordedFile = recorder.stop();

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
          backgroundColor: backgroundColor, minimumSize: Size(175, 50)),
      icon: Icon(icon, color: Colors.white),
      label: Text(
        text,
        style: TextStyle(color: Colors.white),
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
      repeatPauseDuration: Duration(milliseconds: 100),
      child: CircleAvatar(
        radius: 100,
        backgroundColor: Colors.teal.shade100,
        child: CircleAvatar(
          radius: 92,
          backgroundColor: kPrimaryColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "TaleTime",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                printDuration(recordingTime),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 50,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                text,
                style: TextStyle(color: Colors.white, fontSize: 12),
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
          minimumSize: Size(150, 40),
          backgroundColor: backgroundColor,
        ),
        icon: Icon(Icons.save_alt, color: Colors.white),
        label: Text(
          "SAVE",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: playbackReady
            ? () {
                File recording = File(recorder.getPath);
                Record record = new Record(recording, recordingTime);
                RecordedStory recordedStory =
                    new RecordedStory(myStory!, record);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SaveOrUploadStory(recordedStory)));
              }
            : null);
  }

  Widget buildDiscard() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: kPrimaryColor,
          minimumSize: Size(150, 40)),
      icon: Icon(Icons.delete_forever, color: Colors.white),
      label: Text(
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
          title: Text(
            "Story Recorder",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          )),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 75,
            ),
            buildPlayer(),
            SizedBox(
              height: 40,
            ),
            buildStart(),
            SizedBox(
              height: 40,
            ),
            buildPlay(),
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildDiscard(),
                SizedBox(
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
