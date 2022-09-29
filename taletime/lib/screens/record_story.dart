import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:taletime/screens/save_or_upload_story.dart';
import 'package:taletime/utils/constants.dart';
import 'package:taletime/utils/decoration_util.dart';
import 'package:taletime/utils/record_class.dart';
import 'package:taletime/utils/sound_recorder.dart';

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
        recorder.stop(context, _titleController, records, duration);
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

    recorder.initRecorder(
        "${myStory!.title} ${records.length}", "${myStory!.title}");
  }

  @override
  void dispose() {
    recorder.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Decorations().appBarDecoration(
          title: "Record Story", context: context, automaticArrow: true),
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
                        title: Text(records[index].recordTitle),
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
                            IconButton(
                                onPressed: () {}, icon: const Icon(Icons.edit)),
                            IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Decorations().confirmationDialog(
                                          "Do you really want to remove this part?",
                                          "",
                                          context, () {
                                        setState(() {
                                          records.removeAt(index);
                                          Navigator.of(context).pop();
                                        });
                                      });
                                    },
                                  );
                                },
                                icon: const Icon(
                                    Icons.highlight_remove_outlined)),
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
                              await recorder.stop(
                                  context, _titleController, records, duration);
                            } else {
                              await recorder.record(
                                  "${records.length} ${myStory!.title}");
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const SaveOrUploadStory()));
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
