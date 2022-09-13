import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taletime/screens/create_story.dart';
import 'package:taletime/screens/speaker_homepage.dart';

import '../screens/add_story_page.dart';
import '../screens/listener_homepage.dart';
import '../screens/settings.dart';

class NavBarSpeaker extends StatefulWidget{
  //final DocumentSnapshot profile;
  final profile;
  final profiles;
  const NavBarSpeaker(this.profile, this.profiles, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _NavBarSpeakerState(this.profile, this.profiles);
  }
}

class _NavBarSpeakerState extends State<NavBarSpeaker>{
  var _currentIndex = 0;

  //late final DocumentSnapshot profile;
  final profile;
  final profiles;

  _NavBarSpeakerState(this.profile, this.profiles);

  late final screens = [
    SpeakerHomePage(profile),
    const Center(child: Text("All Stories", style: TextStyle(fontSize: 50),),),
    CreateStory(),
    SettingsPage(profile, profiles),
  ];

  BottomNavigationBarItem navBarItems(IconData icons, String labels){
    return BottomNavigationBarItem(
      icon: Icon(icons,),
      label: labels,
    );
  }

  @override
  Widget build(BuildContext context)  {

    return  Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 27,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() { _currentIndex = index;}),
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