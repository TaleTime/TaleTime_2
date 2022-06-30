
import 'package:flutter/material.dart';

import '../screens/listener_homepage.dart';
import '../screens/settings.dart';

class NavBarListener extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _NavBarListenerState();
  }
}

class _NavBarListenerState extends State<NavBarListener>{
  var _currentIndex = 0;

  final screens = [
    const ListenerHomePage(),
    const Center(child: Text("Favorites", style: TextStyle(fontSize: 50),),),
    const Center(child: Text("Add Story", style: TextStyle(fontSize: 50),),),
    const Settings(),
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
          navBarItems(Icons.favorite_sharp, "Favorites"),
          navBarItems(Icons.playlist_add_sharp, "Add Story"),
          navBarItems(Icons.settings, "Settings"),
        ],
      ),
    );

  }

}