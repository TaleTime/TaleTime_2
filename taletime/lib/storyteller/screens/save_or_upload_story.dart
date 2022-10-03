//the [save_or_upload_story] class enables the user,
///to either save the story to storage in firebase or share the story with specific listeners or all listeners.
///It contains three functions save ,load,load all

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:taletime/common%20utils/decoration_util.dart';
import 'package:taletime/storyteller/utils/record_class.dart';

class SaveOrUploadStory extends StatefulWidget {
  final RecordedStory myRecordedStory;
  SaveOrUploadStory(this.myRecordedStory);

  @override
  State<SaveOrUploadStory> createState() =>
      _SaveOrUploadStoryState(myRecordedStory);
}

class _SaveOrUploadStoryState extends State<SaveOrUploadStory> {
  final RecordedStory myRecordedStory;
  _SaveOrUploadStoryState(this.myRecordedStory);

  FlutterSoundPlayer test = FlutterSoundPlayer();
  @override
  void initState() {
    super.initState();
    test.openPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Decorations().appBarDecoration(
          title: "Save/Upload Story", context: context, automaticArrow: true),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Center(
                child: Text(
              "Save",
              style:
                  TextStyle(fontSize: MediaQuery.of(context).size.height / 13),
            )),
            Container(
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height / 4,
              child: Expanded(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow),
                    onPressed: () {
                      test.startPlayer(
                          fromURI: myRecordedStory.recording.getAudioPath());
                    },
                    child: Icon(Icons.save)),
                flex: 1,
              ),
            ),
            Expanded(
              child: IconButton(onPressed: () {}, icon: Icon(Icons.backup)),
              flex: 1,
            )
          ],
        ),
      ),
    );
  }
}
