import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:taletime/listener/screens/all_stories.dart";
import "package:taletime/profiles/models/profile_model.dart";
import "package:taletime/storyteller/screens/create_story.dart";
import "package:taletime/storyteller/screens/speaker_homepage.dart";

import "../../settings/settings.dart";

class NavBarSpeaker extends StatefulWidget {
  final Profile profile;
  final CollectionReference profiles;
  const NavBarSpeaker(this.profile, this.profiles, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _NavBarSpeakerState(profile, profiles);
  }
}

class _NavBarSpeakerState extends State<NavBarSpeaker> {
  var _currentIndex = 0;

  final Profile profile;
  final CollectionReference profiles;

  _NavBarSpeakerState(this.profile, this.profiles);

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
    CollectionReference lastRecorded =
        profiles.doc(profile.id).collection("lastRecordedList");
    CollectionReference recordedStories =
        profiles.doc(profile.id).collection("recordedStoriesList");

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          SpeakerHomePage(profile, profiles, recordedStories, lastRecorded),
          AllStories(profile, profiles, recordedStories),
          CreateStory(profile, recordedStories),
          SettingsPage(profile, profiles),
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
          navBarItems(Icons.home, "Home"),
          navBarItems(Icons.book, "All Stories"),
          navBarItems(Icons.playlist_add_sharp, "Record Story"),
        ],
      ),
    );
  }
}
