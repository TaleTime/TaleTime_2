// import "package:cloud_firestore/cloud_firestore.dart";
// import "package:flutter/material.dart";
// import "package:taletime/common%20utils/tale_time_logger.dart";
// import "package:taletime/common/models/story.dart";
// import "package:taletime/common/widgets/story_list_item.dart";
//
// import "../screens/story_player.dart";
//
// class ListViewData extends StatefulWidget {
//   final List storiesColl;
//   final CollectionReference storiesCollection;
//   final CollectionReference favoritesCollection;
//   final profile;
//   final profiles;
//   String listType;
//
//   ListViewData(
//     this.storiesColl,
//     this.storiesCollection,
//     this.profile,
//     this.profiles,
//     this.listType,
//     this.favoritesCollection, {
//     super.key,
//   });
//
//   @override
//   State<StatefulWidget> createState() {
//     return _ListViewDataState();
//   }
// }
//
// class _ListViewDataState extends State<ListViewData> {
//   final logger = TaleTimeLogger.getLogger();
//
//   final List<IconData> _icons = [
//     Icons.favorite,
//     Icons.favorite_border,
//   ];
//
//   _ListViewDataState();
//
//   @override
//   Widget build(context) {
//     final double screenWidth = MediaQuery.of(context).size.width;
//
//     Future<void> updateStory(String storyId, bool isLiked, String listTyp) {
//       if (storyId.isEmpty) {
//         logger.e("Invalid storyId");
//         return Future.error("Invalid storyId");
//       }
//
//       return widget.storiesCollection.doc(storyId).get().then((docSnapshot) {
//         if (docSnapshot.exists) {
//           return widget.storiesCollection
//               .doc(storyId)
//               .update({"isLiked": isLiked})
//               .then((value) => widget.listType == listTyp
//                   ? logger.v("Story liked/disliked")
//                   : isLiked
//                       ? logger.v("Story liked")
//                       : logger.v("Story disliked"))
//               .catchError((error) => logger.e("Failed to update user: $error"));
//         } else {
//           logger.e("Story not found");
//           return Future.error("Story not found");
//         }
//       }).catchError((error) => logger.e("Failed to fetch story: $error"));
//     }
//
//     Future<void> addStoryToFavoriteList(
//       String id,
//       String audio,
//       String author,
//       String image,
//       String title,
//       String rating,
//       bool isLiked,
//     ) {
//       return widget.favoritesCollection
//           .doc(id)
//           .set({
//             "id": id,
//             "image": image,
//             "audio": audio,
//             "title": title,
//             "rating": rating,
//             "author": author,
//             "isLiked": isLiked,
//           })
//           .then((value) => logger.v("Story added to favorites"))
//           .catchError(
//               (error) => logger.e("Failed to add story to favorites: $error"));
//     }
//
//     Future<void> removeFromFavoriteList(String storyId) {
//       if (storyId.isEmpty) {
//         logger.e("Invalid storyId");
//         return Future.error("Invalid storyId");
//       }
//       return widget.favoritesCollection
//           .doc(storyId)
//           .delete()
//           .then((value) => logger.v("Story removed from favorites"))
//           .catchError((error) =>
//               logger.e("Failed to remove story from favorites: $error"));
//     }
//
//     return StreamBuilder<QuerySnapshot>(
//       stream: widget.storiesCollection.snapshots(),
//       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//         if (snapshot.hasError) {
//           return Text("Error: ${snapshot.error}");
//         }
//
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const CircularProgressIndicator();
//         }
//
//         /* List<Story> stories = snapshot.data?.docs
//                 .map((doc) => Story.fromDocumentSnapshot(doc))
//                 .toList() ??
//             []; */
//
//         return StreamBuilder<QuerySnapshot>(
//           stream: widget.favoritesCollection.snapshots(),
//           builder: (BuildContext innerContext,
//               AsyncSnapshot<QuerySnapshot> innerSnapshot) {
//             if (innerSnapshot.hasError) {
//               return Text("Inner Error: ${innerSnapshot.error}");
//             }
//
//             if (innerSnapshot.connectionState == ConnectionState.waiting) {
//               return const CircularProgressIndicator();
//             }
//
//             List<Story> favStories = innerSnapshot.data?.docs
//                     .map((doc) => Story.fromDocumentSnapshot(doc))
//                     .toList() ??
//                 [];
//
//             if (widget.listType == "userStoriesList") {
//               /* return ListView.builder(
//                 primary: false,
//                 itemCount: stories.length,
//                 itemBuilder: (_, i) {
//                   /*bool hasLiked = stories[i]["isLiked"];
//
//                   for (var story in stories) {
//                     if (story["isLiked"] == true) {
//                       addStoryToFavoriteList(
//                         story["id"],
//                         story["audio"],
//                         story["author"],
//                         story["image"],
//                         story["title"],
//                         story["rating"],
//                         true,
//                       );
//                     } else {
//                       removeFromFavoriteList(story["id"]);
//                     }
//                   }*/ */
//
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 4.0),
//                     child: StoryListItem(
//                       story: stories[i],
//                       onTap: () {print("Tap on story");},
//                       buttons: [
//                         StoryActionButton(
//                           icon: Icons.favorite,
//                           onTap: () {print("Tab on story like");},
//                         )
//                       ],
//                     ),
//                   );
//                 },
//               );
//             } else {
//               return ListView.builder(
//                 primary: false,
//                 itemCount: favStories.length,
//                 itemBuilder: (_, i) {
//                   // bool hasLiked = favStories[i]["isLiked"];
//                   return Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 8.0),
//                       child: StoryListItem(
//                         story: stories[i],
//                         buttons: [
//                           StoryActionButton(
//                             icon: Icons.favorite,
//                             onTap: () {},
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               );
//             }
//           },
//         );
//       },
//     );
//   }
// }
