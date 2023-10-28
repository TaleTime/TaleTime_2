import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";

import "../screens/favorites_page.dart";
import "../screens/add_story_page.dart";
import "../screens/listener_homepage.dart";
import "../../settings/settings.dart";

class NavBarListener extends StatefulWidget {
  final profile;
  final profiles;
  const NavBarListener(this.profile, this.profiles, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _NavBarListenerState();
  }
}

class _NavBarListenerState extends State<NavBarListener> {
  var _currentIndex = 0;


  _NavBarListenerState();

  CollectionReference allStories =
      FirebaseFirestore.instance.collection("allStories");

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
    CollectionReference favorites =
    widget.profiles.doc(widget.profile["id"]).collection("favoriteList");
    CollectionReference recent =
    widget.profiles.doc(widget.profile["id"]).collection("recentList");
    CollectionReference stories =
    widget.profiles.doc(widget.profile["id"]).collection("storiesList");

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          ListenerHomePage(widget.profile, widget.profiles, stories, recent, favorites),
          FavoritePage(widget.profile, widget.profiles, favorites, stories),
          AddStory(stories, allStories),
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
          navBarItems(
            Icons.home,
            "Home",
          ),
          navBarItems(Icons.favorite_sharp, "Favorites"),
          navBarItems(Icons.playlist_add_sharp, "Add Story"),
        ],
      ),
    );
  }
}
