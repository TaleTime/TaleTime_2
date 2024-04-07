import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/cupertino.dart";

import "../common/models/added_story.dart";
import "../common/models/story.dart";

class StoriesState with ChangeNotifier {
  StoriesState() {
    CollectionReference<Story> allStories = _allStories =
        FirebaseFirestore.instance.collection("allStories").withConverter(
              fromFirestore: (snap, _) => AddedStory.fromDocumentSnapshot(snap),
              toFirestore: (snap, _) => snap.toFirebase(),
            );
    allStories.withConverter(
      fromFirestore: (snap, _) => AddedStory.fromDocumentSnapshot(snap),
      toFirestore: (snap, _) => snap.toFirebase(),
    );

    _allStories?.snapshots().listen((snapshot) {
      _allStoriesList = snapshot.docs.map((story) => story.data()).toList();
      notifyListeners();
    });

    notifyListeners();
  }
  CollectionReference<Story>? _allStoriesRef;

  CollectionReference<Story>? get allStoriesRef => _allStoriesRef;
  CollectionReference<Story>? _allStories;
  List<Story>? _allStoriesList;

  List<Story>? get allStoriesList => _allStoriesList;
}
