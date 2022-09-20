import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:taletime/utils/constants.dart';

import 'edit-story.dart';

class ListViewStoryTeller extends StatefulWidget {
  final List stories;
  final CollectionReference storiesCollection;
  final profile;
  final profiles;
  const ListViewStoryTeller(this.stories, this.storiesCollection, this.profile, this.profiles, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ListViewStoryTellerState(this.stories, this.storiesCollection, this.profile, this.profiles);
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

  CollectionReference allStories = FirebaseFirestore.instance.collection('allStories');

  @override
  Widget build(BuildContext context) {

    /*Future<void> updateStory(String storyId, bool isLiked) {
      return storiesCollection
          .doc(storyId)
          .update({'isLiked': isLiked})
          .then((value) => print("Story liked/disliked"))
          .catchError((error) => print("Failed to update user: $error"));
    }*/

    Future<void> deleteStory(String storyId) {
      return storiesCollection.doc(storyId).delete()
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

    Future<void> uploadStory(
        String audio,
        String author,
        String image,
        String title,
        String rating,
        bool isLiked) {
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
                title: Text(stories[index]["title"], overflow: TextOverflow.ellipsis,),
                subtitle: Text(stories[index]["author"], overflow: TextOverflow.ellipsis,),
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
                            uploadStory(newAudio,newAuthor,newImage,newTitle,newRating,newIsLiked);
                          });
                        }, icon: const Icon(Icons.upload)),
                    IconButton(onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditStory(storiesCollection, stories[index])));
                    }, icon: const Icon(Icons.edit)),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            deleteStory(stories[index]["id"]);
                          });
                        }, icon: const Icon(Icons.delete)),
                  ],
                ),
              ));
        },
      ),
    );
  }
}
