import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

class SharedStoryArguments {
  SharedStoryArguments(this.storyId);

  final String? storyId;
}

class SharedStroy extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SharedStoryState();
}

class SharedStoryState extends State<SharedStroy> {
  @override
  Widget build(BuildContext context) {
    String? storyId = GoRouterState.of(context).uri.queryParameters["storyId"];

    if (storyId == null) {
      return Container(
        color: Colors.yellow,
        child: Text("Keine Story ID",
          style: TextStyle(
            color: Colors.blue
          ),
        ),
      );
    }

    return Container(
      color: Colors.yellow,
      child: SafeArea(
        child: Text(storyId,
          style: TextStyle(
              color: Colors.blue,
             fontSize: 12
          ),),
      ),
    );
  }
}
