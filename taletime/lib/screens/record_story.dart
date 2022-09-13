import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:taletime/utils/decoration_util.dart';

class RecordStory extends StatefulWidget {
  const RecordStory({Key? key}) : super(key: key);

  @override
  State<RecordStory> createState() => _RecordStoryState();
}

class _RecordStoryState extends State<RecordStory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Decorations().appBarDecoration(title: "RecordStory", context: context),
    );
  }
}
