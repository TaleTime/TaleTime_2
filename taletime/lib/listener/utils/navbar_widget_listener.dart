import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:taletime/common/models/added_story.dart";
import "package:taletime/common/models/story.dart";
import "package:taletime/internationalization/localizations_ext.dart";

import "../../profiles/models/profile_model.dart";
import "../../settings/settings.dart";
import "../screens/add_story_page.dart";
import "../screens/favorites_page.dart";
import "../screens/listener_homepage.dart";

class NavBarListener extends StatefulWidget {
  final Profile profile;
  final CollectionReference<Profile> profiles;
  const NavBarListener(this.profile, this.profiles, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _NavBarListenerState();
  }
}

class _NavBarListenerState extends State<NavBarListener> {
  var _currentIndex = 0;
  late CollectionReference<AddedStory> stories;

  _NavBarListenerState();

  CollectionReference<Story> allStories =
      FirebaseFirestore.instance.collection("allStories").withConverter(
            fromFirestore: (snap, _) => AddedStory.fromDocumentSnapshot(snap),
            toFirestore: (snap, _) => snap.toFirebase(),
          );

  @override
  void initState() {
    super.initState();
    stories = widget.profiles
        .doc(widget.profile.id)
        .collection("storiesList")
        .withConverter(
          fromFirestore: (snap, _) => AddedStory.fromDocumentSnapshot(snap),
          toFirestore: (snap, _) => snap.toFirebase(),
        );
  }

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
          ListenerHomePage(
            profile: widget.profile,
            profiles: widget.profiles,
            storiesCollection: stories,
          ),
          FavoritePage(
              profile: widget.profile,
              stories: stories,
              profiles: widget.profiles),
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
          navBarItems(
              Icons.favorite_sharp, AppLocalizations.of(context)!.favorites),
          navBarItems(
              Icons.playlist_add_sharp, AppLocalizations.of(context)!.addStory),
        ],
      ),
    );
  }
}
