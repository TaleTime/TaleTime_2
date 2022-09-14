import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:taletime/utils/decoration_util.dart';

class SaveOrUploadStory extends StatefulWidget {
  const SaveOrUploadStory({Key? key}) : super(key: key);

  @override
  State<SaveOrUploadStory> createState() => _SaveOrUploadStoryState();
}

class _SaveOrUploadStoryState extends State<SaveOrUploadStory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Decorations()
          .appBarDecoration(title: "Save/Upload Story", context: context),
    );
  }
}
