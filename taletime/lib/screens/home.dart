import 'package:flutter/material.dart';
import 'package:taletime/screens/account.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taletime/utils/navigation_drawer_widget.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Home> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              "Home",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          actions: <Widget>[
            MaterialButton(
                minWidth: 80,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const Account())));
                },
                child: Row(
                  children: const [Icon(Icons.person)],
                ))
          ],
        ),
        drawer: Drawer(child: NavigationDrawerWidget()),
        body: Column(
          children: const [],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          selectedItemColor: Colors.teal.shade300,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.play_circle),
                label: " " + AppLocalizations.of(context)!.listenNow,
                tooltip: " " + AppLocalizations.of(context)!.listenNow,
                backgroundColor: Colors.white),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: " " + AppLocalizations.of(context)!.favorites,
                tooltip: " " + AppLocalizations.of(context)!.favorites,
                backgroundColor: Colors.white),
            BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: " " + AppLocalizations.of(context)!.search,
                tooltip: " " + AppLocalizations.of(context)!.search,
                backgroundColor: Colors.white)
          ],
        ));
  }
}
