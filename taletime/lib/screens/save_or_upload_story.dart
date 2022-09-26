import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:taletime/utils/constants.dart';
import 'package:taletime/utils/decoration_util.dart';
import 'package:taletime/utils/navbar_widget_speaker.dart';

class SaveOrUploadStory extends StatefulWidget {
  const SaveOrUploadStory({Key? key}) : super(key: key);

  @override
  State<SaveOrUploadStory> createState() => _SaveOrUploadStoryState();
}

class _SaveOrUploadStoryState extends State<SaveOrUploadStory> {
  String name = "Enter a Title your Story";
  String tag = "Tags";
  String add = "Add a Tag";
  TextStyle textStyle = TextStyle(fontSize: 40, color: kPrimaryColor);
  Icon iconsave = Icon(Icons.save);
  Icon iconlade = Icon(Icons.backup);
  Icon iconhome = const Icon(Icons.home);
  Icon iconaddstories = const Icon(Icons.playlist_add);
  Icon iconeinstellung = const Icon(Icons.settings);
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Decorations().appBarDecoration(
            title: "Save/Upload Story", context: context, automaticArrow: true),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: Container(),
                flex: 1,
              ),
              Expanded(
                child: Container(
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: name,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                  ),
                ),
                flex: 1,
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.topLeft,
                  child: Text(tag, style: textStyle),
                ),
                flex: 1,
              ),
              Expanded(
                child: Container(
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: add,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                  ),
                ),
                flex: 1,
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: 12,
                    itemBuilder: (context, index) {
                      return Container();
                    }),
                flex: 6,
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: IconButton(onPressed: () {}, icon: iconsave),
                      flex: 1,
                    ),
                    Expanded(
                      child: IconButton(onPressed: () {}, icon: iconlade),
                      flex: 1,
                    )
                  ],
                ),
                flex: 2,
              )
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() {
            _currentIndex = index;
          }),
          iconSize: 15,
          items: [
            BottomNavigationBarItem(
              icon: iconhome,
              label: 'Home',
              backgroundColor: kPrimaryColor,
            ),
            BottomNavigationBarItem(
              icon: iconaddstories,
              label: 'AddStory',
              backgroundColor: kPrimaryColor,
            ),
            BottomNavigationBarItem(
              icon: iconeinstellung,
              label: 'Setting',
              backgroundColor: kPrimaryColor,
            ),
          ],
        ));
  }
}
