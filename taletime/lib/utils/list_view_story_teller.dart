import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:taletime/utils/constants.dart';

class ListViewStoryTeller extends StatefulWidget {
  final List stories;
  const ListViewStoryTeller(this.stories, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ListViewStoryTellerState(this.stories);
  }
}

class _ListViewStoryTellerState extends State<ListViewStoryTeller> {
  late final List stories;
  _ListViewStoryTellerState(this.stories);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        primary: false,
        itemCount: stories.length,
        itemBuilder: (_, index) {
          return Card(
            shape: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
              color: kPrimaryColor,
              child: ListTile(
                
                leading: Image.network(stories[index]["image"] == ""
                    ? storyImagePlaceholder
                    : stories[index]["image"]),
                title: Text(stories[index]["title"]),
                subtitle: Text(stories[index]["author"]),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () {}, icon: const Icon(Icons.upload)),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
                    IconButton(
                        onPressed: () {}, icon: const Icon(Icons.delete)),
                  ],
                ),
              ));
        },
      ),
    );
  }
}
