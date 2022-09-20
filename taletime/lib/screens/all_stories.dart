import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taletime/utils/constants.dart';

class AllStories extends StatefulWidget {
  final CollectionReference recordedStoriesCollection;
  const AllStories(this.recordedStoriesCollection, {Key? key}) : super(key: key);

  @override
  State<AllStories> createState() => _AllStoriesState(this.recordedStoriesCollection);
}

class _AllStoriesState extends State<AllStories> {
  final CollectionReference recordedStoriesCollection;
  _AllStoriesState(this.recordedStoriesCollection);

  String name = "AllStories";

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: recordedStoriesCollection.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            final List<QueryDocumentSnapshot> recordedStoriesDocumentSnapshot = streamSnapshot.data!.docs;
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
                            itemCount: recordedStoriesDocumentSnapshot.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: ListTile(
                                  title: Text(recordedStoriesDocumentSnapshot[index]["title"], overflow: TextOverflow.ellipsis,),
                                  subtitle: Text(recordedStoriesDocumentSnapshot[index]["author"], overflow: TextOverflow.ellipsis,),
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
          } else {
            return Center(
              child: CircularProgressIndicator(color: kPrimaryColor,),
            );
          }
        }
        );

     /* Scaffold(
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
        ));*/
  }
}
