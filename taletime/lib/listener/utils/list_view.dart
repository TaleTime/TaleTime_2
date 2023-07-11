/*import "package:cloud_firestore/cloud_firestore.dart";
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
  ListViewData(this.storiesColl, this.storiesCollection, this.profile, this.profiles, this.listType,
      this.favoritesCollection,
      {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ListViewDataState(
        storiesColl, storiesCollection, profile, profiles, listType, favoritesCollection);
  }
}

class _ListViewDataState extends State<ListViewData> {
  final logger = TaleTimeLogger.getLogger();
  final List storiesColl;
  final CollectionReference storiesCollection;
  final CollectionReference favoritesCollection;
  final profile;
  final profiles;
  late final String
      newAudio; //Exception has occurred. LateError (LateInitializationError: Field 'newAudio' has already been initialized.)
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

  _ListViewDataState(this.storiesColl, this.storiesCollection, this.profile, this.profiles,
      this.listType, this.favoritesCollection);

  @override
  Widget build(context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    //CollectionReference favorites = profiles.doc(profile["id"]).collection("favoriteList");
    /*return StreamBuilder(
        stream: storiesCollection.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            final List<QueryDocumentSnapshot> storiesDocumentSnapshot = streamSnapshot.data!.docs;
           */ //we should use this and get from it the stories in the favorites and use it in that button

    Future<void> updateStory(String storyId, bool isLiked, String listTyp) {
      if (storyId.isEmpty) {
        logger.e("Invalid storyId");
        return Future.error("Invalid storyId");
      }
      return storiesCollection
          .doc(
              storyId) //_AssertionError ('package:cloud_firestore/src/collection_reference.dart': Failed assertion: line 116 pos 14: 'path.isNotEmpty': a document path must be a non-empty string)
          .update({"isLiked": isLiked})
          .then((value) => listType == listTyp
              ? logger.v("Story liked/disliked")
              : isLiked
                  ? logger.v("Story liked")
                  : logger.v("Story disliked"))
          .catchError((error) => logger.e("Failed to update user: $error"));
    }

    Future<void> updateFavoriteList(String storyId, String field, Object value) {
      return favoritesCollection
          .doc(storyId)
          .update({field: value})
          .then((value) => logger.v("List Updated"))
          .catchError((error) => logger.e("Failed to update List: $error"));
    }

    Future<void> addStoryToFavoriteList(
      //String id,
      String audio,
      String author,
      String image,
      String title,
      String rating,
      bool isLiked,
      /*String id*/
    ) {
      return favoritesCollection.add({
        //"id": id,
        "image": image,
        "audio": audio,
        "title": title,
        "rating": rating,
        "author": author,
        "isLiked": isLiked
      }).catchError((error) => logger.e("Failed to add story to favorites: $error"));
    }

    Future<void> deleteFromFavoriteList(String storyId) {
      if (storyId.isEmpty) {
        logger.e("Invalid storyId");
        return Future.error("Invalid storyId");
      }
      return favoritesCollection
          .doc(storyId) //Exception has occurred.
          //_AssertionError ('package:cloud_firestore/src/collection_reference.dart': Failed assertion: line 116 pos 14: 'path.isNotEmpty': a document path must be a non-empty string)
          .delete()
          .then((value) => logger.v("List Updated"))
          .catchError((error) => logger.e("Failed to update List: $error"));
    }

    /*Future<void> getFieldNames() async { 
      QuerySnapshot<Object?> snapshot = await favoritesCollection.get();

      // Iterate over the documents
      for (QueryDocumentSnapshot<Object?> docSnapshot in snapshot.docs) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

        // Get the field names
        List<String> fieldNames = data.keys.toList();

        // Print the field names
        print("Field names in document ${docSnapshot.id}: $fieldNames");
      }
    }*/ //USED for debugging and displaying the fields names in the favorites collections

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

          return StreamBuilder<QuerySnapshot>(
            stream: favoritesCollection.snapshots(),
            builder: (BuildContext innerContext, AsyncSnapshot<QuerySnapshot> innerSnapshot) {
              if (innerSnapshot.hasError) {
                return Text("Inner Error: ${innerSnapshot.error}");
              }

              if (innerSnapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(); // Inner loading
              }

              List<Map<String, dynamic>> favStories = innerSnapshot.data?.docs
                      .map((doc) => doc.data() as Map<String, dynamic>)
                      .toList() ??
                  [];
              //List<QueryDocumentSnapshot> favStories = innerSnapshot.data!.docs;

              // Extract data from the inner snapshot

              if (listType == "userStroiesList") {
                return ListView.builder(
                  primary: false,
                  itemCount: stories.length,
                  itemBuilder: (_, i) {
                    bool hasLiked = stories[i]["isLiked"];

                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                          return MyPlayStory(stories[i], storiesCollection);
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
                                                  hasLiked =
                                                      true; //the problem is here where we are adding the stories to the homepage listner and not to the favorites because when we create listview for homepage we use the storiescollection and not the favoritescollection so here we should use the stories as it is from the favoritescollection snapshot and not from the collection of the storiescollection here when we use creating the listview for homepage we pass the normal sotiescollection and never used the favoritescollection for this button to be able to add to it and remove from it
                                                  updateStory(
                                                      stories[i]["id"], true, "userStroiesList");
                                                  newAudio = stories[i]["audio"];
                                                  newImage = stories[i]["image"];
                                                  newTitle = stories[i]["title"];
                                                  newIsLiked = true;
                                                  newAuthor = stories[i]["author"];
                                                  newRating = stories[i]["rating"];
                                                  addStoryToFavoriteList(
                                                      //stories[i]["id"],
                                                      newAudio,
                                                      newAuthor,
                                                      newImage,
                                                      newTitle,
                                                      newRating,
                                                      newIsLiked);

                                                  //getFieldNames();
                                                });
                                              } else {
                                                setState(() {
                                                  hasLiked = false;
                                                  updateStory(
                                                      stories[i]["id"], false, "userStroiesList");
                                                  updateStory(favStories[i]["id"], false, "fav");
                                                  // favorites
                                                  //     .doc(stories[i]["id"])
                                                  //     .delete()
                                                  //     .then((value) => logger.v("story Deleted"))
                                                  //     .catchError((error) => logger
                                                  //         .e("Failed to delete story: $error"));
                                                  // updateFavoriteList(
                                                  //     stories[i]["id"], "isLiked", false);
                                                  deleteFromFavoriteList(stories[i]["id"]);
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
                  itemCount: favStories.length,
                  itemBuilder: (_, i) {
                    bool hasLiked = favStories[i]["isLiked"];
                    return Container(
                      alignment: Alignment.center,
                      height: 100,
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        color: kPrimaryColor,
                        child: ListTile(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                              return MyPlayStory(favStories[i], storiesCollection);
                            }));
                          },
                          leading: Image.network(favStories[i]["image"], fit: BoxFit.fill),
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
                                  if (!hasLiked) {
                                    setState(() {
                                      hasLiked = true;
                                      updateStory(favStories[i]["id"], true, "fav");
                                      updateStory(stories[i]["id"], true, "userStroiesList");
                                      //StateError (Bad state: field does not exist within the DocumentSnapshotPlatform)
                                      updateFavoriteList(favStories[i]["id"], "isLiked", true);
                                      newAudio = favStories[i]["audio"];
                                      newImage = favStories[i]["image"];
                                      newTitle = favStories[i]["title"];
                                      newIsLiked = true;
                                      newAuthor = favStories[i]["author"];
                                      newRating = favStories[i]["rating"];
                                      addStoryToFavoriteList(newAudio, newAuthor, newImage,
                                          newTitle, newRating, newIsLiked);
                                    });
                                  } else {
                                    setState(() {
                                      hasLiked = false;
                                      updateStory(
                                          favStories[i]["id"],
                                          false, //Exception has occurred._TypeError (type 'Null' is not a subtype of type 'String')

                                          "fav"); //StateError (Bad state: field does not exist within the DocumentSnapshotPlatform)
                                      updateStory(stories[i]["id"], false, "userStroiesList");

                                      //updateFavoriteList(stories[i]["id"], "isLiked", false);
                                      // favorites
                                      //     .doc(stories[i]["id"])
                                      //     .delete()
                                      //     .then((value) => logger.v("Story Deleted"))
                                      //     .catchError(
                                      //       (error) => logger.e("Failed to delete story: $error"),
                                      //     );
                                      deleteFromFavoriteList(favStories[i]["id"]);
                                    });
                                  }
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
        });
  }
}*/
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
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ListViewDataState(
      storiesColl,
      storiesCollection,
      profile,
      profiles,
      listType,
      favoritesCollection,
    );
  }
}

