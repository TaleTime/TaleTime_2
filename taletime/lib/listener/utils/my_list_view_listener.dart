import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:taletime/common%20utils/tale_time_logger.dart";

import "../../common utils/constants.dart";
import "../screens/my_play_story.dart";
import "icon_context_dialog.dart";

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
    return _MyListViewListenerState();
  }
}

class _MyListViewListenerState extends State<MyListViewListener> {
  final logger = TaleTimeLogger.getLogger();

  late final String newAudio;
  late final String newImage;
  late final String newTitle;
  late final bool newIsLiked;
  late final String newAuthor;
  late final String newRating;
  late final String newId;

  @override
  Widget build(BuildContext context) {
    CollectionReference favorites =
        widget.profiles.doc(widget.profile["id"]).collection("favoriteList");

    Future<void> updateStory(String storyId, bool isLiked) {
      return widget.storiesCollection
          .doc(storyId)
          .update({"isLiked": isLiked})
          .then((value) =>
              isLiked ? logger.v("Story liked") : logger.v("Story disliked"))
          .catchError((error) => logger.e("Failed to update user: $error"));
    }

    Future<void> updateFavoriteList(String storyId) {
      return favorites
          .doc(storyId)
          .update({"id": storyId})
          .then((value) => logger.v("List Updated"))
          .catchError((error) => logger.e("Failed to update List: $error"));
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
        "id": "",
        "image": image,
        "audio": audio,
        "title": title,
        "rating": rating,
        "author": author,
        "isLiked": isLiked
      }).then((value) {
        logger.v("Story Added to favorites");
        updateFavoriteList(value.id);
      }).catchError((error) async {
        logger.e("Failed to add story to favorites: $error");
        return null;
      });
    }

    return ListView.builder(
        primary: false,
        itemCount: widget.stories.length,
        itemBuilder: (_, i) {
          bool hasLiked = widget.stories[i]["isLiked"];
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
                    return MyPlayStory(widget.stories[i]);
                  }));
                },
                leading:
                    Image.network(widget.stories[i]["image"], fit: BoxFit.fill),
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.stories[i]["rating"],
                    ),
                    const Icon(
                      Icons.star,
                      size: 15,
                    )
                  ],
                ),
                isThreeLine: true,
                subtitle: Text(
                  "${widget.stories[i]["title"]}\nBy ${widget.stories[i]["author"]}",
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: hasLiked
                          ? const Icon(
                              Icons.favorite,
                              color: Colors.white,
                            )
                          : const Icon(
                              Icons.favorite_border,
                              color: Colors.white,
                            ),
                      onPressed: () {
                        if (!hasLiked) {
                          hasLiked = true;
                          updateStory(widget.stories[i]["id"], true);
                          newAudio = widget.stories[i]["audio"];
                          newImage = widget.stories[i]["image"];
                          newTitle = widget.stories[i]["title"];
                          newIsLiked = true;
                          newAuthor = widget.stories[i]["author"];
                          newRating = widget.stories[i]["rating"];
                          addStory(newAudio, newAuthor, newImage, newTitle,
                              newRating, newIsLiked);
                        } else {
                          setState(() {
                            hasLiked = false;
                            updateStory(widget.stories[i]["id"], false);
                            favorites
                                .doc(widget.stories[i]["id"])
                                .delete()
                                .then((value) => logger.v("Story Deleted"))
                                .catchError((error) =>
                                    logger.e("Failed to delete story: $error"));
                          });
                        }
                      },
                    ),
                    IconContextDialog(
                        "Delete Story...",
                        "Do you really want to delete this story?",
                        Icons.delete,
                        widget.stories[i]["id"],
                        widget.storiesCollection),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
