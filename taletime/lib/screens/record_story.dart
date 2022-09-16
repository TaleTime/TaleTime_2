import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:taletime/screens/save_or_upload_story.dart';
import 'package:taletime/utils/constants.dart';
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
  final TextEditingController _titleController = TextEditingController();
  String? name = '';
  List<String> partTitles = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //partTitles.add("Test");
  }

  @override
  Widget build(BuildContext context) {
    List<Story> namelist = [];

    return Scaffold(
      appBar: Decorations().appBarDecoration(
          title: "Record Story", context: context, automaticArrow: true),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Container()],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 4,
            child: ListView.builder(
                itemCount: partTitles.length,
                itemBuilder: ((context, index) {
                  return Card(
                      color: kPrimaryColor,
                      child: ListTile(
                        subtitle: Text("Duration: $index"),
                        //title: Text("${namelist[index].title}"),
                        title: Text(partTitles[index]),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.play_circle)),
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
                                          partTitles.removeAt(index);
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
                          onPressed: () {},
                          icon: Icon(
                            Icons.highlight_remove,
                            color: kPrimaryColor,
                          )),
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Container(
                      child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.play_circle_fill,
                            size: 50,
                            color: kPrimaryColor,
                          )),
                    ),
                    flex: 2,
                  ),
                  Expanded(
                    child: Container(
                      child: IconButton(
                          onPressed: () async {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Decorations().confirmationDialog(
                                    "Do you really want to add this part?",
                                    "",
                                    context, () async {
                                  final name = await openDialog(
                                      "Enter a name for your recorded part");
                                  if (name == "" || name == null) {
                                    setState(() {
                                      partTitles.add("Part " +
                                          partTitles.length.toString());
                                    });
                                  } else {
                                    setState(() {
                                      this.name = name;
                                      partTitles.add(name);
                                    });
                                  }
                                  Navigator.of(context).pop();
                                });
                              },
                            );
                          },
                          icon: Icon(Icons.done, color: kPrimaryColor)),
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
    );
  }

  Future<String?> openDialog(String title) => showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(title),
            content: TextField(
              controller: _titleController,
              autofocus: true,
              decoration: InputDecoration(hintText: "Test your input"),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    submit();
                  },
                  child: Text('OK'))
            ],
          ));

  void submit() {
    Navigator.of(context).pop(_titleController.text);
  }
}
