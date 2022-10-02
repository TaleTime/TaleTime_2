import 'package:flutter/material.dart';
import 'package:taletime/common%20utils/constants.dart';

class LVRecentStoryTeller extends StatefulWidget {
  final List stories;
  LVRecentStoryTeller(this.stories, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LVRecentStoryTellerState(this.stories);
  }
}

class _LVRecentStoryTellerState extends State<LVRecentStoryTeller> {
  late final List stories;
  _LVRecentStoryTellerState(this.stories);
//hier wird die liste gezeigt
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        primary: false,
        scrollDirection: Axis.horizontal,
        itemCount: stories.length,
        itemBuilder: (_, index) {
          return Card(
            child: SizedBox(
              height: 150,
              width: 150,
              child: ListTile(
                leading: Image.network(stories[index]["image"] == ""
                    ? storyImagePlaceholder
                    : stories[index]["image"]),
                title: Text(stories[index]["title"]),
                subtitle: Text(stories[index]["author"]),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.upload),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
