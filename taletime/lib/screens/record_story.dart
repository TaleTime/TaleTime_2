import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:taletime/screens/save_or_upload_story.dart';
import 'package:taletime/utils/decoration_util.dart';
import 'package:taletime/utils/record_class.dart';

class RecordStory extends StatefulWidget {
  final Story? myStory;
  RecordStory(this.myStory);

  @override
  State<RecordStory> createState() => _RecordStoryState();
}

class _RecordStoryState extends State<RecordStory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Decorations()
          .appBarDecoration(title: "RecordStory", context: context),
      body: Column(
        children: [
          SizedBox(
            height: 100,
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SaveOrUploadStory()));
              },
              child: Text("Continue"))
        ],
      ),
    );
  }
}
