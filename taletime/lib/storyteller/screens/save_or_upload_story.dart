//the [save_or_upload_story] class enables the user,
///to either save the story to storage in firebase or share the story with specific listeners or all listeners.
///It contains three functions save ,load,load all

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:taletime/common%20utils/constants.dart';
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
                  TextStyle(fontSize: MediaQuery.of(context).size.height / 15),
            )),
            SizedBox(
              height: 15,
            ),
            Container(
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height / 5,
              child: ElevatedButton(
                style: elevatedButtonDefaultStyle(),
                onPressed: () {},
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(
                      Icons.save,
                      size: 50,
                    ),
                    Text("Save Story")
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Center(
                child: Text(
              "Upload Story",
              style:
                  TextStyle(fontSize: MediaQuery.of(context).size.height / 15),
            )),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 5,
                  width: MediaQuery.of(context).size.width / 3,
                  child: ElevatedButton(
                    style: elevatedButtonDefaultStyle(),
                    onPressed: () {},
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          Icons.upload_rounded,
                          size: 50,
                        ),
                        Text("Share only with users from the same account")
                      ],
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 5,
                  width: MediaQuery.of(context).size.width / 3,
                  child: ElevatedButton(
                    style: elevatedButtonDefaultStyle(),
                    onPressed: () {},
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          Icons.upload_rounded,
                          size: 50,
                        ),
                        Text("Share with every user")
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
