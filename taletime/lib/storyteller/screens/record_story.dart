import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:taletime/storyteller/screens/save_or_upload_story.dart';
import 'package:taletime/common%20utils/constants.dart';
import 'package:taletime/storyteller/utils/record_class.dart';
import 'package:taletime/storyteller/utils/sound_recorder.dart';

class RecordStory extends StatefulWidget {
  final Story? myStory;
  RecordStory(this.myStory);

  @override
  State<RecordStory> createState() => _RecordStoryState(myStory);
}

class _RecordStoryState extends State<RecordStory> {
  final Story? myStory;
  _RecordStoryState(this.myStory);

  final TextEditingController _titleController = TextEditingController();
  final recorder = SoundRecorder();

  Duration duration = Duration(seconds: 0);
  Timer? timer;

  ///
  ///
  ///
  /// TEST
  ///
  ///
  final player = FlutterSoundPlayer();

  ///
  ///
  ///
  ///
  ///
  ///
  ///

  List<Record> records = [];

  void addTime() {
    final addSeconds = 1;
    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      if (seconds == 5) {
        timer!.cancel();
        recorder.stop();
        resetTimer();
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }

  void resetTimer() {
    setState(() {
      duration = Duration();
    });
  }

  @override
  void initState() {
    super.initState();
    player.openPlayer();

    recorder.initRecorder();
  }

  @override
  void dispose() {
    recorder.dispose();

    super.dispose();
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
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${printDuration(duration)}'),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 4,
            child: ListView.builder(
                itemCount: records.length,
                itemBuilder: ((context, index) {
                  return Card(
                      color: kPrimaryColor,
                      child: ListTile(
                        subtitle: Text(
                            "Duration: ${printDuration(records[index].getDuration())}"),
                        //title: Text(records[index].recordTitle),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () async {
                                  bool isPlaying = player.isPlaying;

                                  ///
                                  ///
                                  ///
                                  ///
                                  ///
                                  ///
                                  ///
                                  if (isPlaying) {
                                    player.pausePlayer();
                                  } else {
                                    setState(() {
                                      player.startPlayer(
                                          fromURI: records[index].audio.path);
                                    });
                                  }
                                },
                                icon: Icon(player.isPlaying
                                    ? Icons.pause
                                    : Icons.play_circle)),
                          ],
                        ),
                      ));
                })),
          ),
        ),
        Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                  child: Row(
                children: [
                  Expanded(
                    child: Container(
                      child: IconButton(
                          onPressed: () async {
                            if (recorder.isRecording) {
                              await recorder.stop();
                            } else {
                              await recorder.record();
                              startTimer();
                            }
                            setState(() {});
                          },
                          icon: Icon(
                            recorder.isRecording ? Icons.stop : Icons.mic,
                            size: 50,
                          )),
                    ),
                    flex: 2,
                  ),
                ],
              )),
            ),
            flex: 1),
        Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Center(
                  child: ElevatedButton(
                      onPressed: () {
                        if (records.length > 0) {
                        } else {
                          SnackBar snackBar =
                              SnackBar(content: Text("No recordings added"));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                      child: Text("Continue")),
                ),
              ),
            ),
            flex: 1),
      ]),
    );
  }
}
