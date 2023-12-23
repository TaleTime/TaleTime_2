import "dart:async";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:taletime/common/models/added_story.dart";
import "package:taletime/profiles/models/profile_model.dart";

class ProfileState with ChangeNotifier {
  DocumentReference<Profile>? _profileRef;
  CollectionReference<AddedStory>? _storiesRef;
  Profile? _profile;
  List<AddedStory>? _stories;

  StreamSubscription? _profileSubscription;
  StreamSubscription? _storiesSubscription;

  DocumentReference<Profile>? get profileRef => _profileRef;

  CollectionReference<AddedStory>? get storiesRef => _storiesRef;

  List<AddedStory>? get stories => _stories;

  Profile? get profile => _profile;

  set profileRef(DocumentReference<Profile>? profileRef) {
    _profileRef = profileRef;

    _profileSubscription?.cancel();
    _profileSubscription = _profileRef?.snapshots().listen((profileSnapshot) {
      _profile = profileSnapshot.data();
      notifyListeners();
    });

    _storiesRef = _profileRef?.collection("storiesList").withConverter(
        fromFirestore: (snap, _) => AddedStory.fromDocumentSnapshot(snap),
        toFirestore: (snap, _) => snap.toFirebase());

    _storiesSubscription?.cancel();
    _storiesSubscription = _storiesRef?.snapshots().listen((storiesSnapshot) {
      _stories = storiesSnapshot.docs.map((story) => story.data()).toList();
    });

    notifyListeners();
  }
}
