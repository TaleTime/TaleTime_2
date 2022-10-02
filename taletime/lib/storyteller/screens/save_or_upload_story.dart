import 'package:flutter/material.dart';
import 'package:taletime/common%20utils/decoration_util.dart';

class SaveOrUploadStory extends StatefulWidget {
  const SaveOrUploadStory({Key? key}) : super(key: key);

  @override
  State<SaveOrUploadStory> createState() => _SaveOrUploadStoryState();
}

class _SaveOrUploadStoryState extends State<SaveOrUploadStory> {
  Icon iconsave = Icon(Icons.save);
  Icon iconlade = Icon(Icons.backup);

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
                child: IconButton(onPressed: () {}, icon: iconsave),
                flex: 1,
              ),
            ),
            Expanded(
              child: IconButton(onPressed: () {}, icon: iconlade),
              flex: 1,
            )
          ],
        ),
      ),
    );
  }
}
