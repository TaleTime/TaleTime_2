import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:taletime/common%20utils/tale_time_logger.dart";

import "../../common utils/constants.dart";
import "../screens/my_play_story.dart";
import "icon_context_dialog.dart";

class MyListView extends StatefulWidget {
  final List stories;
  final CollectionReference storiesCollection;
  final profile;
  final profiles;
  const MyListView(
      this.stories, this.storiesCollection, this.profile, this.profiles,
      {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyListViewState();
  }
}

class _MyListViewState extends State<MyListView> {
  final logger = TaleTimeLogger.getLogger();

  late final String newAudio;
  late final String newImage;
  late final String newTitle;
  late final bool newIsLiked;
  late final String newAuthor;
  late final String newRating;
  late final String newId;

  final List<IconData> _icons = [
    Icons.favorite,
    Icons.favorite_border,
  ];

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    CollectionReference favorites =
        widget.profiles.doc(widget.profile["id"]).collection("favoriteList");

    Future<void> updateStory(String storyId, bool isLiked) {
      return widget.storiesCollection
          .doc(storyId)
          .update({"isLiked": isLiked})
          .then((value) => logger.v("Story liked/disliked"))
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
      /*String id*/
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
      }).catchError(
          (error) => logger.e("Failed to add story to favorites: $error"));
    }

    return ListView.builder(
        primary: false,
        itemCount: widget.stories.length,
        itemBuilder: (_, i) {
          bool hasLiked = widget.stories[i]["isLiked"];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return MyPlayStory(widget.stories[i]);
              }));
            },
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 85,
                  child: Column(
                    children: [
                      Container(
                        height: 75,
                        margin: const EdgeInsets.only(bottom: 9),
                        padding:
                            const EdgeInsets.only(top: 8, left: 8, bottom: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(11),
                          color: Colors.teal.shade600,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.transparent,
                              ),
                              child: Image.network(
                                  widget.stories[i]["image"] == ""
                                      ? storyImagePlaceholder
                                      : widget.stories[i]["image"],
                                  fit: BoxFit.fill),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: [
                                      Text(
                                        widget.stories[i]["rating"],
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.0),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const Icon(
                                        Icons.star,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: screenWidth * 0.4,
                                    child: Text(
                                      widget.stories[i]["title"],
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: screenWidth * 0.4,
                                    child: Text(
                                      "By ${widget.stories[i]["author"]}",
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: hasLiked == false
                                      ? Icon(
                                          _icons[1],
                                          size: 21,
                                          color: Colors.white,
                                        )
                                      : Icon(
                                          _icons[0],
                                          size: 21,
                                          color: Colors.white,
                                        ),
                                  onPressed: () {
                                    if (!hasLiked) {
                                      setState(() {
                                        hasLiked = true;
                                        updateStory(
                                            widget.stories[i]["id"], true);
                                        newAudio = widget.stories[i]["audio"];
                                        newImage = widget.stories[i]["image"];
                                        newTitle = widget.stories[i]["title"];
                                        newIsLiked = true;
                                        newAuthor = widget.stories[i]["author"];
                                        newRating = widget.stories[i]["rating"];
                                        //newId = stories[i]["id"];
                                        addStory(
                                            newAudio,
                                            newAuthor,
                                            newImage,
                                            newTitle,
                                            newRating,
                                            newIsLiked /*,newId*/);
                                      });
                                    } else {
                                      setState(() {
                                        hasLiked = false;
                                        updateStory(
                                            widget.stories[i]["id"], false);
                                        favorites
                                            .doc(widget.stories[i]["id"])
                                            .delete()
                                            .then((value) =>
                                                logger.v("story Deleted"))
                                            .catchError((error) => logger.e(
                                                "Failed to delete story: $error"));
                                      });
                                    }
                                  },
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                IconContextDialog(
                                    "Delete Story...",
                                    "Do you really want to delete this story?",
                                    Icons.delete,
                                    widget.stories[i]["id"],
                                    widget.storiesCollection),
                                const SizedBox(
                                  width: 1,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
