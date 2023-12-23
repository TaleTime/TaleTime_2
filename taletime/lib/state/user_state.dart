import "dart:async";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:taletime/profiles/models/profile_model.dart";

class UserState with ChangeNotifier {
  UserState();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  CollectionReference<Profile>? _profilesRef;
  List<Profile>? _profiles;
  StreamSubscription? _profilesSubscription;

  CollectionReference<Profile>? get profilesRef => _profilesRef;

  List<Profile>? get profiles => _profiles;

  User? get user => _user;

  set user(User? user) {
    _user = user;

    _profilesSubscription?.cancel();

    _profilesRef = _firestore
        .collection("users")
        .doc(user?.uid)
        .collection("profiles")
        .withConverter(
          fromFirestore: (snapshot, _) =>
              Profile.fromDocumentSnapshot(snapshot),
          toFirestore: (profile, _) => profile.toFirebase(),
        );

    _profilesSubscription = _profilesRef?.snapshots().listen((snapshot) {
      _profiles = snapshot.docs.map((profileRef) => profileRef.data()).toList();
      notifyListeners();
    });

    notifyListeners();
  }

  factory UserState.withUserListener() {
    UserState userState = UserState();

    FirebaseAuth.instance.authStateChanges().listen((snapshot) {
      userState.user = snapshot;
    });

    return userState;
  }
}
