import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:taletime/listener/screens/all_stories.dart";
import "package:taletime/storyteller/screens/create_story.dart";
import "package:taletime/storyteller/screens/speaker_homepage.dart";

import "../../settings/settings.dart";

class NavBarSpeaker extends StatefulWidget {
  final profile;
  final profiles;
  const NavBarSpeaker(this.profile, this.profiles, {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _NavBarSpeakerState();
}

class _NavBarSpeakerState extends State<NavBarSpeaker> {
  var _currentIndex = 0;

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
    CollectionReference lastRecorded = widget.profiles
        .doc(widget.profile["id"])
        .collection("lastRecordedList");
    CollectionReference recordedStories = widget.profiles
        .doc(widget.profile["id"])
        .collection("recordedStoriesList");

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          SpeakerHomePage(
              widget.profile, widget.profiles, recordedStories, lastRecorded),
          AllStories(widget.profile, widget.profiles, recordedStories),
          CreateStory(widget.profile, recordedStories),
          SettingsPage(widget.profile, widget.profiles),
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
