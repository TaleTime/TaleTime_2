import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taletime/screens/all_stories.dart';
import 'package:taletime/screens/create_story.dart';
import 'package:taletime/screens/speaker_homepage.dart';

import '../screens/settings.dart';

class NavBarSpeaker extends StatefulWidget {
  //final DocumentSnapshot profile;
  final profile;
  final profiles;
  const NavBarSpeaker(this.profile, this.profiles, {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _NavBarSpeakerState(this.profile, this.profiles);
  }
}

class _NavBarSpeakerState extends State<NavBarSpeaker> {
  var _currentIndex = 0;

  //late final DocumentSnapshot profile;
  final profile;
  final profiles;
  List test = [];

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
    CollectionReference lastRecorded = profiles.doc(profile["id"]).collection('lastRecordedList');
    CollectionReference recordedStories = profiles.doc(profile["id"]).collection('recordedStoriesList');

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          SpeakerHomePage(profile, recordedStories, lastRecorded),
          AllStories(recordedStories),
          CreateStory(),
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
          navBarItems(Icons.settings, "Settings"),
        ],
      ),
    );
  }
}
