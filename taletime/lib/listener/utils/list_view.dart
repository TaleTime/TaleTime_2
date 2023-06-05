import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:taletime/common%20utils/tale_time_logger.dart";
import "../../common utils/constants.dart";
import "../screens/my_play_story.dart";
import "icon_context_dialog.dart";

class ListViewData extends StatefulWidget {
  final List stories;
  final CollectionReference storiesCollection;
  final profile;
  final profiles;
  String listType;
  ListViewData(this.stories, this.storiesCollection, this.profile, this.profiles, this.listType,
      {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ListViewDataState(stories, storiesCollection, profile, profiles, listType);
  }
}

class _ListViewDataState extends State<ListViewData> {
  final logger = TaleTimeLogger.getLogger();
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

  String listType;

  final List<IconData> _icons = [
    Icons.favorite,
    Icons.favorite_border,
  ];

  _ListViewDataState(
      this.stories, this.storiesCollection, this.profile, this.profiles, this.listType);

  @override
  Widget build(context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    CollectionReference favorites = profiles.doc(profile["id"]).collection("favoriteList");

    Future<void> updateStory(String storyId, bool isLiked) {
      return storiesCollection
          .doc(storyId)
          .update({"isLiked": isLiked})
          .then((value) => listType == "userStroiesList"
              ? logger.v("Story liked/disliked")
              : isLiked
                  ? logger.v("Story liked")
                  : logger.v("Story disliked"))
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
      }).catchError((error) => logger.e("Failed to add story to favorites: $error"));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: storiesCollection.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); //loading
        }

        List<Map<String, dynamic>> stories =
            snapshot.data?.docs.map((doc) => doc.data() as Map<String, dynamic>).toList() ?? [];
        if (listType == "userStroiesList") {
          return ListView.builder(
            primary: false,
            itemCount: stories.length,
            itemBuilder: (_, i) {
              bool hasLiked = stories[i]["isLiked"];
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                    return MyPlayStory(stories[i]);
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
                            padding: const EdgeInsets.only(top: 8, left: 8, bottom: 8),
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
                                      stories[i]["image"] == ""
                                          ? storyImagePlaceholder
                                          : stories[i]["image"],
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
                                            stories[i]["rating"],
                                            style: const TextStyle(
                                                color: Colors.white, fontSize: 12.0),
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
                                          stories[i]["title"],
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
                                          "By ${stories[i]["author"]}",
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
                                            updateStory(stories[i]["id"], true);
                                            newAudio = stories[i]["audio"];
                                            newImage = stories[i]["image"];
                                            newTitle = stories[i]["title"];
                                            newIsLiked = true;
                                            newAuthor = stories[i]["author"];
                                            newRating = stories[i]["rating"];
                                            addStory(newAudio, newAuthor, newImage, newTitle,
                                                newRating, newIsLiked);
                                          });
                                        } else {
                                          setState(() {
                                            hasLiked = false;
                                            updateStory(stories[i]["id"], false);
                                            favorites
                                                .doc(stories[i]["id"])
                                                .delete()
                                                .then((value) => logger.v("story Deleted"))
                                                .catchError((error) =>
                                                    logger.e("Failed to delete story: $error"));
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
                                        stories[i]["id"],
                                        storiesCollection),
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
            },
          );
        } else {
          return ListView.builder(
            primary: false,
            itemCount: stories.length,
            itemBuilder: (_, i) {
              bool hasLiked = stories[i]["isLiked"];
              return Container(
                alignment: Alignment.center,
                height: 100,
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  color: kPrimaryColor,
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
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
                        const Icon(
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
                              setState(() {
                                hasLiked = true;
                                updateStory(stories[i]["id"], true);
                                newAudio = stories[i]["audio"];
                                newImage = stories[i]["image"];
                                newTitle = stories[i]["title"];
                                newIsLiked = true;
                                newAuthor = stories[i]["author"];
                                newRating = stories[i]["rating"];
                                addStory(
                                  newAudio,
                                  newAuthor,
                                  newImage,
                                  newTitle,
                                  newRating,
                                  newIsLiked,
                                );
                              });
                            } else {
                              setState(() {
                                hasLiked = false;
                                updateStory(stories[i]["id"], false);
                                favorites
                                    .doc(stories[i]["id"])
                                    .delete()
                                    .then((value) => logger.v("Story Deleted"))
                                    .catchError(
                                      (error) => logger.e("Failed to delete story: $error"),
                                    );
                              });
                            }
                          },
                        ),
                        IconContextDialog(
                          "Delete Story...",
                          "Do you really want to delete this story?",
                          Icons.delete,
                          stories[i]["id"],
                          storiesCollection,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
