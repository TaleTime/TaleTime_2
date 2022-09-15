import 'package:flutter/material.dart';
import 'package:taletime/utils/constants.dart';
import '../utils/my_list_view.dart';
import '../utils/search-bar-util.dart';

class Allstories extends StatefulWidget {
  final List stories;
  const Allstories(this.stories, {Key? key}) : super(key: key);

  @override
  State<Allstories> createState() => _AllstoriesState(this.stories);
}

class _AllstoriesState extends State<Allstories> {
  final List stories;
  _AllstoriesState(this.stories);

  String name = "AllStories";
  TextStyle textStyle = TextStyle(fontSize: 20, color: Colors.white);
  Icon iconzuruck = Icon(Icons.delete);

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "AllStories",
            style: textStyle,
          ),
          actions: [IconButton(onPressed: () {}, icon: iconzuruck)],
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
                          title: Text("${stories[index].title}"),
                          subtitle: Text("${stories[index].author}"),
                          trailing: Container(
                            width: 20,
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.favorite),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.edit),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.delete),
                                )
                              ],
                            ),
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
 /*Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              child: ListView.builder(
                  itemCount: Stories.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(Stories[index]['title']),
                        subtitle: Text(Stories[index]['author']),
                        trailing: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.abc),
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),*/