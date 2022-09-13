/*mainklasse ist die Hauptmenu man kann sie noch viele Funktion einfügen */
// DIese Klasse wird nicht mehr benötigt
import 'package:flutter/material.dart';
import 'package:taletime/screens/settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.mainMenu),
        automaticallyImplyLeading: false,
        actions: const [Icon(Icons.home)],
      ),
      body: ListView(
        children: [
          Container(
            height: 50,
            width: double.infinity,
            child: Row(
              children: [
                const Icon(Icons.settings),
                MaterialButton(
                  onPressed: () {
                    /** 
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SettingsPage()));
                            */
                  },
                  child: Text(
                    AppLocalizations.of(context)!.settings,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 50,
            width: double.infinity,
            child: Row(
              children: [
                const Icon(Icons.favorite),
                MaterialButton(
                  onPressed: () {},
                  child: Text(
                    AppLocalizations.of(context)!.favorites,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 50,
            width: double.infinity,
            child: Row(
              children: [
                const Icon(Icons.radio_button_checked),
                MaterialButton(
                  onPressed: () {},
                  child: const Text(
                    "Aufnahme",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 50,
            width: double.infinity,
            child: Row(
              children: [
                const Icon(Icons.info),
                MaterialButton(
                  onPressed: () {},
                  child: const Text(
                    "More Info",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 50,
            width: double.infinity,
            child: Row(
              children: [
                const Icon(Icons.feedback_rounded),
                MaterialButton(
                  onPressed: () {},
                  child: const Text(
                    "Feedback",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
