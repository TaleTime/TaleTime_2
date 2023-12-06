import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:taletime/common/models/added_story.dart";
import "package:taletime/common/services/story_service.dart";
import "package:taletime/listener/screens/FavoriteActionButton.dart";

import "../../common/models/story.dart";
import "../../common/widgets/story_list_item.dart";
import "../../profiles/models/profile_model.dart";
import "listener_taletime_page.dart";

class FavoritePage extends StatefulWidget {
  const FavoritePage({
    super.key,
    required this.profile,
    required this.profiles,
    required this.stories,
  });

  final Profile profile;
  final CollectionReference<Profile> profiles;
  final CollectionReference<AddedStory> stories;

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List matchStoryList = [];
  Stream<QuerySnapshot<AddedStory>>? _storiesStream;

  _FavoritePageState();

  @override
  void initState() {
    super.initState();
    _storiesStream = widget.stories
        .withConverter(
      fromFirestore: (snap, _) => AddedStory.fromDocumentSnapshot(snap),
      toFirestore: (snap, _) => snap.toFirebase(),
    )
        .where("isLiked", isEqualTo: true)
        .snapshots();
  }

  List<Story> filterLikedStories(List<Story> allStories,
      List<Story> likedStories) {
    List<Story> filteredStories = [];
    for (Story story in allStories) {
      if (likedStories.contains(story)) {
        filteredStories.add(story);
      }
    }
    return filteredStories;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _storiesStream,
        builder: (context, streamSnapshot) {
          final data = streamSnapshot.data;
          if (data == null) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          final docs = data.docs;

          return ListenerTaletimePage<AddedStory>(
            docs: docs,
            buttonsBuilder: (e) => FavoriteActionButton().build(context, e.reference),
          );
        });
  }
  }