class _ListViewDataState extends State<ListViewData> {
  final logger = TaleTimeLogger.getLogger();
  final List storiesColl;
  final CollectionReference storiesCollection;
  final CollectionReference favoritesCollection;
  final profile;
  final profiles;

  String listType;

  final List<IconData> _icons = [
    Icons.favorite,
    Icons.favorite_border,
  ];

  _ListViewDataState(
    this.storiesColl,
    this.storiesCollection,
    this.profile,
    this.profiles,
    this.listType,
    this.favoritesCollection,
  );

  @override
  Widget build(context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    /*Future<void> updateStory(String storyId, bool isLiked) {
      if (storyId.isEmpty) {
        logger.e("Invalid storyId");
        return Future.error("Invalid storyId");
      }
      return storiesCollection
          .doc(storyId)
          .update({"isLiked": isLiked})
          .then((value) => logger.v("Story updated"))
          .catchError((error) => logger.e("Failed to update story: $error"));
    }*/

    Future<void> updateStory(String storyId, bool isLiked, String listTyp) {
      if (storyId.isEmpty) {
        logger.e("Invalid storyId");
        return Future.error("Invalid storyId");
      }

      return storiesCollection.doc(storyId).get().then((docSnapshot) {
        if (docSnapshot.exists) {
          return storiesCollection
              .doc(storyId)
              .update({"isLiked": isLiked})
              .then((value) => listType == listTyp
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

    /*Future<void> updateFavoriteList(String storyId, String field, Object value) {
      return favoritesCollection
          .doc(storyId)
          .update({field: value})
          .then((value) => logger.v("List updated"))
          .catchError((error) => logger.e("Failed to update list: $error"));
    }*/

    Future<void> addStoryToFavoriteList(
      String id,
      String audio,
      String author,
      String image,
      String title,
      String rating,
      bool isLiked,
    ) {
      return favoritesCollection
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
          .catchError((error) => logger.e("Failed to add story to favorites: $error"));
    }

    Future<void> removeFromFavoriteList(String storyId) {
      if (storyId.isEmpty) {
        logger.e("Invalid storyId");
        return Future.error("Invalid storyId");
      }
      return favoritesCollection
          .doc(storyId)
          .delete()
          .then((value) => logger.v("Story removed from favorites"))
          .catchError((error) => logger.e("Failed to remove story from favorites: $error"));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: storiesCollection.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        List<Map<String, dynamic>> stories =
            snapshot.data?.docs.map((doc) => doc.data() as Map<String, dynamic>).toList() ?? [];

        return StreamBuilder<QuerySnapshot>(
          stream: favoritesCollection.snapshots(),
          builder: (BuildContext innerContext, AsyncSnapshot<QuerySnapshot> innerSnapshot) {
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

            if (listType == "userStroiesList") {
              return ListView.builder(
                primary: false,
                itemCount: stories.length,
                itemBuilder: (_, i) {
                  bool hasLiked = stories[i]["isLiked"];

                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                        return MyPlayStory(stories[i], storiesCollection);
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
                                              updateStory(
                                                  stories[i]["id"], hasLiked, "userStroiesList");
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
                                                removeFromFavoriteList(stories[i]["id"]);
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
                                          storiesCollection,
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      color: kPrimaryColor,
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                            return MyPlayStory(favStories[i], favoritesCollection);
                          }));
                        },
                        leading: Image.network(favStories[i]["image"], fit: BoxFit.fill),
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
                                  //updateStory(favStories[i]["id"], hasLiked, "favList");
                                  if (!hasLiked) {
                                    //print(stories[i]["id"]);
                                    updateStory(favStories[i]["id"], false,
                                        "favList"); //Bug fixed: problem was: both favorites collection and storiesCollection had same id in the firebase
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
