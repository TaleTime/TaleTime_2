import 'package:flutter/material.dart';
import 'package:taletime/utils/constants.dart';
import 'package:taletime/utils/decoration_util.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/* die Setting klasse habe ich nur drei funktionen eingeführt 
Sprache umsetellen dunkel umstellen und password ändern
sie muss auf jeden Fall erweitert werden .*/
class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool dark = false;
  var selected;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Decorations().appBarDecoration(
          title: AppLocalizations.of(context)!.settings, context: context),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Container(
              child: ListTile(
                leading: const Icon(Icons.language_outlined),
                title: Text(AppLocalizations.of(context)!.changeLanguage),
                trailing: DropdownButton(
                  items: ["Deutsch", "Englisch", "Arabisch"]
                      .map((e) => DropdownMenuItem(
                            child: Text('$e'),
                            value: e,
                          ))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      selected = val;
                    });
                  },
                  value: selected,
                ),
              ),
            ),
            Container(
              child: SwitchListTile(
                secondary: const Icon(
                  Icons.dark_mode_sharp,
                  color: Colors.black,
                ),
                title: Text(AppLocalizations.of(context)!.darkMode),
                value: dark,
                onChanged: (val) {
                  setState(() {
                    dark = val;
                  });
                },
                activeTrackColor: kPrimaryColor,
                activeColor: Colors.black12,
              ),
            ),
            Container(
              child: ListTile(
                leading: const Icon(Icons.password_rounded),
                title: Text(AppLocalizations.of(context)!.changePassword),
                trailing: MaterialButton(
                  onPressed: () {},
                ),
              ),
            ),
            Container(
              height: 40,
              width: double.infinity,
              child: MaterialButton(
                onPressed: () {},
                color: Colors.white,
                splashColor: Colors.green,
                child: Row(
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                    Icon(Icons.password),
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      AppLocalizations.of(context)!.changePassword,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w100),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
