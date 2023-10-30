///the class [recent_stories] shows the list horizontally.
library;

import "package:flutter/material.dart";
import "package:taletime/common%20utils/constants.dart";

class LVRecentStoryTeller extends StatefulWidget {
  final List stories;
  const LVRecentStoryTeller(this.stories, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _LVRecentStoryTellerState();
  }
}

class _LVRecentStoryTellerState extends State<LVRecentStoryTeller> {
  _LVRecentStoryTellerState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///Here the list is displayed horizontally with the help of the Listview.builder.
      body: ListView.builder(
        primary: false,
        scrollDirection: Axis.horizontal,
        itemCount: widget.stories.length,
        itemBuilder: (_, index) {
          return Card(
            child: SizedBox(
              height: 150,
              width: 150,
              child: ListTile(
                leading: Image.network(widget.stories[index]["image"] == ""
                    ? storyImagePlaceholder
                    : widget.stories[index]["image"]),
                title: Text(widget.stories[index]["title"]),
                subtitle: Text(widget.stories[index]["author"]),
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
