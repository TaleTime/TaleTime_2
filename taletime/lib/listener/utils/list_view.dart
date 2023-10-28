import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:taletime/common%20utils/tale_time_logger.dart";
import "../../common utils/constants.dart";
import "../screens/my_play_story.dart";
import "icon_context_dialog.dart";

class ListViewData extends StatefulWidget {
  final List storiesColl;
  final CollectionReference storiesCollection;
  final CollectionReference favoritesCollection;
  final profile;
  final profiles;
  String listType;
  ListViewData(
    this.storiesColl,
    this.storiesCollection,
    this.profile,
    this.profiles,
    this.listType,
    this.favoritesCollection, {
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _ListViewDataState();
  }
}

class _ListViewDataState extends State<ListViewData> {
  final logger = TaleTimeLogger.getLogger();

  final List<IconData> _icons = [
    Icons.favorite,
    Icons.favorite_border,
  ];

  _ListViewDataState();

  @override
  Widget build(context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    Future<void> updateStory(String storyId, bool isLiked, String listTyp) {
      if (storyId.isEmpty) {
        logger.e("Invalid storyId");
        return Future.error("Invalid storyId");
      }

      return widget.storiesCollection.doc(storyId).get().then((docSnapshot) {
        if (docSnapshot.exists) {
          return widget.storiesCollection
              .doc(storyId)
              .update({"isLiked": isLiked})
              .then((value) => widget.listType == listTyp
                  ? logger.v("Story liked/disliked")
                  : isLiked
                      ? logger.v("Story liked")
                      : logger.v("Story disliked"))
              .catchError((error) => logger.e("Failed to update user: $error"));
        } else {
          logger.e("Story not found");
          return Future.error("Story not found");
        }
      }).catchError((error) => logger.e("Failed to fetch story: $error"));
    }

    Future<void> addStoryToFavoriteList(
      String id,
      String audio,
      String author,
      String image,
      String title,
      String rating,
      bool isLiked,
    ) {
      return widget.favoritesCollection
          .doc(id)
          .set({
            "id": id,
            "image": image,
            "audio": audio,
            "title": title,
            "rating": rating,
            "author": author,
            "isLiked": isLiked,
          })
          .then((value) => logger.v("Story added to favorites"))
          .catchError(
              (error) => logger.e("Failed to add story to favorites: $error"));
    }

    Future<void> removeFromFavoriteList(String storyId) {
      if (storyId.isEmpty) {
        logger.e("Invalid storyId");
        return Future.error("Invalid storyId");
      }
      return widget.favoritesCollection
          .doc(storyId)
          .delete()
          .then((value) => logger.v("Story removed from favorites"))
          .catchError((error) =>
              logger.e("Failed to remove story from favorites: $error"));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: widget.storiesCollection.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        List<Map<String, dynamic>> stories = snapshot.data?.docs
                .map((doc) => doc.data() as Map<String, dynamic>)
                .toList() ??
            [];

        return StreamBuilder<QuerySnapshot>(
          stream: widget.favoritesCollection.snapshots(),
          builder: (BuildContext innerContext,
              AsyncSnapshot<QuerySnapshot> innerSnapshot) {
            if (innerSnapshot.hasError) {
              return Text("Inner Error: ${innerSnapshot.error}");
            }

            if (innerSnapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            List<Map<String, dynamic>> favStories = innerSnapshot.data?.docs
                    .map((doc) => doc.data() as Map<String, dynamic>)
                    .toList() ??
                [];

            if (widget.listType == "userStroiesList") {
              return ListView.builder(
                primary: false,
                itemCount: stories.length,
                itemBuilder: (_, i) {
                  bool hasLiked = stories[i]["isLiked"];

                  for (var story in stories) {
                    if (story["isLiked"] == true) {
                      addStoryToFavoriteList(
                        story["id"],
                        story["audio"],
                        story["author"],
                        story["image"],
                        story["title"],
                        story["rating"],
                        true,
                      );
                    } else {
                      removeFromFavoriteList(story["id"]);
                    }
                  }

                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return MyPlayStory(stories[i], widget.storiesCollection);
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
                                padding: const EdgeInsets.only(
                                    top: 8, left: 8, bottom: 8),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: [
                                              Text(
                                                stories[i]["rating"],
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12.0,
                                                ),
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
                                            setState(() {
                                              hasLiked = !hasLiked;
                                              updateStory(stories[i]["id"],
                                                  hasLiked, "userStroiesList");
                                              if (hasLiked) {
                                                addStoryToFavoriteList(
                                                  stories[i]["id"],
                                                  stories[i]["audio"],
                                                  stories[i]["author"],
                                                  stories[i]["image"],
                                                  stories[i]["title"],
                                                  stories[i]["rating"],
                                                  hasLiked,
                                                );
                                              } else {
                                                removeFromFavoriteList(
                                                    stories[i]["id"]);
                                              }
                                            });
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
                                          widget.storiesCollection,
                                        ),
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
                itemCount: favStories.length,
                itemBuilder: (_, i) {
                  bool hasLiked = favStories[i]["isLiked"];
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
                            return MyPlayStory(
                                favStories[i], widget.favoritesCollection);
                          }));
                        },
                        leading: Image.network(favStories[i]["image"],
                            fit: BoxFit.fill),
                        title: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              favStories[i]["rating"],
                            ),
                            const Icon(
                              Icons.star,
                              size: 15,
                            )
                          ],
                        ),
                        isThreeLine: true,
                        subtitle: Text(
                          "${favStories[i]["title"]}\nBy ${favStories[i]["author"]}",
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
                                setState(() {
                                  hasLiked = !hasLiked;

                                  if (!hasLiked) {
                                    updateStory(
                                        favStories[i]["id"], false, "favList");
                                    removeFromFavoriteList(favStories[i]["id"]);
                                  }
                                });
                              },
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
      },
    );
  }
}
