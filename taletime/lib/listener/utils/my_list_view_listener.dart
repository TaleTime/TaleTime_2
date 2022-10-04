import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../common utils/constants.dart';
import '../screens/my_play_story.dart';
import 'icon_context_dialog.dart';

class MyListViewListener extends StatefulWidget {
  final List stories;
  final CollectionReference storiesCollection;
  final profile;
  final profiles;
  const MyListViewListener(
      this.stories, this.storiesCollection, this.profile, this.profiles,
      {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyListViewListenerState(
        this.stories, this.storiesCollection, this.profile, this.profiles);
  }
}

class _MyListViewListenerState extends State<MyListViewListener> {
  final List stories;
  final CollectionReference storiesCollection;
  final profile;
  final profiles;

  late final String newAudio;
  late final String newImage;
  late final String newTitle;
  late final bool newIsLiked;
  late final String newAuthor;
  late final String newRating;
  late final String newId;

  _MyListViewListenerState(
      this.stories, this.storiesCollection, this.profile, this.profiles);

  @override
  Widget build(BuildContext context) {
    CollectionReference favorites =
        profiles.doc(profile["id"]).collection('favoriteList');

    Future<void> updateStory(String storyId, bool isLiked) {
      return storiesCollection
          .doc(storyId)
          .update({'isLiked': isLiked})
          .then((value) =>
              isLiked ? print("Story liked") : print("Story disliked"))
          .catchError((error) => print("Failed to update user: $error"));
    }

    Future<void> updateFavoriteList(String storyId) {
      return favorites
          .doc(storyId)
          .update({'id': storyId})
          .then((value) => print("List Updated"))
          .catchError((error) => print("Failed to update List: $error"));
    }

    Future<void> addStory(
      String audio,
      String author,
      String image,
      String title,
      String rating,
      bool isLiked,
    ) {
      return favorites.add({
        'id': "",
        'image': image,
        'audio': audio,
        'title': title,
        'rating': rating,
        'author': author,
        'isLiked': isLiked
      }).then((value) {
        print("Story Added to favorites");
        updateFavoriteList(value.id);
      }).catchError(
          (error) => print("Failed to add story to favorites: $error"));
    }

    return ListView.builder(
        primary: false,
        itemCount: stories.length,
        itemBuilder: (_, i) {
          bool hasLiked = stories[i]["isLiked"];
          return Container(
            alignment: Alignment.center,
            height: 100,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              color: kPrimaryColor,
              child: ListTile(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return MyPlayStory(stories[i]);
                  }));
                },
                leading: Image.network(stories[i]["image"], fit: BoxFit.fill),
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      stories[i]["rating"],
                    ),
                    Icon(
                      Icons.star,
                      size: 15,
                    )
                  ],
                ),
                isThreeLine: true,
                subtitle: Text(
                  "${stories[i]["title"]}\nBy ${stories[i]["author"]}",
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: hasLiked
                          ? Icon(
                              Icons.favorite,
                              color: Colors.white,
                            )
                          : Icon(
                              Icons.favorite_border,
                              color: Colors.white,
                            ),
                      onPressed: () {
                        if (!hasLiked) {
                          hasLiked = true;
                          updateStory(stories[i]["id"], true);
                          newAudio = stories[i]["audio"];
                          newImage = stories[i]["image"];
                          newTitle = stories[i]["title"];
                          newIsLiked = true;
                          newAuthor = stories[i]["author"];
                          newRating = stories[i]["rating"];
                          addStory(newAudio, newAuthor, newImage, newTitle,
                              newRating, newIsLiked);
                        } else {
                          setState(() {
                            hasLiked = false;
                            updateStory(stories[i]["id"], false);
                            favorites
                                .doc(stories[i]["id"])
                                .delete()
                                .then((value) => print("Story Deleted"))
                                .catchError((error) =>
                                    print("Failed to delete story: $error"));
                          });
                        }
                      },
                    ),
                    IconContextDialog(
                        "Delete Story...",
                        "Do you really want to delete this story?",
                        Icons.delete,
                        stories[i]["id"],
                        storiesCollection),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
