import 'package:flutter/material.dart';
import 'package:taletime/common%20utils/decoration_util.dart';
import 'package:taletime/storyteller/utils/record_class.dart';

class SaveOrUploadStory extends StatefulWidget {
  final RecordedStory myStory;
  SaveOrUploadStory(this.myStory);

  @override
  State<SaveOrUploadStory> createState() => _SaveOrUploadStoryState(myStory);
}

class _SaveOrUploadStoryState extends State<SaveOrUploadStory> {
  final RecordedStory myStory;
  _SaveOrUploadStoryState(this.myStory);
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
              child: Expanded(
                child: IconButton(onPressed: () {}, icon: Icon(Icons.save)),
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
