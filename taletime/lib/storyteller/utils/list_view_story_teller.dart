///The [list_view] class allows the user to view the list of all stories.
///You can search for a specific story (by title or tags) in the list using the search function and then find it.
///it will show the list of all history of a registered person .
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:taletime/common%20utils/constants.dart";
import "package:taletime/storyteller/screens/save_or_upload_story.dart";
import "package:taletime/storyteller/utils/record_class.dart";
import "package:taletime/storyteller/utils/upload_util.dart";

import "edit-story.dart";

class ListViewStoryTeller extends StatefulWidget {
  final List stories;
  final CollectionReference storiesCollection;
  final profile;
  final profiles;
  const ListViewStoryTeller(this.stories, this.storiesCollection, this.profile, this.profiles,
      {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ListViewStoryTellerState(stories, storiesCollection, profile, profiles);
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

  _ListViewStoryTellerState(this.stories, this.storiesCollection, this.profile, this.profiles);

  CollectionReference allStories = FirebaseFirestore.instance.collection("allStories");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        primary: false,
        itemCount: stories.length,
        itemBuilder: (_, index) {
          return Card(
              color: kPrimaryColor,
              child: ListTile(
                leading: Image.network(
                  stories[index]["image"],
                  fit: BoxFit.fill,
                  width: 60,
                ),
                title: Text(
                  stories[index]["title"],
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(stories[index]["author"],
                    overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () {
                          String title = stories[index]["title"];
                          List<String> tags = ["test"];
                          String imagePath = stories[index]["image"];
                          Story story = Story(title, tags, imagePath);
                          Record record = Record(stories[index]["audio"]);

                          RecordedStory recording = RecordedStory(story, record);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SaveOrUploadStory(
                                      recording, profile, storiesCollection, true)));
                          /**
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
                                            UploadUtil(storiesCollection)
                                                .uploadStory(
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
                           */
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
                                  builder: (context) =>
                                      EditStory(storiesCollection, stories[index])));
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
                                    content: const Text("Do you really want to delete this story?"),
                                    actions: [
                                      TextButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(kPrimaryColor)),
                                        onPressed: () {
                                          setState(() {
                                            UploadUtil(storiesCollection)
                                                .deleteStory(stories[index]["id"]);
                                            Navigator.of(context).pop();
                                          });
                                        },
                                        child: const Text(
                                          "Yes",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      TextButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(kPrimaryColor)),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text(
                                          "No",
                                          style: TextStyle(color: Colors.white),
                                        ),
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
