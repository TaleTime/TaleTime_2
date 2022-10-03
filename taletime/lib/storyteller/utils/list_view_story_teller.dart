///The [list_view] class allows the user to view the list of all stories.
///You can search for a specific story (by title or tags) in the list using the search function and then find it.
///it will show the list of all history of a registered person .
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:taletime/common%20utils/constants.dart';

import 'edit-story.dart';

class ListViewStoryTeller extends StatefulWidget {
  final List stories;
  final CollectionReference storiesCollection;
  final profile;
  final profiles;
  const ListViewStoryTeller(
      this.stories, this.storiesCollection, this.profile, this.profiles,
      {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ListViewStoryTellerState(
        this.stories, this.storiesCollection, this.profile, this.profiles);
  }
}

class _ListViewStoryTellerState extends State<ListViewStoryTeller> {
  late final List stories;
  final CollectionReference storiesCollection;
  final profile;
  final profiles;

  late final String newAudio;
  late final String newImage;
  late final String newTitle;
  late final bool newIsLiked;
  late final String newAuthor;
  late final String newRating;

  _ListViewStoryTellerState(
      this.stories, this.storiesCollection, this.profile, this.profiles);

  CollectionReference allStories =
      FirebaseFirestore.instance.collection('allStories');

  @override
  Widget build(BuildContext context) {
    Future<void> deleteStory(String storyId) {
      return storiesCollection
          .doc(storyId)
          .delete()
          .then((value) => print("story Deleted"))
          .catchError((error) => print("Failed to delete story: $error"));
    }

    Future<void> updateFavoriteList(String storyId) {
      return allStories
          .doc(storyId)
          .update({'id': storyId})
          .then((value) => print("List Updated"))
          .catchError((error) => print("Failed to update List: $error"));
    }

    Future<void> uploadStory(String audio, String author, String image,
        String title, String rating, bool isLiked) {
      return allStories.add({
        'id': "",
        'image': image,
        'audio': audio,
        'title': title,
        'rating': rating,
        'author': author,
        'isLiked': isLiked
      }).then((value) {
        print("Story uploaded succesfully");
        updateFavoriteList(value.id);
      }).catchError((error) => print("Failed to upload story: $error"));
    }

    return Scaffold(
      body: ListView.builder(
        primary: false,
        itemCount: stories.length,
        itemBuilder: (_, index) {
          return Card(
              color: kPrimaryColor,
              child: ListTile(
                leading: Image.network(stories[index]["image"] == ""
                    ? storyImagePlaceholder
                    : stories[index]["image"]),
                title: Text(
                  stories[index]["title"],
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(stories[index]["author"],
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            newAudio = stories[index]["audio"];
                            newImage = stories[index]["image"];
                            newTitle = stories[index]["title"];
                            newIsLiked = false;
                            newAuthor = stories[index]["author"];
                            newRating = stories[index]["rating"];
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      "Upload Story...",
                                      style: TextStyle(color: kPrimaryColor),
                                    ),
                                    content: Text(
                                        "Do you really want to upload this story?"),
                                    actions: [
                                      TextButton(
                                        child: Text(
                                          "Yes",
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    kPrimaryColor)),
                                        onPressed: () {
                                          setState(() {
                                            uploadStory(
                                                newAudio,
                                                newAuthor,
                                                newImage,
                                                newTitle,
                                                newRating,
                                                newIsLiked);
                                            Navigator.of(context).pop();
                                          });
                                        },
                                      ),
                                      TextButton(
                                        child: Text(
                                          "No",
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    kPrimaryColor)),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                });
                          });
                        },
                        icon: const Icon(
                          Icons.upload,
                          color: Colors.white,
                        )),
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditStory(
                                      storiesCollection, stories[index])));
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        )),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      "Delete Story...",
                                      style: TextStyle(color: kPrimaryColor),
                                    ),
                                    content: Text(
                                        "Do you really want to delete this story?"),
                                    actions: [
                                      TextButton(
                                        child: Text(
                                          "Yes",
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    kPrimaryColor)),
                                        onPressed: () {
                                          setState(() {
                                            deleteStory(stories[index]["id"]);
                                            Navigator.of(context).pop();
                                          });
                                        },
                                      ),
                                      TextButton(
                                        child: Text(
                                          "No",
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    kPrimaryColor)),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                });
                          });
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        )),
                  ],
                ),
              ));
        },
      ),
    );
  }
}
