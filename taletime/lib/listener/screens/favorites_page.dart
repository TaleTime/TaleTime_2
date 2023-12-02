import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:taletime/common%20utils/constants.dart";
import "package:taletime/internationalization/localizations_ext.dart";
import "package:taletime/listener/screens/FavoriteActionButton.dart";
import "package:taletime/listener/utils/search_bar_util.dart";
import "package:taletime/listener/utils/list_view.dart";

import "../../common/models/added_story.dart";
import "../../common/models/story.dart";
import "../../profiles/models/profile_model.dart";
import "AddStoryActionButtons.dart";
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
    _storiesStream = widget.favorites.withConverter(
      fromFirestore: (snap, _) => Story.fromDocumentSnapshot(snap),
      toFirestore: (snap, _) => snap.toFirebase(),
    )
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return  ListenerTaletimePage(
        widget.favorites,
        widget.favorites, FavoriteActionButton(widget.storiesColl));
  }
}
