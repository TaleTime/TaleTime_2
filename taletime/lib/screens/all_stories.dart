import 'package:flutter/material.dart';
import 'package:taletime/utils/constants.dart';
import '../utils/my_list_view.dart';
import '../utils/search-bar-util.dart';

class AllStories extends StatefulWidget {
  final List stories;
  const AllStories(this.stories, {Key? key}) : super(key: key);

  @override
  State<AllStories> createState() => _AllStoriesState(this.stories);
}

class _AllStoriesState extends State<AllStories> {
  final List stories;
  _AllStoriesState(this.stories);

  String name = "AllStories";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "All Stories",
          ),
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                height: 500,
                child: ListView.builder(
                    itemCount: stories.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(stories[index]["title"]),
                          subtitle: Text(stories[index]["author"]),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
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
                      );
                    }),
              )
            ],
          ),
        ));
  }
}
