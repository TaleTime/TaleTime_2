import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:taletime/screens/settings.dart';

class NavigationDrawerWidget extends StatelessWidget {
  final padding = const EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) {
    //return Drawer(
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: kPrimaryColor,
        title: Text(AppLocalizations.of(context)!.mainMenu),
        automaticallyImplyLeading: false,
        actions: const [Icon(Icons.home)],
      ),
      body: Material(
        //color: Theme.of(context).primaryColor,
        child: ListView(
          padding: padding,
          children: <Widget>[
            const SizedBox(height: 48),
            buildMenuItem(
                text: AppLocalizations.of(context)!.settings,
                icon: Icons.settings,
                onClicked: () => selectedItem(context, 0)),
            buildMenuItem(
                text: AppLocalizations.of(context)!.favorites,
                icon: Icons.favorite,
                onClicked: () => selectedItem(context, 1)),
            //const Divider(color: Colors.white),
            buildMenuItem(
                text: "More Info",
                icon: Icons.info,
                onClicked: () => selectedItem(context, 2)),
            buildMenuItem(
                text: "Feedback",
                icon: Icons.feedback,
                onClicked: () => selectedItem(context, 3)),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem(
      {required String text, required IconData icon, VoidCallback? onClicked}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();

    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const SettingsPage(),
        ));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const SettingsPage(),
        ));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const SettingsPage(),
        ));
        break;
      case 3:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SettingsPage(),
        ));
        break;
    }
  }
}
