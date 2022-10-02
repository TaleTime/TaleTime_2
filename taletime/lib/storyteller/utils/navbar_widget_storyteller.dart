import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taletime/listener/screens/all_stories.dart';
import 'package:taletime/storyteller/screens/create_story.dart';
import 'package:taletime/storyteller/screens/speaker_homepage.dart';

import '../../settings/settings.dart';

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

    /*Future<void> updateFavoriteList(String storyId, stories) {
      return stories
          .doc(storyId)
          .update({'id': storyId})
          .then((value) => print("List Updated"))
          .catchError((error) => print("Failed to update List: $error"));
    }

    recordedStories.add({
      "rating": "3.9",
      "title": "INDO-PAK WAR 1971- Reminiscences of Air Warriors",
      "author": "Rajnath Singh",
      "image": "",
      "audio": "",
      "isLiked": false,
      "id": ""
    }).then((value) {
      print("Story Added to favorites");
      updateFavoriteList(value.id, recordedStories);
    }).catchError((error) => print("Failed to add story to favorites: $error"));

    lastRecorded.add({
      "rating": "4.0",
      "title": "Listen to Your Heart: The London Adventure",
      "author": "Ruskin Bond",
      "image": "",
      "audio": "",
      "isLiked": false,
      "id": ""
    }).then((value) {
      print("Story Added to favorites");
      updateFavoriteList(value.id, lastRecorded);
    }).catchError((error) => print("Failed to add story to favorites: $error"));*/

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          SpeakerHomePage(profile, profiles, recordedStories, lastRecorded),
          AllStories(profile, profiles, recordedStories),
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
