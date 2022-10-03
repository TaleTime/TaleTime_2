import 'dart:async';
import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
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
  FlutterSoundPlayer player = FlutterSoundPlayer();
  Duration recordingTime = Duration.zero;

  bool playbackReady = false;
  var recordedFile = null;

  @override
  void initState() {
    super.initState();
    recorder.initRecorder();
    player.openPlayer();
  }

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

  Widget buildStart() {
    final isRecording = recorder.isRecording;
    final icon = isRecording ? Icons.stop : Icons.mic;
    final text = isRecording ? "STOP" : "START";
    final foregroundColor = isRecording ? Colors.white : Colors.black;
    final backgroundColor = isRecording ? Colors.teal.shade100 : kPrimaryColor;

    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
          minimumSize: Size(175, 50), backgroundColor: backgroundColor),
      icon: Icon(icon, color: Colors.white),
      label: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
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
    final isPlaying = player.isPlaying;
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
              player.startPlayer(fromURI: recorder.getPath);
            }
          : null,
    );
  }

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
          minimumSize: Size(150, 40),
          primary: kPrimaryColor,
          onPrimary: Colors.black),
      icon: Icon(Icons.delete_forever, color: Colors.white),
      label: Text(
        "DISCARD",
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {},
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
