import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

  late final screens = [
    ListenerHomePage(profile),
    const Center(
      child: Text(
        "Favorites",
        style: TextStyle(fontSize: 50),
      ),
    ), //hier ersetzen
    //const Favorites(),
    const AddStory(),
    SettingsPage(profile, profiles),
  ];

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
        children: screens,
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
          navBarItems(Icons.favorite_sharp, "Favorites"),
          navBarItems(Icons.playlist_add_sharp, "Add Story"),
          navBarItems(Icons.settings, "Settings"),
        ],
      ),
    );
  }
}
