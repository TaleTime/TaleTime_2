import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:taletime/common/models/added_story.dart";
import "package:taletime/common/models/story.dart";
import "package:taletime/internationalization/localizations_ext.dart";

import "../../settings/settings.dart";
import "../screens/add_story_page.dart";
import "../screens/favorites_page.dart";
import "../screens/listener_homepage.dart";

class NavBarListener extends StatefulWidget {
  const NavBarListener({super.key});

  @override
  State<StatefulWidget> createState() {
    return _NavBarListenerState();
  }
}

class _NavBarListenerState extends State<NavBarListener> {
  var _currentIndex = 0;

  _NavBarListenerState();

  CollectionReference<Story> allStories =
      FirebaseFirestore.instance.collection("allStories").withConverter(
            fromFirestore: (snap, _) => AddedStory.fromDocumentSnapshot(snap),
            toFirestore: (snap, _) => snap.toFirebase(),
          );

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
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const ListenerHomePage(),
          const FavoritePage(),
          AddStory(allStories),
          const SettingsPage(),
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
          navBarItems(
              Icons.favorite_sharp, AppLocalizations.of(context)!.favorites),
          navBarItems(
              Icons.playlist_add_sharp, AppLocalizations.of(context)!.addStory),
        ],
      ),
    );
  }
}
