import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:taletime/common/models/added_story.dart";
import "package:taletime/listener/screens/FavoriteActionButton.dart";

import "../../common utils/decoration_util.dart";
import "../../common/models/story.dart";
import "../../internationalization/localizations_ext.dart";
import "../../profiles/models/profile_model.dart";
import "listener_taletime_page.dart";

class FavoritePage extends StatefulWidget {
  final Profile profile;
  final CollectionReference profiles;
  final CollectionReference favorites;
  final CollectionReference storiesColl;
  const FavoritePage(
      this.profile, this.profiles, this.favorites, this.storiesColl,
      {super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List matchStoryList = [];
  Stream<QuerySnapshot<Story>>? _storiesStream;

  _FavoritePageState();

  @override
  void initState() {
    super.initState();
    _storiesStream = widget.favorites
        .withConverter(
          fromFirestore: (snap, _) => Story.fromDocumentSnapshot(snap),
          toFirestore: (snap, _) => snap.toFirebase(),
        )
        .where("isLiked", isEqualTo: true)
        .snapshots();
  }

  List<Story> filterLikedStories(List<Story> allStories, List<Story> likedStories) {
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
    return StreamBuilder(stream: _storiesStream, builder: (context, streamSnapshot) {
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

      return ListenerTaletimePage(docs, FavoriteActionButton());
      }
      );
  }
}
