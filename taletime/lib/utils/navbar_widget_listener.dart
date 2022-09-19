import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../screens/favorites_page.dart';
import '../screens/add_story_page.dart';
import '../screens/listener_homepage.dart';
import '../screens/settings.dart';

class NavBarListener extends StatefulWidget {
  //final DocumentSnapshot profile;
  final profile;
  final profiles;
  const NavBarListener(this.profile, this.profiles, {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _NavBarListenerState(this.profile, this.profiles);
  }
}

class _NavBarListenerState extends State<NavBarListener> {
  var _currentIndex = 0;

  //late final DocumentSnapshot profile;
  final profile;
  final profiles;

  _NavBarListenerState(this.profile, this.profiles);

  CollectionReference allStories = FirebaseFirestore.instance.collection('allStories');

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
    CollectionReference favorites = profiles.doc(profile["id"]).collection('favoriteList');
    CollectionReference recent = profiles.doc(profile["id"]).collection('recentList');
    CollectionReference stories = profiles.doc(profile["id"]).collection('storiesList');

    /*allStories.add({
      "rating": "3.5",
      "title": "The India Story",
      "author": "Bimal Jalal",
      "image": "",
      "audio": "",
      "isLiked": false,
      "id": ""
    }).then((value) {
      print("User Added");
      allStories.doc(value.id).update({'id': value.id})
          .then((value) => print("User Updated"))
          .catchError((error) => print("Failed to update user: $error"));
    }).catchError((error) => print("Failed to add user: $error"));*/

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          ListenerHomePage(profile, profiles, stories, recent),
          FavoritePage(profile, profiles, favorites),
          AddStory(stories, allStories),
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
          navBarItems(
            Icons.home,
            "Home",
          ),
          navBarItems(Icons.favorite_sharp, "Favorites"),
          navBarItems(Icons.playlist_add_sharp, "Add Story"),
          navBarItems(Icons.settings, "Settings"),
        ],
      ),
    );
  }
}
