import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:taletime/screens/save_or_upload_story.dart';
import 'package:taletime/utils/decoration_util.dart';
import 'package:taletime/utils/record_class.dart';
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
    List<Story> namelist = [];
    String name = "Recordstory";
    TextStyle textStyle = const TextStyle(fontSize: 20, color: Colors.white);
    Icon iconvert = const Icon(Icons.more_vert_outlined);
    Color colorfav = Colors.green;
    Icon iconhome = const Icon(Icons.home);
    Icon iconaddstories = const Icon(Icons.playlist_add);
    Icon iconeinstellung = const Icon(Icons.settings);
    int _currentIndex = 0;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            name,
            style: textStyle,
          ),
          actions: [IconButton(onPressed: () {}, icon: iconvert)],
        ),
        body: Column(children: [
          Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.white,
                ),
              ),
              flex: 1),
          Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: 250,
                          height: 250,
                          color: Colors.blue,
                          child: Text("Heute")),
                    ],
                  ),
                ),
              ),
              flex: 3),
          Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: ListView.builder(
                      itemCount: namelist.length,
                      itemBuilder: ((context, index) {
                        return ListTile(
                          leading: Text("${namelist[index].tags}"),
                          title: Text("${namelist[index].title}"),
                          trailing: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.highlight_remove)),
                        );
                      })),
                ),
              ),
              flex: 2),
          Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                    child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        color: Colors.grey[50],
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Container(
                        child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.highlight_remove,
                              color: Colors.green,
                            )),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Container(
                        child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.play_circle_fill,
                              size: 50,
                              color: Colors.green,
                            )),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.done,
                              color: Colors.green,
                            )),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.grey[50],
                      ),
                      flex: 1,
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const SaveOrUploadStory()));
                        },
                        child: Text("Continue")),
                  ),
                ),
              ),
              flex: 1),
        ]),
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
              backgroundColor: colorfav,
            ),
            BottomNavigationBarItem(
              icon: iconaddstories,
              label: 'AddStory',
              backgroundColor: colorfav,
            ),
            BottomNavigationBarItem(
              icon: iconeinstellung,
              label: 'Setting',
              backgroundColor: colorfav,
            ),
          ],
        ));
  }
}
/*
Column(
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
              child: ,)
        ],
      ),
      Decorations()
            .appBarDecoration(title: "RecordStory", context: context),
*/
