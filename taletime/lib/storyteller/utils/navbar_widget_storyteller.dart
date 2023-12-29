import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:taletime/internationalization/localizations_ext.dart";
import 'package:taletime/storyteller/screens/all_stories.dart';
import "package:taletime/state/profile_state.dart";
import "package:taletime/storyteller/screens/create_story.dart";
import "package:taletime/storyteller/screens/speaker_homepage.dart";

import "../../common/models/story.dart";
import "../../settings/settings.dart";

class NavBarSpeaker extends StatefulWidget {
  const NavBarSpeaker({super.key});

  @override
  State<StatefulWidget> createState() {
    return _NavBarSpeakerState();
  }
}

class _NavBarSpeakerState extends State<NavBarSpeaker> {
  var _currentIndex = 0;
  late CollectionReference<Story> recordedStories;
  late CollectionReference<Story> lastRecorded;

  _NavBarSpeakerState();

  BottomNavigationBarItem navBarItems(IconData icons, String labels) {
    return BottomNavigationBarItem(
      icon: Icon(
        icons,
      ),
      label: labels,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileState>(
      builder: (context, profileState, _) {
        CollectionReference lastRecorded =
            profileState.profileRef!.collection("lastRecordedList")
                .withConverter(
                fromFirestore: (snap, _) => Story.fromDocumentSnapshot(snap),
                toFirestore: (snap, _) => snap.toFirebase());
        CollectionReference recordedStories =
            profileState.profileRef!.collection("recordedStoriesList")
                .withConverter(
                fromFirestore: (snap, _) => Story.fromDocumentSnapshot(snap),
                toFirestore: (snap, _) => snap.toFirebase(),);

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          SpeakerHomePage(recordedStories, lastRecorded),
          AllStories(recordedStories),
          CreateStory(recordedStories),
          SettingsPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 27,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() {
          _currentIndex = index;
        }),
        selectedItemColor: Colors.teal.shade600,
        unselectedItemColor: Colors.grey.shade500,
        elevation: 0.0,
        items: [
          navBarItems(Icons.home, AppLocalizations.of(context)!.home),
          navBarItems(
              Icons.book, AppLocalizations.of(context)!.allStories_pageTitle),
          navBarItems(Icons.playlist_add_sharp,
              AppLocalizations.of(context)!.recordStory),
        ],
      ),
    );
  }
}
